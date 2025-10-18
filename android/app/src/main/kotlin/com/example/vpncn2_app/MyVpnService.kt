package com.example.vpncn2_app

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Intent
import android.net.VpnService
import android.os.Build
import android.os.ParcelFileDescriptor
import android.util.Log
import androidx.core.app.NotificationCompat
import outline.Client
import outline.ClientConfig
import outline.GoBackendConfig
import outline.NewClientResult
import outline.Outline
import platerrors.PlatformError
import tun2socks.RemoteDevice
import tun2socks.Tun2socks
import java.util.concurrent.atomic.AtomicBoolean
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors

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
    private var outlineClient: Client? = null
    private var remoteDevice: RemoteDevice? = null
    private var relayThread: Thread? = null
    private val isRelaying = AtomicBoolean(false)
    private val lifecycleLock = Any()
    private val starterExecutor: ExecutorService =
        Executors.newSingleThreadExecutor { r ->
            Thread(r, "outline-vpn-starter").apply { isDaemon = true }
        }

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

    private fun configureGoBackend() {
        try {
            val backendConfig: GoBackendConfig = Outline.getBackendConfig()
            if (backendConfig.dataDir.isNullOrEmpty()) {
                backendConfig.dataDir = filesDir.absolutePath
                Log.d(TAG, "Configured Outline backend data dir: ${backendConfig.dataDir}")
            }
        } catch (e: Exception) {
            Log.w(TAG, "Unable to configure Outline backend", e)
        }
    }

    private fun startVpn(intent: Intent) {
        Log.d(TAG, "startVpn called")
        startForegroundNotif()

        val ssConfig = intent.getStringExtra("CONFIG") ?: ""
        val keyId = intent.getStringExtra("KEY_ID") ?: "outline-key"
        val keyName = intent.getStringExtra("KEY_NAME") ?: "OutlineVPN"

        if (ssConfig.isEmpty()) {
            Log.e(TAG, "Missing Shadowsocks config, aborting VPN start")
            stopVpn()
            return
        }

        starterExecutor.execute {
            synchronized(lifecycleLock) {
                if (isConnected) {
                    Log.d(TAG, "Existing VPN session detected, restarting")
                    stopVpnLocked(stopService = false)
                }

                try {
                    Log.d(TAG, "Building TUN interface...")
                    val builder = Builder()
                        .setSession(keyName)
                        .setMtu(1500)
                        .addAddress("10.0.0.2", 32)
                        .addRoute("0.0.0.0", 0)
                        .addDnsServer("8.8.8.8")
                        .addDnsServer("1.1.1.1")

                    tunFd = builder.establish()
                    if (tunFd == null) {
                        Log.e(TAG, "Failed to establish TUN interface")
                        stopVpnLocked()
                        return@synchronized
                    }
                    Log.d(TAG, "TUN interface established: ${tunFd?.fd}")

                    configureGoBackend()
                    Outline.touch()
                    Tun2socks.touch()

                    val clientResult = createOutlineClient(ssConfig, keyId)
                    val clientError = clientResult.error
                    if (clientError != null) {
                        Log.e(TAG, "Failed to create Outline client: ${clientError.message}")
                        stopVpnLocked()
                        return@synchronized
                    }

                    outlineClient = clientResult.client
                    outlineClient?.startSession()
                    Log.d(TAG, "Outline session started")

                    val deviceResult = Tun2socks.connectRemoteDevice(outlineClient)
                    val deviceError = deviceResult.error
                    if (deviceError != null) {
                        Log.e(TAG, "Failed to connect remote device: ${deviceError.message}")
                        stopVpnLocked()
                        return@synchronized
                    }

                    remoteDevice = deviceResult.device
                    startRelayingTraffic(remoteDevice!!)

                    isConnected = true
                    Log.d(TAG, "VPN started successfully")
                } catch (e: Exception) {
                    Log.e(TAG, "Error starting VPN", e)
                    stopVpnLocked()
                }
            }
        }
        return clientConfig.new_(keyId, configText)
    }

    private fun createOutlineClient(configText: String, keyId: String): NewClientResult {
        val clientConfig = ClientConfig().apply {
            dataDir = filesDir.absolutePath
        }
        return clientConfig.new_(keyId, configText)
    }

    private fun startRelayingTraffic(device: RemoteDevice) {
        val fd = tunFd ?: throw IllegalStateException("TUN FD not available")
        if (isRelaying.getAndSet(true)) {
            Log.w(TAG, "Relay thread already running")
            return
        }

        relayThread = Thread {
            Log.d(TAG, "Starting Outline goRelayTraffic")
            val error: PlatformError? = Tun2socks.goRelayTraffic(fd.fd.toLong(), device)
            if (error != null) {
                Log.e(TAG, "goRelayTraffic error: ${error.message}")
            } else {
                Log.d(TAG, "goRelayTraffic finished without error")
            }
        }.apply { start() }
    }

    private fun stopVpnLocked(stopService: Boolean = true) {
        Log.d(TAG, "stopVpnLocked invoked (stopService=$stopService)")

        try {
            remoteDevice?.close()
        } catch (e: Exception) {
            Log.w(TAG, "Error closing remote device", e)
        }
        remoteDevice = null

        isRelaying.set(false)
        relayThread?.interrupt()
        try {
            relayThread?.join(1000)
        } catch (e: InterruptedException) {
            Log.w(TAG, "Interrupted while stopping relay thread", e)
        }
        relayThread = null

        try {
            outlineClient?.endSession()
        } catch (e: Exception) {
            Log.w(TAG, "Error ending Outline session", e)
        }
        outlineClient = null

        try {
            tunFd?.close()
        } catch (e: Exception) {
            Log.w(TAG, "Error closing TUN FD", e)
        }
        tunFd = null

        isConnected = false
        if (stopService) {
            stopForeground(STOP_FOREGROUND_REMOVE)
            stopSelf()
            Log.d(TAG, "VPN service stopped")
        }
    }

    private fun stopVpn() {
        synchronized(lifecycleLock) {
            stopVpnLocked()
        }
    }

    override fun onDestroy() {
        stopVpn()
        starterExecutor.shutdownNow()
        super.onDestroy()
    }
}
