package com.example.vpncn2_app

import androidx.annotation.NonNull
import android.content.Intent
import android.net.VpnService
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.os.Build
import android.os.ParcelFileDescriptor
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.EventChannel
import mobileproxy.Mobileproxy
import mobileproxy.Proxy

class MainActivity : FlutterActivity() {
    // Channels
    private val OUTLINE_BRIDGE_CHANNEL = "com/example/vpncn2_app"
    private val VPN_SERVICE_CHANNEL    = "vpncn2/vpn_service"
    private val VPN_STATUS_CHANNEL     = "vpncn2/vpn_status"

    // Proxy
    private var proxy: Proxy? = null

    // VPN permission result (for startActivityForResult)
    private var vpnPermissionResult: MethodChannel.Result? = null
    private val REQUEST_VPN_PERMISSION = 1001

    // (optional) status events
    private lateinit var vpnStatusEventChannel: EventChannel

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Proxy channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, OUTLINE_BRIDGE_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "startOutlineProxy" -> startOutlineProxy(call, result)
                    "stopOutlineProxy", "stopOutline" -> stopOutlineProxy(result)
                    "getStatus" -> getStatus(result)
                    else -> result.notImplemented()
                }
            }

        // VPN control channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, VPN_SERVICE_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "requestPermission" -> requestVpnPermission(result)
                    "startVpn"          -> startVpn(result)
                    "stopVpn"           -> stopVpn(result)
                    else -> result.notImplemented()
                }
            }

        // (optional) VPN status event channel
        vpnStatusEventChannel = EventChannel(flutterEngine.dartExecutor.binaryMessenger, VPN_STATUS_CHANNEL)
        vpnStatusEventChannel.setStreamHandler(VpnStatusStreamHandler())
    }

    // ---------------- Proxy (local) ----------------
    private fun startOutlineProxy(call: MethodCall, result: MethodChannel.Result) {
        try {
            val key  = call.argument<String>("key") ?: throw IllegalArgumentException("Missing key")
            val portArg = call.argument<String>("port") ?: "1080"
            var port = portArg.toIntOrNull() ?: 1080
             if (port < 1024) port = 1080 // tránh cổng đặc quyền

            // KHÔNG dùng 443; dùng 127.0.0.1 thay vì localhost cho rõ ràng

            proxy = Mobileproxy.runProxy(
                "127.0.0.1:$port",
                Mobileproxy.newStreamDialerFromConfig(key)
            )
            result.success("${proxy?.address()}") // ví dụ: 127.0.0.1:1080
        } catch (e: Exception) {
            result.error("PROXY_ERROR", "Failed to start proxy: ${e.message}", null)
        }
    }

    private fun stopOutlineProxy(result: MethodChannel.Result) {
        try {
            proxy?.stop(0)
            proxy = null
            result.success("Proxy stopped")
        } catch (e: Exception) {
            result.error("PROXY_ERROR", "Failed to stop proxy: ${e.message}", null)
        }
    }

    private fun getStatus(result: MethodChannel.Result) {
        result.success(if (proxy != null) "running" else "stopped")
    }

    // ---------------- VPN (VpnService) ----------------
    private fun requestVpnPermission(result: MethodChannel.Result) {
        try {
            val intent = VpnService.prepare(this)
            if (intent == null) {
                // Quyền đã được cấp trước đó
                result.success(true)
            } else {
                vpnPermissionResult = result
                startActivityForResult(intent, REQUEST_VPN_PERMISSION)
            }
        } catch (e: Exception) {
            result.error("VPN_ERROR", "Failed to request VPN permission: ${e.message}", null)
        }
    }

    private fun startVpn(result: MethodChannel.Result) {
        try {
            // Gọi requestVpnPermission trước, nếu user từ chối thì start sẽ không có hiệu lực
            val svc = Intent(this, MyVpnService::class.java)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                startForegroundService(svc)
            } else {
                startService(svc)
            }
            result.success(true)
        } catch (e: Exception) {
            result.error("VPN_ERROR", "Failed to start VPN: ${e.message}", null)
        }
    }

    private fun stopVpn(result: MethodChannel.Result) {
        try {
            stopService(Intent(this, MyVpnService::class.java))
            result.success(true)
        } catch (e: Exception) {
            result.error("VPN_ERROR", "Failed to stop VPN: ${e.message}", null)
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
    private var tun: ParcelFileDescriptor? = null

    override fun onCreate() {
        super.onCreate()
        startAsForeground()
    }

     override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
         // Tối thiểu: thiết lập TUN + DNS; route tuỳ nhu cầu
        val builder = Builder()
            .setSession("vpncn2")
            .addAddress("10.0.0.2", 32)
            .addDnsServer("1.1.1.1")
            .addRoute("0.0.0.0", 0) // Mở route toàn bộ nếu muốn VPN full-tunnel

        tun = builder.establish()

        // TODO: triển khai luồng đọc/ghi giữa tun?.fileDescriptor và đường hầm Shadowsocks/Outline của bạn
        return START_STICKY
    }

    override fun onDestroy() {
        tun?.close()
        tun = null
        super.onDestroy()
    }

    private fun startAsForeground() {
        val channelId = "vpncn2_channel"
        val nm = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val ch = NotificationChannel(channelId, "VPNcn2", NotificationManager.IMPORTANCE_LOW)
            nm.createNotificationChannel(ch)
        }
        val pi = PendingIntent.getActivity(
            this, 0,
            Intent(this, MainActivity::class.java),
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )
    
        val notif: Notification = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Notification.Builder(this, channelId)
                .setContentTitle("VPN đang chạy")
                .setContentText("vpncn2 đang hoạt động")
                .setSmallIcon(R.mipmap.ic_launcher) // 👈 icon hợp lệ
                .setContentIntent(pi)
                .build()
        } else {
            @Suppress("DEPRECATION")
            Notification.Builder(this)
                .setContentTitle("VPN đang chạy")
                .setContentText("vpncn2 đang hoạt động")
                .setSmallIcon(R.mipmap.ic_launcher) // 👈 icon hợp lệ
                .setContentIntent(pi)
                .build()
        }
    
        startForeground(1, notif)
    }
    
}

// ---------------- (tuỳ chọn) kênh event status (cùng file) ----------------
class VpnStatusStreamHandler : EventChannel.StreamHandler {
    private var eventSink: EventChannel.EventSink? = null
    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
        events?.success("disconnected")
    }
    override fun onCancel(arguments: Any?) { eventSink = null }
    fun sendStatus(status: String) { eventSink?.success(status) }
}
