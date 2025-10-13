package com.example.vpncn2_app

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Intent
import android.net.VpnService
import android.os.Build
import android.os.ParcelFileDescriptor
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.Random
import mobileproxy.Mobileproxy
import mobileproxy.Proxy

class MainActivity : FlutterActivity() {
    private val OUTLINE_BRIDGE_CHANNEL = "com/example/vpncn2_app"
    private val VPN_SERVICE_CHANNEL = "vpncn2/vpn_service"
    private val VPN_STATUS_CHANNEL = "vpncn2/vpn_status"
    private val OUTLINE_SDK_CHANNEL = "outline_sdk"

    private var proxy: Proxy? = null
    private var proxyAddress: String? = null

    private var vpnPermissionResult: MethodChannel.Result? = null
    private val REQUEST_VPN_PERMISSION = 1001

    private lateinit var vpnStatusEventChannel: EventChannel
    private var vpnStatusHandler: VpnStatusStreamHandler? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, OUTLINE_BRIDGE_CHANNEL)
                .setMethodCallHandler { call, result ->
                    when (call.method) {
                        "startOutlineProxy" -> startOutlineProxy(call, result)
                        "stopOutlineProxy", "stopOutline" -> stopOutlineProxy(result)
                        "getStatus" -> getStatus(result)
                        else -> result.notImplemented()
                    }
                }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, VPN_SERVICE_CHANNEL)
                .setMethodCallHandler { call, result ->
                    when (call.method) {
                        "initialize" -> initializeVpnService(result)
                        "requestPermission" -> requestVpnPermission(result)
                        "startVpn" -> startVpn(result)
                        "stopVpn" -> stopVpn(result)
                        else -> result.notImplemented()
                    }
                }

        vpnStatusHandler = VpnStatusStreamHandler()
        vpnStatusEventChannel =
                EventChannel(flutterEngine.dartExecutor.binaryMessenger, VPN_STATUS_CHANNEL)
        vpnStatusEventChannel.setStreamHandler(vpnStatusHandler)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, OUTLINE_SDK_CHANNEL)
                .setMethodCallHandler { call, result ->
                    when (call.method) {
                        "ping" -> ping(result)
                        "outlineInit" -> outlineInit(result)
                        "connectWithKey" -> connectWithKey(call, result)
                        "disconnectViaSdk" -> disconnectViaSdk(call, result)
                        "requestVpnPermission" -> requestVpnPermission(result)
                        "testConnectivity" -> testConnectivity(call, result)
                        "getVpnServerIp" -> getVpnServerIp(call, result)
                        "startLocalProxy" -> startLocalProxy(call, result)
                        "stopLocalProxy" -> stopLocalProxy(result)
                        else -> result.notImplemented()
                    }
                }
    }

    // ---------------- Proxy (local) ----------------
    private fun startOutlineProxy(call: MethodCall, result: MethodChannel.Result) {
        try {
            Log.d("MainActivity", "🔧 Starting outline proxy")
            val key = call.argument<String>("key") ?: throw IllegalArgumentException("Missing key")
            val portStr = call.argument<String>("port") ?: "1080"
            var port = portStr.toIntOrNull() ?: 1080
            if (port < 1024) port = 1080

            Log.d("MainActivity", "🔧 Starting outline proxy on port $port")
            proxy =
                    Mobileproxy.runProxy(
                            "127.0.0.1:$port",
                            Mobileproxy.newStreamDialerFromConfig(key)
                    )
            proxyAddress = proxy?.address()
            Log.d("MainActivity", "🔧 Result run proxy: $proxyAddress")
            result.success("$proxyAddress")
        } catch (e: Exception) {
            Log.e("MainActivity", "Failed to start proxy", e)
            result.error("PROXY_ERROR", "Failed to start proxy: ${e.message}", null)
        }
    }

    private fun stopOutlineProxy(result: MethodChannel.Result) {
        try {
            proxy?.stop(0)
            proxy = null
            proxyAddress = null
            result.success("Proxy stopped")
        } catch (e: Exception) {
            Log.e("MainActivity", "Failed to stop proxy", e)
            result.error("PROXY_ERROR", "Failed to stop proxy: ${e.message}", null)
        }
    }

    private fun getStatus(result: MethodChannel.Result) {
        result.success(if (proxy != null) "running" else "stopped")
    }

    // ---------------- VPN (VpnService) ----------------
    private fun initializeVpnService(result: MethodChannel.Result) {
        try {
            Log.d("MainActivity", "🔧 Initializing VPN service...")
            result.success(true)
        } catch (e: Exception) {
            Log.e("MainActivity", "VPN service initialization failed", e)
            result.error("VPN_ERROR", "Failed to initialize VPN service: ${e.message}", null)
        }
    }

    private fun requestVpnPermission(result: MethodChannel.Result) {
        try {
            val intent = VpnService.prepare(this)
            if (intent == null) {
                result.success(true)
            } else {
                vpnPermissionResult = result
                startActivityForResult(intent, REQUEST_VPN_PERMISSION)
            }
        } catch (e: Exception) {
            Log.e("MainActivity", "requestVpnPermission error", e)
            result.error("VPN_ERROR", "Failed to request VPN permission: ${e.message}", null)
        }
    }

    // private fun startVpn(result: MethodChannel.Result) {
    //     try {
    //         val intent = VpnService.prepare(this)
    //         if (intent != null) {
    //             result.error("VPN_PERMISSION_REQUIRED", "VPN permission not granted", null)
    //             return
    //         }
    //         val svc = Intent(this, MyVpnService::class.java).apply {
    //             proxyAddress?.let { putExtra("localSocks", it) }
    //         }
    //         if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) startForegroundService(svc) else
    // startService(svc)
    //         vpnStatusHandler?.sendStatus("connected")
    //         result.success(true)
    //     } catch (e: Exception) {
    //         Log.e("MainActivity", "Failed to start VPN", e)
    //         result.error("VPN_ERROR", "Failed to start VPN: ${e.message}", null)
    //     }
    // }
    private fun startVpn(result: MethodChannel.Result) {
        try {
            val intent = VpnService.prepare(this)
            if (intent != null) {
                result.error("VPN_PERMISSION_REQUIRED", "VPN permission not granted", null)
                return
            }

            // ví dụ upstream SOCKS5:
            val socksUpstream = "127.0.0.1:1080" // THAY bằng upstream thật của bạn
            val svc =
                    Intent(this, MyVpnService::class.java).apply {
                        putExtra("socks_upstream", socksUpstream)
                        // (tuỳ chọn) chỉ app này qua VPN:
                        putExtra("per_app", true)
                    }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) startForegroundService(svc)
            else startService(svc)
            result.success(true)
        } catch (e: Exception) {
            Log.e("MainActivity", "Failed to start VPN", e)
            result.error("VPN_ERROR", "Failed to start VPN: ${e.message}", null)
        }
    }

    private fun stopVpn(result: MethodChannel.Result) {
        try {
            stopService(Intent(this, MyVpnService::class.java))
            vpnStatusHandler?.sendStatus("disconnected")
            result.success(true)
        } catch (e: Exception) {
            Log.e("MainActivity", "Failed to stop VPN", e)
            result.error("VPN_ERROR", "Failed to stop VPN: ${e.message}", null)
        }
    }

    // ---------------- Outline SDK methods ----------------
    private fun ping(result: MethodChannel.Result) {
        result.success("pong")
    }

    private fun outlineInit(result: MethodChannel.Result) {
        try {
            result.success("""{"success": true, "message": "Outline SDK initialized"}""")
        } catch (e: Exception) {
            result.success("""{"success": false, "error": "${e.message}"}""")
        }
    }

    private fun connectWithKey(call: MethodCall, result: MethodChannel.Result) {
        try {
            val keyString = call.argument<String>("key") ?: ""
            val portString = call.argument<String>("port") ?: "443" // remote port
            val localSocks =
                    call.argument<String>("localSocks")
                            ?: proxyAddress // ✅ nhận từ Flutter, fallback proxyAddress

            Log.d(
                    "MainActivity",
                    "🔑 Connecting with key: $keyString, remotePort: $portString, localSocks=$localSocks"
            )

            val keyData =
                    hashMapOf<String, Any>("key" to keyString, "port" to portString).apply {
                        if (!localSocks.isNullOrEmpty()) put("localSocks", localSocks!!)
                    }

            val svc =
                    Intent(this, MyVpnService::class.java).apply {
                        putExtra("key_data", keyData)
                        if (!localSocks.isNullOrEmpty()) putExtra("localSocks", localSocks)
                    }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) startForegroundService(svc)
            else startService(svc)

            result.success("""{"success": true}""")
        } catch (e: Exception) {
            Log.e("MainActivity", "connectWithKey error", e)
            result.success("""{"success": false, "error": "${e.message}"}""")
        }
    }

    private fun disconnectViaSdk(call: MethodCall, result: MethodChannel.Result) {
        try {
            stopService(Intent(this, MyVpnService::class.java))
            result.success(true)
        } catch (e: Exception) {
            Log.e("MainActivity", "disconnectViaSdk", e)
            result.error("SDK_ERROR", "Failed: ${e.message}", null)
        }
    }

    private fun testConnectivity(call: MethodCall, result: MethodChannel.Result) {
        try {
            result.success(
                    """{"success": true, "tcpResult": {"success": true, "duration": 150}, "udpResult": {"success": true, "duration": 120}, "transport": "tcp"}"""
            )
        } catch (e: Exception) {
            result.success(
                    """{"success": false, "tcpResult": {"success": false, "error": "${e.message}"}, "udpResult": {"success": false, "error": "${e.message}"}, "transport": "tcp"}"""
            )
        }
    }

    private fun getVpnServerIp(call: MethodCall, result: MethodChannel.Result) {
        try {
            result.success("192.168.1.100")
        } catch (e: Exception) {
            Log.e("MainActivity", "getVpnServerIp", e)
            result.error("SDK_ERROR", "Failed: ${e.message}", null)
        }
    }

    private fun startLocalProxy(call: MethodCall, result: MethodChannel.Result) {
        try {
            val key = call.argument<String>("key") ?: throw IllegalArgumentException("Missing key")
            var port = Random().nextInt(1024) + 1024
            proxy =
                    Mobileproxy.runProxy(
                            "127.0.0.1:$port",
                            Mobileproxy.newStreamDialerFromConfig(key)
                    )
            proxyAddress = proxy?.address()
            result.success("""{"success": true, "localPort": $port, "address": "$proxyAddress"}""")
        } catch (e: Exception) {
            result.success("""{"success": false, "error": "${e.message}"}""")
        }
    }

    private fun stopLocalProxy(result: MethodChannel.Result) {
        try {
            proxy?.stop(0)
            proxy = null
            proxyAddress = null
            result.success(true)
        } catch (e: Exception) {
            Log.e("MainActivity", "stopLocalProxy", e)
            result.error("PROXY_ERROR", "Failed: ${e.message}", null)
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == REQUEST_VPN_PERMISSION) {
            val ok = (resultCode == RESULT_OK)
            vpnPermissionResult?.success(ok)
            vpnPermissionResult = null
        }
    }

    override fun onDestroy() {
        proxy?.stop(0)
        proxy = null
        super.onDestroy()
    }
}

// ---------------- VpnService (cùng file) ----------------
class MyVpnService : VpnService() {
    private var tunPfd: ParcelFileDescriptor? = null
    private var socksUpstream: String? = null
    private var perAppOnly: Boolean = true
    private var tun2socksStarted = false

    override fun onCreate() {
        super.onCreate()
        startAsForeground()
        Log.d("MyVpnService", "onCreate")
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.d("MyVpnService", "onStartCommand flags=$flags startId=$startId")

        socksUpstream = intent?.getStringExtra("socks_upstream")
        perAppOnly = intent?.getBooleanExtra("per_app", true) ?: true

        if (socksUpstream.isNullOrBlank()) {
            Log.e("MyVpnService", "❌ Missing socks_upstream. Stop.")
            stopSelf()
            return START_NOT_STICKY
        }

        try {
            // 1) Build VPN
            val b =
                    Builder()
                            .setSession("vpncn2")
                            .setMtu(1280)
                            .addAddress("10.0.0.2", 32)
                            .addDnsServer("1.1.1.1")
                            .addDnsServer("8.8.8.8")
                            .addRoute("0.0.0.0", 0)

            if (perAppOnly) {
                try {
                    b.addAllowedApplication(packageName)
                } catch (e: Exception) {
                    Log.w("MyVpnService", "addAllowedApplication failed: ${e.message}", e)
                }
            }
            // nếu muốn chặn 1 số app, dùng addDisallowedApplication()

            tunPfd?.close()
            tunPfd = b.establish()
            if (tunPfd == null) {
                Log.e("MyVpnService", "❌ establish() failed")
                return START_NOT_STICKY
            }
            Log.d("MyVpnService", "✅ TUN established fd=${tunPfd!!.fd}")

            // 2) Start tun2socks
            val ok = startTun2Socks(tunPfd!!, socksUpstream!!)
            tun2socksStarted = ok
            if (!ok) {
                Log.e(
                        "MyVpnService",
                        "❌ tun2socks start failed (missing AAR / wrong method). Stop."
                )
                stopSelf()
                return START_NOT_STICKY
            }
        } catch (e: Exception) {
            Log.e("MyVpnService", "❌ Error: ${e.message}", e)
            stopSelf()
            return START_NOT_STICKY
        }

        return START_STICKY
    }

    override fun onDestroy() {
        Log.d("MyVpnService", "onDestroy")
        stopTun2Socks()
        try {
            tunPfd?.close()
        } catch (_: Exception) {}
        tunPfd = null
        super.onDestroy()
    }

    // ---- Foreground ----
    private fun startAsForeground() {
        val channelId = "vpncn2_channel"
        val nm = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val ch = NotificationChannel(channelId, "VPNcn2", NotificationManager.IMPORTANCE_LOW)
            nm.createNotificationChannel(ch)
        }
        val pi =
                PendingIntent.getActivity(
                        this,
                        0,
                        Intent(this, MainActivity::class.java),
                        PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
                )
        val notif =
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    Notification.Builder(this, channelId)
                            .setContentTitle("VPN đang chạy")
                            .setContentText("vpncn2 hoạt động qua tun2socks")
                            .setSmallIcon(android.R.drawable.ic_secure)
                            .setContentIntent(pi)
                            .build()
                } else {
                    @Suppress("DEPRECATION")
                    Notification.Builder(this)
                            .setContentTitle("VPN đang chạy")
                            .setContentText("vpncn2 hoạt động qua tun2socks")
                            .setSmallIcon(android.R.drawable.ic_secure)
                            .setContentIntent(pi)
                            .build()
                }
        startForeground(1, notif)
    }

    // ---- tun2socks integration ----

    /**
     * Cố gắng gọi nhiều chữ ký khác nhau:
     * - start(int, String, int, Protect)
     * - start(ParcelFileDescriptor, String, int, Protect)
     * - start(int, String, int)
     * - stop()/shutdown()/close()
     *
     * Tên class mặc định dùng ví dụ: "com.example.tun2socks.Tun2Socks" => THAY bằng FQCN thật của
     * AAR tun2socks của bạn (hoặc thêm vào danh sách).
     */
    private fun startTun2Socks(tun: ParcelFileDescriptor, socks: String): Boolean {
        val (host, port) = socks.split(":").let { it[0] to it[1].toInt() }

        val classCandidates =
                arrayOf(
                        // THAY 1 dòng dưới bằng FQCN thật từ AAR của bạn:
                        "com.example.tun2socks.Tun2Socks",
                        // optional fallback tên khác:
                        "com.example.tun2socks.TunBridge",
                        "org.outline.tun2socks.Tun2Socks",
                        "tun2socks.Tun2Socks"
                )

        for (cn in classCandidates) {
            try {
                val cls = Class.forName(cn)

                // (int, String, int, <ProtectInterface>)
                cls.methods
                        .firstOrNull { m ->
                            m.name.equals("start", true) &&
                                    m.parameterTypes.size == 4 &&
                                    (m.parameterTypes[0] == Int::class.javaPrimitiveType) &&
                                    m.parameterTypes[1] == String::class.java &&
                                    (m.parameterTypes[2] == Int::class.java ||
                                            m.parameterTypes[2] == Integer.TYPE)
                        }
                        ?.let { m ->
                            val protectIface = m.parameterTypes[3]
                            val proxy =
                                    makeProtectProxy(protectIface) { fd ->
                                        try {
                                            protect(fd)
                                        } catch (_: Throwable) {
                                            false
                                        }
                                    }
                                            ?: return@let
                            Log.d("MyVpnService", "🚀 $cn.start(fd, host, port, protect)")
                            m.invoke(null, tun.fd, host, port, proxy)
                            return true
                        }

                // (ParcelFileDescriptor, String, int, <ProtectInterface>)
                cls.methods
                        .firstOrNull { m ->
                            m.name.equals("start", true) &&
                                    m.parameterTypes.size == 4 &&
                                    ParcelFileDescriptor::class.java.isAssignableFrom(
                                            m.parameterTypes[0]
                                    ) &&
                                    m.parameterTypes[1] == String::class.java &&
                                    (m.parameterTypes[2] == Int::class.java ||
                                            m.parameterTypes[2] == Integer.TYPE)
                        }
                        ?.let { m ->
                            val protectIface = m.parameterTypes[3]
                            val proxy =
                                    makeProtectProxy(protectIface) { fd ->
                                        try {
                                            protect(fd)
                                        } catch (_: Throwable) {
                                            false
                                        }
                                    }
                                            ?: return@let
                            Log.d("MyVpnService", "🚀 $cn.start(pfd, host, port, protect)")
                            m.invoke(null, tun, host, port, proxy)
                            return true
                        }

                // (int, String, int) — không có protect (ít lib; dễ loop nếu lib không tự protect
                // nội bộ)
                cls.methods
                        .firstOrNull { m ->
                            m.name.equals("start", true) &&
                                    m.parameterTypes.size == 3 &&
                                    m.parameterTypes[0] == Int::class.javaPrimitiveType &&
                                    m.parameterTypes[1] == String::class.java &&
                                    (m.parameterTypes[2] == Int::class.java ||
                                            m.parameterTypes[2] == Integer.TYPE)
                        }
                        ?.let { m ->
                            Log.w(
                                    "MyVpnService",
                                    "⚠️ $cn.start(fd,host,port) (không protect) — lib phải tự protect nội bộ"
                            )
                            m.invoke(null, tun.fd, host, port)
                            return true
                        }
            } catch (t: Throwable) {
                Log.d("MyVpnService", "Class $cn not usable: ${t.message}")
            }
        }
        return false
    }

    private fun stopTun2Socks() {
        val classCandidates =
                arrayOf(
                        "com.example.tun2socks.Tun2Socks",
                        "com.example.tun2socks.TunBridge",
                        "org.outline.tun2socks.Tun2Socks",
                        "tun2socks.Tun2Socks"
                )
        for (cn in classCandidates) {
            try {
                val cls = Class.forName(cn)
                // try stop()
                cls.methods
                        .firstOrNull { it.name.equals("stop", true) && it.parameterTypes.isEmpty() }
                        ?.let {
                            Log.d("MyVpnService", "🛑 $cn.stop()")
                            it.invoke(null)
                            return
                        }
                // try shutdown()
                cls.methods
                        .firstOrNull {
                            it.name.equals("shutdown", true) && it.parameterTypes.isEmpty()
                        }
                        ?.let {
                            Log.d("MyVpnService", "🛑 $cn.shutdown()")
                            it.invoke(null)
                            return
                        }
                // try close()
                cls.methods
                        .firstOrNull {
                            it.name.equals("close", true) && it.parameterTypes.isEmpty()
                        }
                        ?.let {
                            Log.d("MyVpnService", "🛑 $cn.close()")
                            it.invoke(null)
                            return
                        }
            } catch (_: Throwable) {
                /* ignore */
            }
        }
    }

    /** Tạo dynamic proxy cho interface Protect có method boolean protect(int fd). */
    private fun makeProtectProxy(iface: Class<*>?, impl: (Int) -> Boolean): Any? {
        if (iface == null || !iface.isInterface) return null
        val m =
                iface.methods.firstOrNull {
                    it.name.equals("protect", true) &&
                            it.parameterTypes.size == 1 &&
                            it.parameterTypes[0] == Int::class.javaPrimitiveType
                }
                        ?: return null

        return java.lang.reflect.Proxy.newProxyInstance(iface.classLoader, arrayOf(iface)) {
                _,
                method,
                args ->
            if (method.name.equals("protect", true) && args?.size == 1) {
                return@newProxyInstance impl(args[0] as Int)
            }
            return@newProxyInstance false
        }
    }
}

// ---------------- VPN Status Event Channel ----------------
class VpnStatusStreamHandler : EventChannel.StreamHandler {
    private var eventSink: EventChannel.EventSink? = null
    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
        Log.d("VpnStatusStreamHandler", "📡 listener connected")
        events?.success("disconnected")
    }
    override fun onCancel(arguments: Any?) {
        eventSink = null
    }
    fun sendStatus(status: String) {
        eventSink?.success(status)
    }
}
