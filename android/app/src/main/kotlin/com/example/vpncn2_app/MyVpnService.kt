package com.example.vpncn2_app

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Intent
import android.net.VpnService
import android.os.Build
import android.os.ParcelFileDescriptor
import android.util.Log
import androidx.core.app.NotificationCompat
import java.io.FileInputStream
import java.io.FileOutputStream
import java.net.InetSocketAddress
import java.net.Socket
import java.nio.ByteBuffer
import java.nio.channels.FileChannel
import java.util.concurrent.atomic.AtomicBoolean
import java.util.concurrent.ConcurrentHashMap
import java.util.concurrent.Executors

// Using mobileproxy AAR
import mobileproxy.Mobileproxy
import mobileproxy.Proxy

class MyVpnService : VpnService() {

    companion object {
        const val ACTION_CONNECT = "connect"
        const val ACTION_DISCONNECT = "disconnect"
        @Volatile var isConnected: Boolean = false
        private const val NOTI_ID = 77
        private const val CHANNEL_ID = "vpn"
        private const val TAG = "MyVpnService"
    }

    private var tunFd: ParcelFileDescriptor? = null
    private var proxy: Proxy? = null
    private var tun2socksThread: Thread? = null
    private val isRunning = AtomicBoolean(false)
    private val connectionPool = ConcurrentHashMap<String, Socket>()
    private val executor = Executors.newFixedThreadPool(10)

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.d(TAG, "onStartCommand called with action: ${intent?.action}")
        when (intent?.action) {
            ACTION_CONNECT -> startVpn(intent)
            ACTION_DISCONNECT -> stopVpn()
        }
        return START_STICKY
    }

    private fun ensureChannel(): String {
        if (Build.VERSION.SDK_INT >= 26) {
            val nm = getSystemService(NotificationManager::class.java)
            nm.createNotificationChannel(
                NotificationChannel(CHANNEL_ID, "VPN", NotificationManager.IMPORTANCE_LOW)
            )
        }
        return CHANNEL_ID
    }

    private fun startForegroundNotif() {
        val n = NotificationCompat.Builder(this, ensureChannel())
            .setSmallIcon(android.R.drawable.ic_lock_lock)
            .setContentTitle("OutlineVPN")
            .setContentText("Connected - Traffic routed through VPN")
            .setSubText("Tap to disconnect")
            .setOngoing(true)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .build()
        startForeground(NOTI_ID, n)
        Log.d(TAG, "Foreground notification started")
    }

    private fun startVpn(intent: Intent) {
        Log.d(TAG, "startVpn called")
        // 1) Foreground noti
        startForegroundNotif()

        // 2) Get proxy address from intent (passed from Flutter)
        val proxyAddress = intent.getStringExtra("PROXY_ADDRESS") ?: ""
        val socksUpstream = intent.getStringExtra("socks_upstream") ?: ""
        
        Log.d(TAG, "ProxyAddress: $proxyAddress")
        Log.d(TAG, "SocksUpstream: $socksUpstream")
        
        try {
            // 3) Build TUN interface
            Log.d(TAG, "Building TUN interface...")
            val builder = Builder()
                .setSession("OutlineVPN")
                .setMtu(1500)
                .addAddress("10.0.0.2", 32)  // VPN client IP
                .addRoute("0.0.0.0", 0)      // Route all traffic through VPN
                .addDnsServer("8.8.8.8")
                .addDnsServer("1.1.1.1")
            
            tunFd = builder.establish()
            if (tunFd == null) {
                Log.e(TAG, "Failed to establish TUN interface")
                stopVpn()
                return
            }
            
            Log.d(TAG, "TUN interface established: ${tunFd?.fd}")
            
            // 4) Start tun2socks if we have proxy address
            if (proxyAddress.isNotEmpty()) {
                Log.d(TAG, "Starting tun2socks with proxy: $proxyAddress...")
                val parts = proxyAddress.split(":")
                if (parts.size == 2) {
                    val host = parts[0]
                    val port = parts[1].toIntOrNull() ?: 1080
                    
                    Log.d(TAG, "Starting tun2socks thread...")
                    isRunning.set(true)
                    tun2socksThread = Thread {
                        try {
                            runTun2Socks(host, port)
                        } catch (e: Exception) {
                            Log.e(TAG, "Error in tun2socks thread", e)
                        }
                    }
                    tun2socksThread?.start()
                    Log.d(TAG, "Tun2socks thread started")
                }
            }
            
            isConnected = true
            Log.d(TAG, "VPN started successfully")
            
        } catch (e: Exception) {
            Log.e(TAG, "Error starting VPN", e)
            e.printStackTrace()
            stopVpn()
        }
    }

    private fun runTun2Socks(proxyHost: String, proxyPort: Int) {
        Log.d(TAG, "Tun2socks starting with proxy: $proxyHost:$proxyPort")
        
        try {
            val tunInput = FileInputStream(tunFd?.fileDescriptor)
            val tunOutput = FileOutputStream(tunFd?.fileDescriptor)
            val tunChannel = tunInput.channel
            
            val buffer = ByteBuffer.allocate(32768)
            
            while (isRunning.get() && !Thread.currentThread().isInterrupted) {
                try {
                    buffer.clear()
                    val bytesRead = tunChannel.read(buffer)
                    
                    if (bytesRead > 0) {
                        buffer.flip()
                        val packet = ByteArray(bytesRead)
                        buffer.get(packet)
                        
                        // Forward packet to SOCKS proxy
                        forwardPacketToProxy(packet, proxyHost, proxyPort)
                    } else {
                        Thread.sleep(10)
                    }
                } catch (e: Exception) {
                    if (isRunning.get()) {
                        Log.e(TAG, "Error reading from TUN", e)
                    }
                    break
                }
            }
            
            Log.d(TAG, "Tun2socks thread stopped")
            
        } catch (e: Exception) {
            Log.e(TAG, "Error in tun2socks", e)
        }
    }
    
    private fun forwardPacketToProxy(packet: ByteArray, proxyHost: String, proxyPort: Int) {
        executor.execute {
            try {
                // Parse IP packet to get destination
                if (packet.size < 20) return@execute // Minimum IP header size
                
                val version = (packet[0].toInt() shr 4) and 0x0F
                if (version != 4) return@execute // Only support IPv4 for now
                
                val protocol = packet[9].toInt() and 0xFF
                if (protocol != 6 && protocol != 17) return@execute // Only TCP/UDP
                
                val destIp = String.format("%d.%d.%d.%d",
                    packet[16].toInt() and 0xFF,
                    packet[17].toInt() and 0xFF,
                    packet[18].toInt() and 0xFF,
                    packet[19].toInt() and 0xFF
                )
                
                val destPort = if (protocol == 6) { // TCP
                    ((packet[20].toInt() and 0xFF) shl 8) or (packet[21].toInt() and 0xFF)
                } else { // UDP
                    ((packet[22].toInt() and 0xFF) shl 8) or (packet[23].toInt() and 0xFF)
                }
                
                Log.d(TAG, "Forwarding packet to $destIp:$destPort via SOCKS5 proxy")
                
                // Use SOCKS5 proxy to connect to destination
                val connectionKey = "$destIp:$destPort"
                var socket = connectionPool[connectionKey]
                
                // Check if existing connection is still valid
                if (socket == null || socket.isClosed) {
                    socket = createSocks5Connection(proxyHost, proxyPort, destIp, destPort)
                    if (socket != null) {
                        connectionPool[connectionKey] = socket
                        Log.d(TAG, "Created new SOCKS5 connection for $connectionKey")
                    }
                }
                
                if (socket != null && !socket.isClosed) {
                    try {
                        // For TCP, forward the payload (skip IP header)
                        val headerLength = (packet[0].toInt() and 0x0F) * 4
                        val payload = packet.sliceArray(headerLength until packet.size)
                        socket.getOutputStream().write(payload)
                    } catch (e: Exception) {
                        Log.w(TAG, "Connection broken for $connectionKey, removing from pool")
                        connectionPool.remove(connectionKey)
                        try { socket.close() } catch (_: Exception) {}
                    }
                } else {
                    Log.w(TAG, "No valid connection available for $connectionKey")
                }
                
            } catch (e: Exception) {
                Log.e(TAG, "Error forwarding packet to proxy", e)
            }
        }
    }
    
    private fun createSocks5Connection(proxyHost: String, proxyPort: Int, destIp: String, destPort: Int): Socket? {
        return try {
            val socket = Socket()
            socket.connect(InetSocketAddress(proxyHost, proxyPort), 5000)
            socket.soTimeout = 5000
            val output = socket.getOutputStream()
            val input = socket.getInputStream()
            
            // SOCKS5 handshake
            output.write(byteArrayOf(0x05, 0x01, 0x00)) // Version 5, 1 auth method, No auth
            output.flush()
            
            val handshakeResponse = ByteArray(2)
            input.read(handshakeResponse)
            if (handshakeResponse[0] != 0x05.toByte() || handshakeResponse[1] != 0x00.toByte()) {
                Log.e(TAG, "SOCKS5 handshake failed for $destIp:$destPort")
                socket.close()
                return null
            }
            
            // SOCKS5 connect request
            val connectRequest = ByteArray(10)
            connectRequest[0] = 0x05 // Version
            connectRequest[1] = 0x01 // Connect
            connectRequest[2] = 0x00 // Reserved
            connectRequest[3] = 0x01 // IPv4
            
            // Destination IP
            val ipParts = destIp.split(".")
            for (i in 0..3) {
                connectRequest[4 + i] = ipParts[i].toInt().toByte()
            }
            
            // Destination port
            connectRequest[8] = (destPort shr 8).toByte()
            connectRequest[9] = destPort.toByte()
            
            output.write(connectRequest)
            output.flush()
            
            // Read connect response
            val connectResponse = ByteArray(10)
            input.read(connectResponse)
            if (connectResponse[1] != 0x00.toByte()) {
                Log.e(TAG, "SOCKS5 connect failed for $destIp:$destPort, response: ${connectResponse[1]}")
                socket.close()
                return null
            }
            
            Log.d(TAG, "SOCKS5 connection established to $destIp:$destPort")
            socket
        } catch (e: Exception) {
            Log.e(TAG, "Failed to create SOCKS5 connection to $destIp:$destPort", e)
            null
        }
    }

    private fun stopVpn() {
        Log.d(TAG, "stopVpn called")
        
        // Stop tun2socks thread
        isRunning.set(false)
        tun2socksThread?.interrupt()
        try {
            tun2socksThread?.join(1000)
        } catch (e: InterruptedException) {
            Log.e(TAG, "Error stopping tun2socks thread", e)
        }
        tun2socksThread = null
        
        // Close all SOCKS5 connections
        connectionPool.values.forEach { socket ->
            try {
                socket.close()
            } catch (e: Exception) {
                Log.e(TAG, "Error closing SOCKS5 connection", e)
            }
        }
        connectionPool.clear()
        
        // Shutdown executor
        executor.shutdown()
        
        try { 
            proxy?.stop(0) 
            Log.d(TAG, "Proxy stopped")
        } catch (e: Throwable) {
            Log.e(TAG, "Error stopping proxy", e)
        }
        proxy = null
        try { tunFd?.close() } catch (_: Throwable) {}
        tunFd = null
        isConnected = false
        stopForeground(STOP_FOREGROUND_REMOVE) // minSdk 29 nên dùng được
        stopSelf()
        Log.d(TAG, "VPN service stopped")
    }

    override fun onDestroy() {
        stopVpn()
        super.onDestroy()
    }
}
