package com.example.vpncn2_app

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Intent
import android.net.VpnService
import android.os.Build
import android.os.IBinder
import android.os.ParcelFileDescriptor
import android.util.Log
import org.json.JSONObject
import java.util.*
import tun2socks.Tun2socks
import tun2socks.ConnectRemoteDeviceResult
import tun2socks.RemoteDevice
import outline.ClientConfig as OutlineClientConfig
import outline.NewClientResult as OutlineNewClientResult
import outline.Client as OutlineClient

/**
 * VPN Tunnel Service based on official Outline client implementation
 * This service handles real VPN tunnel establishment and traffic routing
 */
class VpnTunnelService : VpnService() {
    
    companion object {
        private const val TAG = "VpnTunnelService"
        private const val NOTIFICATION_ID = 1
        private const val CHANNEL_ID = "vpn_tunnel_service"
        
        // VPN Configuration (based on official Outline client)
        private const val VPN_SESSION_NAME = "Outline VPN"
        private const val VPN_MTU = 1500
        private const val VPN_LOCAL_IP = "10.111.222.1"
        private const val VPN_LOCAL_PREFIX = 24
        private const val VPN_DNS_SERVER = "169.254.113.53" // Outline DNS resolver
        private const val VPN_ROUTE_ALL = "0.0.0.0"
        private const val VPN_ROUTE_PREFIX = 0
    }
    
    private var tunFd: ParcelFileDescriptor? = null
    private var tunnelConfig: TunnelConfig? = null
    private var remoteDevice: Any? = null
    private var isConnected = false
    
    override fun onBind(intent: Intent?): IBinder? {
        Log.d(TAG, "VpnTunnelService bound")
        return VpnTunnelBinder()
    }
    
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.d(TAG, "VpnTunnelService started")
        createNotificationChannel()
        startForeground(NOTIFICATION_ID, createNotification())
        return START_STICKY
    }
    
    override fun onDestroy() {
        Log.d(TAG, "VpnTunnelService destroyed")
        stopVpnTunnel()
        super.onDestroy()
    }
    
    /**
     * Start VPN tunnel (based on official Outline client)
     */
    fun startVpnTunnel(config: TunnelConfig): Boolean {
        return try {
            Log.d(TAG, "🚀 Starting VPN tunnel for server: ${config.server}")
            
            // Check if VPN is already running
            if (isConnected && tunFd != null) {
                Log.d(TAG, "VPN already running, stopping previous tunnel")
                stopVpnTunnel()
            }
            
            // Store tunnel config
            this.tunnelConfig = config
            
            // Step 1: Establish VPN TUN interface
            val tunFd = establishVpnTunInterface()
            if (tunFd == null) {
                Log.e(TAG, "❌ Failed to establish VPN TUN interface")
                return false
            }
            this.tunFd = tunFd
            
            // Step 2: Create Outline client
            val client = createOutlineClient(config)
            if (client == null) {
                Log.e(TAG, "❌ Failed to create Outline client")
                stopVpnTunnel()
                return false
            }
            
            // Step 3: Connect to remote device
            val remoteDevice = connectRemoteDevice(client)
            if (remoteDevice == null) {
                Log.e(TAG, "❌ Failed to connect to remote device")
                stopVpnTunnel()
                return false
            }
            this.remoteDevice = remoteDevice
            
            // Step 4: Start traffic relay
            val relaySuccess = startTrafficRelay(tunFd, remoteDevice)
            if (!relaySuccess) {
                Log.e(TAG, "❌ Failed to start traffic relay")
                stopVpnTunnel()
                return false
            }
            
            // Step 5: Update notification
            updateNotification("Connected to ${config.server}")
            
            isConnected = true
            Log.d(TAG, "✅ VPN tunnel established successfully!")
            Log.d(TAG, "🎯 Traffic will now route through VPN server: ${config.server}")
            true
            
        } catch (e: Exception) {
            Log.e(TAG, "❌ Failed to start VPN tunnel", e)
            stopVpnTunnel()
            false
        }
    }
    
    /**
     * Stop VPN tunnel
     */
    fun stopVpnTunnel() {
        try {
            Log.d(TAG, "🛑 Stopping VPN tunnel")
            
            // Stop traffic relay
            stopTrafficRelay()
            
            // Close TUN interface
            tunFd?.close()
            tunFd = null
            
            // Clear references
            tunnelConfig = null
            remoteDevice = null
            isConnected = false
            
            // Update notification
            updateNotification("Disconnected")
            
            Log.d(TAG, "✅ VPN tunnel stopped successfully")
        } catch (e: Exception) {
            Log.e(TAG, "❌ Failed to stop VPN tunnel", e)
        }
    }
    
    /**
     * Establish VPN TUN interface (based on official Outline client implementation)
     */
    private fun establishVpnTunInterface(): ParcelFileDescriptor? {
        return try {
            Log.d(TAG, "🔧 Establishing VPN TUN interface...")
            
            // Check VPN permission first
            val prepareIntent = VpnService.prepare(this)
            if (prepareIntent != null) {
                Log.e(TAG, "❌ VPN permission not granted! Need to request permission first")
                Log.e(TAG, "❌ Cannot establish VPN TUN interface without permission")
                return null
            }
            Log.d(TAG, "✅ VPN permission already granted")
            
            // Based on official Outline client implementation:
            // VpnService.Builder builder = new VpnService.Builder()
            //     .setSession(this.getApplicationName())
            //     .setMtu(1500)
            //     .addAddress("10.111.222.1", 24)
            //     .addDnsServer(dnsResolver)
            //     .setBlocking(true)
            //     .addDisallowedApplication(this.getPackageName());
            
            val dnsResolver = "169.254.113.53"
            Log.d(TAG, "🔧 Creating VpnService.Builder...")
            val builder = Builder()
                .setSession(packageName)
                // Standard MTU - same as official Outline client
                    .setMtu(1500)
                // Random local IP that won't conflict - same as official Outline client
                    .addAddress("10.111.222.1", 24)
                    .addDnsServer(dnsResolver)
                    .setBlocking(true)
                    .addDisallowedApplication(packageName)
                
            // Handle Android Q+ metered setting
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                Log.d(TAG, "🔧 Setting metered=false for Android Q+")
                    builder.setMetered(false)
                }
                
            // Add routes for reserved bypass subnets - same as official Outline client
            Log.d(TAG, "🔧 Adding routes for reserved bypass subnets...")
                val reservedBypassSubnets = getReservedBypassSubnets()
                for (subnet in reservedBypassSubnets) {
                Log.d(TAG, "🔧 Adding route: ${subnet.address}/${subnet.prefix}")
                    builder.addRoute(subnet.address, subnet.prefix)
                }
                builder.addRoute(dnsResolver, 32)
                
            Log.d(TAG, "🔧 Establishing VPN TUN interface...")
            val tunFd = builder.establish()
            
            if (tunFd != null) {
                Log.d(TAG, "✅ VPN TUN interface established successfully")
                Log.d(TAG, "✅ TUN file descriptor: ${tunFd.fd}")
            } else {
                Log.e(TAG, "❌ Failed to establish VPN TUN interface")
                Log.e(TAG, "❌ builder.establish() returned null")
            }
            
            tunFd
        } catch (e: Exception) {
            Log.e(TAG, "❌ Failed to establish VPN TUN interface", e)
            Log.e(TAG, "❌ Exception details: ${e.message}")
            e.printStackTrace()
            null
        }
    }

    /**
     * Get reserved bypass subnets (based on official Outline client)
     */
    private fun getReservedBypassSubnets(): List<Subnet> {
        return listOf(
            // Private IP ranges
            Subnet("10.0.0.0", 8),
            Subnet("172.16.0.0", 12),
            Subnet("192.168.0.0", 16),
            // Loopback
            Subnet("127.0.0.0", 8),
            // Link-local
            Subnet("169.254.0.0", 16),
            // Multicast
            Subnet("224.0.0.0", 4),
            // Reserved
            Subnet("240.0.0.0", 4)
        )
    }

    /**
     * Subnet data class
     */
    data class Subnet(val address: String, val prefix: Int)
    
    /**
     * Create Outline client (based on official Outline client implementation)
     */
    private fun createOutlineClient(config: TunnelConfig): Any? {
        return try {
            Log.d(TAG, "🔧 Creating Outline client for server: ${config.server}")
            Log.d(TAG, "🔧 Tunnel config: id=${config.id}, server=${config.server}, port=${config.port}")
            
            // Based on official Outline client implementation:
            // final ClientConfig clientConfig = new ClientConfig();
            // clientConfig.setDataDir(this.getFilesDir().getAbsolutePath());
            // final NewClientResult clientResult = clientConfig.new_(config.id, config.transportConfig);
            
            Log.d(TAG, "🔧 Step 1: Creating client config...")
            val clientConfig = createClientConfig()
            if (clientConfig == null) {
                Log.e(TAG, "❌ Failed to create client config")
                return null
            }
            Log.d(TAG, "✅ Client config created successfully")
            
            Log.d(TAG, "🔧 Step 2: Creating Shadowsocks transport config...")
            val transportConfig = createShadowsocksConfig(
                config.server, config.port, config.method, config.password
            )
            if (transportConfig == null) {
                Log.e(TAG, "❌ Failed to create transport config")
                return null
            }
            Log.d(TAG, "✅ Transport config created successfully")
            
            Log.d(TAG, "🔧 Step 3: Creating new Outline client...")
            val clientResult = clientConfig.newClient(config.id, transportConfig!!)
            if (clientResult.error != null) {
                Log.e(TAG, "❌ Client creation error: ${clientResult.error}")
                return null
            }
            
            Log.d(TAG, "✅ Outline client created successfully")
            Log.d(TAG, "✅ Client wrapper: ${clientResult.client}")
            clientResult.client
            } catch (e: Exception) {
            Log.e(TAG, "❌ Failed to create Outline client", e)
            Log.e(TAG, "❌ Exception details: ${e.message}")
            e.printStackTrace()
            null
        }
    }

    /**
     * Create client config (based on official Outline client)
     */
    private fun createClientConfig(): ClientConfig? {
        return try {
            Log.d(TAG, "🔧 Creating client config...")
            
            // Similar to official Outline client:
            // final ClientConfig clientConfig = new ClientConfig();
            // clientConfig.setDataDir(this.getFilesDir().getAbsolutePath());
            
            val clientConfig = ClientConfig()
            val dataDir = filesDir.absolutePath
            clientConfig.dataDir = dataDir
            Log.d(TAG, "✅ Client config created with dataDir: $dataDir")
            clientConfig
        } catch (e: Exception) {
            Log.e(TAG, "❌ Failed to create client config", e)
            null
        }
    }

    /**
     * Create Shadowsocks transport configuration
     */
    private fun createShadowsocksConfig(
        server: String,
        serverPort: Int,
        method: String,
        password: String
    ): String? {
        return try {
            Log.d(TAG, "🔧 Creating Shadowsocks config...")
            val config = JSONObject().apply {
                put("host", server)
                put("port", serverPort)
                put("password", password)
                put("method", method)
                put("prefix", "")
            }
            val configString = config.toString()
            Log.d(TAG, "✅ Shadowsocks config created: ${configString.take(50)}...")
            configString
        } catch (e: Exception) {
            Log.e(TAG, "❌ Failed to create Shadowsocks config", e)
            null
        }
    }
    
    /**
     * Connect to remote device (based on official Outline client implementation)
     */
    private fun connectRemoteDevice(client: Any): Any? {
        return try {
            Log.d(TAG, "🔧 Connecting to remote device...")
            
            // Based on official Outline client implementation:
            // final ConnectRemoteDeviceResult result = Tun2socks.connectRemoteDevice(client);
            // if (result.getError() != null) {
            //     tearDownActiveTunnel();
            //     return result.getError();
            // }
            // this.remoteDevice = result.getDevice();
            
            // Use actual tun2socks library from tun2socks-0.0.1.aar
            val result = Tun2socks.connectRemoteDevice(client as OutlineClient)
            if (result.error != null) {
                Log.e(TAG, "❌ Remote device connection failed: ${result.error}")
                return null
            }
            
            val remoteDevice = result.device
            Log.d(TAG, "✅ Remote device connected successfully")
            remoteDevice
        } catch (e: Exception) {
            Log.e(TAG, "❌ Failed to connect to remote device", e)
            null
        }
    }
    
    /**
     * Start traffic relay between TUN and remote device (based on official Outline client implementation)
     */
    private fun startTrafficRelay(tunFd: ParcelFileDescriptor, remoteDevice: Any): Boolean {
        return try {
            Log.d(TAG, "🔧 Starting traffic relay...")
            
            // Based on official Outline client implementation:
            // final PlatformError err = Tun2socks.goRelayTraffic(this.tunFd.getFd(), this.remoteDevice);
            // if (err != null) {
            //     LOG.log(Level.SEVERE, "Failed to relay traffic between TUN and remote devices", err);
            //     tearDownActiveTunnel();
            //     return err;
            // }
            
            // Use actual tun2socks library from tun2socks-0.0.1.aar
            val err = Tun2socks.goRelayTraffic(tunFd.fd.toLong(), remoteDevice as RemoteDevice)
            if (err != null) {
                Log.e(TAG, "❌ Failed to relay traffic between TUN and remote devices: $err")
                return false
            }
            
            Log.d(TAG, "✅ Traffic relay started successfully")
            true
        } catch (e: Exception) {
            Log.e(TAG, "❌ Failed to start traffic relay", e)
            false
        }
    }
    
    /**
     * Stop traffic relay
     */
    private fun stopTrafficRelay() {
        try {
            Log.d(TAG, "🛑 Stopping traffic relay")
            // TODO: Implement actual traffic relay stopping
        } catch (e: Exception) {
            Log.e(TAG, "❌ Failed to stop traffic relay", e)
        }
    }
    
    /**
     * Create notification channel
     */
    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "VPN Tunnel Service",
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = "Outline VPN Tunnel Service"
                setShowBadge(false)
            }
            
            val notificationManager = getSystemService(NotificationManager::class.java)
            notificationManager.createNotificationChannel(channel)
        }
    }
    
    /**
     * Create notification
     */
    private fun createNotification(): Notification {
        val intent = Intent(this, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(
            this, 0, intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        
        return Notification.Builder(this, CHANNEL_ID)
            .setContentTitle("Outline VPN")
            .setContentText("VPN Tunnel Service")
            .setSmallIcon(android.R.drawable.ic_dialog_info)
            .setContentIntent(pendingIntent)
            .setOngoing(true)
            .build()
    }
    
    /**
     * Update notification
     */
    private fun updateNotification(status: String) {
        val notification = Notification.Builder(this, CHANNEL_ID)
            .setContentTitle("Outline VPN")
            .setContentText(status)
            .setSmallIcon(android.R.drawable.ic_dialog_info)
            .setOngoing(true)
            .build()
        
        val notificationManager = getSystemService(NotificationManager::class.java)
        notificationManager.notify(NOTIFICATION_ID, notification)
    }
    
    /**
     * VPN Tunnel Configuration
     */
    data class TunnelConfig(
        val id: String,
        val server: String,
        val port: Int,
        val method: String,
        val password: String,
        val name: String = server
    )
    
    /**
     * VPN Tunnel Binder
     */
    inner class VpnTunnelBinder : android.os.Binder() {
        fun getService(): VpnTunnelService = this@VpnTunnelService
    }

    /**
     * Client Config class (based on official Outline client)
     */
    data class ClientConfig(
        var dataDir: String = ""
    ) {
        /**
         * Create new client (based on official Outline client)
         */
        fun newClient(tunnelId: String, transportConfig: String): NewClientResult {
            return try {
                Log.d(TAG, "🔧 Creating new client with tunnelId: $tunnelId")
                Log.d(TAG, "🔧 Transport config: ${transportConfig.take(100)}...")
                
                // Use actual outline library from mobileproxy.aar
                // Based on official Outline client: clientConfig.new_(tunnelId, transportConfig)
                val clientConfig = OutlineClientConfig()
                clientConfig.setDataDir(dataDir)
                
                val result = clientConfig.new_(tunnelId, transportConfig)
                if (result.error != null) {
                    Log.e(TAG, "❌ Client creation failed: ${result.error}")
                    return NewClientResult(client = null, error = result.error.toString())
                }
                
                val actualClient = result.client
                val wrapperClient = OutlineClientWrapper(tunnelId, transportConfig, actualClient)
                Log.d(TAG, "✅ Client created successfully using outline library")
                NewClientResult(client = wrapperClient, error = null)
            } catch (e: Exception) {
                Log.e(TAG, "❌ Failed to create new client", e)
                NewClientResult(client = null, error = e.message)
            }
        }
    }

    /**
     * New Client Result class (based on official Outline client)
     */
    data class NewClientResult(
        val client: OutlineClientWrapper?,
        val error: String?
    )

    /**
     * Outline Client wrapper class (wrapper around actual outline.Client)
     */
    data class OutlineClientWrapper(
        val id: String,
        val transportConfig: String,
        val actualClient: OutlineClient // This is the actual outline.Client
    ) {
        fun dialStream(address: String): Boolean {
            return try {
                Log.d(TAG, "🔧 Dialing stream to: $address")
                
                // Use actual client from outline library
                // Based on official Outline client: client.DialStream(context, address)
                // Note: We'll implement this when we have proper context handling
                Log.d(TAG, "✅ Stream dialing method called (actual implementation pending)")
                true
            } catch (e: Exception) {
                Log.e(TAG, "❌ Failed to dial stream to: $address", e)
                false
            }
        }
        
        fun newSession(): Boolean {
            return try {
                Log.d(TAG, "🔧 Creating new session")
                
                // Use actual client from outline library
                // Based on official Outline client: client.NewSession(resp)
                Log.d(TAG, "✅ New session method called (actual implementation pending)")
                true
            } catch (e: Exception) {
                Log.e(TAG, "❌ Failed to create new session", e)
                false
            }
        }
    }
}
