
// package com.example.vpncn2_app

// import android.app.ActivityManager
// import android.content.Context
// import android.content.Intent
// import android.net.VpnService
// import android.os.Build
// import android.util.Log
// import androidx.annotation.NonNull
// import androidx.webkit.ProxyConfig
// import androidx.webkit.ProxyController
// import io.flutter.embedding.android.FlutterActivity
// import io.flutter.embedding.engine.FlutterEngine
// import io.flutter.plugin.common.MethodCall
// import io.flutter.plugin.common.MethodChannel
// import mobileproxy.Mobileproxy
// import mobileproxy.Proxy

// class MainActivity : FlutterActivity() {

//     private val TAG = "MainActivityVPN"
//     private val OUTLINE_SDK_CHANNEL = "outline_sdk" // start/stop proxy
//     private val WEBVIEW_PROXY_CHANNEL = "webview_proxy" // set/clear WebView proxy
//     private val VPN_SERVICE_CHANNEL = "vpncn2/vpn_service" // xin quyền + start VPN

//     private var proxy: Proxy? = null
//     private var vpnPermissionResult: MethodChannel.Result? = null
//     private val REQUEST_VPN_PERMISSION = 1001

//     // --- Hardcode SS config từ bạn (SIP008-like) ---
//     // ssconf://oss.vpncn2.net/vpncn2key/20251012-m150-manhnguyen-yjdu.json#m150-Ramzi-251012-2
//     // Nội dung JSON:
//     // {"server":"150.136.131.140","server_port":443,"password":"OXCaAErI4aLdoKa0BdgIDN","method":"chacha20-ietf-poly1305","prefix":"\u0016\u0003\u0001\u0000¨\u0001\u0001"}
//     private val SS_SERVER = "150.136.131.140"
//     private val SS_PORT = 443
//     private val SS_PASSWORD = "OXCaAErI4aLdoKa0BdgIDN"
//     private val SS_METHOD = "chacha20-ietf-poly1305"
//     // prefix là binary ClientHello TLS (được encode trong JSON). Để đơn giản, mình giữ nguyên dạng raw string.
//     private val SS_PREFIX = "\u0016\u0003\u0001\u0000¨\u0001\u0001"

//     override fun configureFlutterEngine(@NonNull engine: FlutterEngine) {
//         super.configureFlutterEngine(engine)

//         // ---- 1) Local proxy (MobileProxy) ----
//         MethodChannel(engine.dartExecutor.binaryMessenger, OUTLINE_SDK_CHANNEL)
//             .setMethodCallHandler { call, result ->
//                 when (call.method) {
//                     "startLocalProxy" -> startLocalProxy(call, result)
//                     "stopLocalProxy" -> stopLocalProxy(result)
//                     "ping" -> result.success("pong")
//                     else -> result.notImplemented()
//                 }
//             }

//         // ---- 2) WebView proxy override ----
//         MethodChannel(engine.dartExecutor.binaryMessenger, WEBVIEW_PROXY_CHANNEL)
//             .setMethodCallHandler { call, result ->
//                 when (call.method) {
//                     "setWebViewProxy" -> {
//                         val address = call.argument<String>("address")
//                             ?: return@setMethodCallHandler result.error("ARG", "address required", null)
//                         setWebViewProxy(address, onApplied = {
//                             Log.d(TAG, "WebView proxy applied to $address")
//                             result.success(true)
//                         })
//                     }
//                     "clearWebViewProxy" -> {
//                         clearWebViewProxy {
//                             Log.d(TAG, "WebView proxy cleared")
//                             result.success(true)
//                         }
//                     }
//                     else -> result.notImplemented()
//                 }
//             }

//         // ---- 3) VPN permission + start VPN ----
//         MethodChannel(engine.dartExecutor.binaryMessenger, VPN_SERVICE_CHANNEL)
//             .setMethodCallHandler { call, result ->
//                 when (call.method) {
//                     "requestPermission" -> requestVpnPermission(result)

//                     // Giữ method cũ để tương thích nếu bạn muốn truyền tham số từ Dart
//                     "startVpn" -> {
//                         Log.d(TAG, "startVpn (dynamic) invoked")
//                         startVpnDynamic(call, result)
//                     }

//                     // Method mới: hard-code cấu hình SS của bạn để test ngay
//                     "startVpnHardcoded" -> {
//                         Log.d(TAG, "startVpnHardcoded invoked")
//                         startVpnHardcoded(result)
//                     }

//                     else -> result.notImplemented()
//                 }
//             }
//     }

//     // ================= VPN permission =================
//     private fun requestVpnPermission(result: MethodChannel.Result) {
//         try {
//             val intent = VpnService.prepare(this)
//             if (intent == null) {
//                 Log.d(TAG, "VPN permission already granted")
//                 result.success(true)
//             } else {
//                 Log.d(TAG, "Requesting VPN permission...")
//                 vpnPermissionResult = result
//                 @Suppress("DEPRECATION")
//                 startActivityForResult(intent, REQUEST_VPN_PERMISSION)
//             }
//         } catch (e: Exception) {
//             Log.e(TAG, "requestVpnPermission error", e)
//             result.error("VPN_ERROR", "Failed to request VPN permission: ${e.message}", null)
//         }
//     }

//     @Deprecated("Deprecated in Java")
//     override fun onActivityResult(requestCode: Int, resultCode: Int, data: android.content.Intent?) {
//         super.onActivityResult(requestCode, resultCode, data)
//         if (requestCode == REQUEST_VPN_PERMISSION) {
//             val ok = (resultCode == RESULT_OK)
//             Log.d(TAG, "onActivityResult: VPN permission = $ok")
//             vpnPermissionResult?.success(ok)
//             vpnPermissionResult = null
//         }
//     }

//     // ================== START VPN (dynamic - giữ lại) ==================
//     private fun startVpnDynamic(call: MethodCall, result: MethodChannel.Result) {
//         // Nếu bạn vẫn muốn truyền tham số từ Dart, dùng method này.
//         // Nhưng với Shadowsocks, khuyến nghị truyền đúng SS extras như startVpnHardcoded bên dưới.
//         try {
//             if (!isVpnPermissionGranted()) {
//                 Log.w(TAG, "startVpnDynamic: VPN permission not granted")
//                 return result.error("VPN_PERM", "VPN permission not granted. Call requestPermission first.", null)
//             }
//             if (isServiceRunning(MyVpnService::class.java)) {
//                 Log.d(TAG, "startVpnDynamic: service already running, ignore")
//                 return result.success(true)
//             }

//             val socks = call.argument<String>("socks_upstream")
//             val perApp = call.argument<Boolean>("per_app") ?: false

//             val svc = Intent(this, MyVpnService::class.java).apply {
//                 putExtra("per_app", perApp)
//                 // Giữ nguyên để tương thích nếu service của bạn vẫn đọc SOCKS:
//                 if (!socks.isNullOrBlank()) {
//                     putExtra("socks_upstream", socks)
//                 }
//                 // Khuyến nghị: thêm keys SS (nếu service đã hỗ trợ)
//                 call.argument<String>("ss_server")?.let { putExtra("ss_server", it) }
//                 call.argument<Int>("ss_port")?.let { putExtra("ss_port", it) }
//                 call.argument<String>("ss_password")?.let { putExtra("ss_password", it) }
//                 call.argument<String>("ss_method")?.let { putExtra("ss_method", it) }
//                 call.argument<String>("ss_prefix")?.let { putExtra("ss_prefix", it) }
//                 putExtra("mode", if (call.hasArgument("ss_server")) "shadowsocks" else "socks")
//                 action = "ACTION_START_VPN"
//             }

//             Log.i(TAG, "startVpnDynamic -> start service | per_app=$perApp, socks=$socks")
//             if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
//                 startForegroundService(svc) else startService(svc)

//             result.success(true)
//         } catch (e: Exception) {
//             Log.e(TAG, "startVpnDynamic error", e)
//             result.error("VPN_ERROR", "Failed to start VPN: ${e.message}", null)
//         }
//     }

//     // ================== START VPN (HARDCODED - test ngay) ==================
//     private fun startVpnHardcoded(result: MethodChannel.Result) {
//         try {
//             if (!isVpnPermissionGranted()) {
//                 Log.w(TAG, "startVpnHardcoded: VPN permission not granted")
//                 return result.error("VPN_PERM", "VPN permission not granted. Call requestPermission first.", null)
//             }
//             if (isServiceRunning(MyVpnService::class.java)) {
//                 Log.d(TAG, "startVpnHardcoded: service already running, ignore")
//                 return result.success(true)
//             }

//             // Nếu service của bạn vẫn yêu cầu "socks_upstream", có thể đặt placeholder (không dùng):
//             val placeholderSocks = "socks5://127.0.0.1:1080"

//             val svc = Intent(this, MyVpnService::class.java).apply {
//                 action = "ACTION_START_VPN"
//                 putExtra("per_app", false)
//                 // giữ để tương thích (nếu Service đang đọc khoá này)
//                 putExtra("socks_upstream", placeholderSocks)

//                 // Shadowsocks (SIP008-ish)
//                 putExtra("mode", "shadowsocks")
//                 putExtra("ss_server", SS_SERVER)
//                 putExtra("ss_port", SS_PORT)
//                 putExtra("ss_password", SS_PASSWORD)
//                 putExtra("ss_method", SS_METHOD)
//                 putExtra("ss_prefix", SS_PREFIX)
//             }

//             Log.i(TAG, "startVpnHardcoded -> start service with SS: $SS_SERVER:$SS_PORT, method=$SS_METHOD")
//             if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
//                 startForegroundService(svc) else startService(svc)

//             result.success(true)
//         } catch (e: Exception) {
//             Log.e(TAG, "startVpnHardcoded error", e)
//             result.error("VPN_ERROR", "Failed to start VPN: ${e.message}", null)
//         }
//     }

//     private fun isVpnPermissionGranted(): Boolean {
//         // Nếu chưa từng request hoặc user từ chối -> VpnService.prepare != null
//         return VpnService.prepare(this) == null
//     }

//     private fun isServiceRunning(serviceClass: Class<*>): Boolean {
//         val am = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
//         @Suppress("DEPRECATION")
//         val list = am.getRunningServices(Int.MAX_VALUE)
//         for (info in list) {
//             if (serviceClass.name == info.service.className) {
//                 return true
//             }
//         }
//         return false
//     }

//     // ================= Local proxy (MobileProxy) giữ nguyên như bạn =================
//     // ... (không thay đổi các hàm startLocalProxy/stopLocalProxy và webview helpers)
//      // ================= Local proxy (MobileProxy) =================
//      private fun startLocalProxy(call: MethodCall, result: MethodChannel.Result) {
//         try {
//             val preferSmart = call.argument<Boolean>("preferSmart") ?: false
//             val bindHost = call.argument<String>("bindHost") ?: "127.0.0.1"
//             val portArg = call.argument<Int>("port") ?: 0
//             val port = if (portArg < 0) 0 else portArg

//             val dialer =
//                     if (preferSmart) {
//                         val yaml =
//                                 call.argument<String>("strategiesYaml")
//                                         ?: error("strategiesYaml is required when preferSmart=true")
//                         val tests =
//                                 Mobileproxy.newListFromLines(
//                                         call.argument<String>("testDomains")
//                                                 ?: "www.youtube.com\ni.ytimg.com"
//                                 )
//                         Mobileproxy.newSmartStreamDialer(
//                                 tests,
//                                 yaml,
//                                 Mobileproxy.newStderrLogWriter()
//                         )
//                     } else {
//                         val config = call.argument<String>("config") ?: "split:3"
//                         Mobileproxy.newStreamDialerFromConfig(config)
//                     }

//             if (proxy == null) {
//                 val bind = if (port == 0) "$bindHost:0" else "$bindHost:$port"
//                 proxy = Mobileproxy.runProxy(bind, dialer)
//             }

//             val addr = proxy!!.address() // ví dụ 127.0.0.1:54321
//             result.success(
//                     mapOf(
//                             "success" to true,
//                             "address" to addr,
//                             "host" to proxy!!.host(),
//                             "port" to proxy!!.port()
//                     )
//             )
//         } catch (e: Exception) {
//             Log.e("MainActivity", "startLocalProxy error", e)
//             result.success(mapOf("success" to false, "error" to (e.message ?: "unknown")))
//         }
//     }

//     private fun stopLocalProxy(result: MethodChannel.Result) {
//         try {
//             proxy?.stop(1)
//             proxy = null
//             result.success(true)
//         } catch (e: Exception) {
//             Log.e("MainActivity", "stopLocalProxy error", e)
//             result.error("PROXY_ERROR", "Failed: ${e.message}", null)
//         }
//     }

//         // ================= WebView proxy helpers =================
//     private fun setWebViewProxy(address: String, onApplied: () -> Unit) {
//         // address dạng "host:port"
//         val cfg = ProxyConfig.Builder().addProxyRule(address).build()

//         // Không block UI: cung cấp callback khi áp dụng xong
//         ProxyController.getInstance()
//                 .setProxyOverride(
//                         cfg,
//                         { runOnUiThread { /* executor context */} },
//                         {
//                             runOnUiThread {
//                                 // bắt buộc: WebView nên khởi tạo/refresh SAU khi proxy áp dụng
//                                 onApplied()
//                             }
//                         }
//                 )
//     }
    
//     private fun clearWebViewProxy(onCleared: () -> Unit) {
//         ProxyController.getInstance()
//                 .clearProxyOverride(
//                         { runOnUiThread { /* executor */} },
//                         { runOnUiThread { onCleared() } }
//                 )
//     }
    
//     override fun onDestroy() {
//         try {
//             proxy?.stop(1)
//         } catch (_: Exception) {}
//         proxy = null
//         super.onDestroy()
//     }
// }


// android/app/src/main/kotlin/your/package/MainActivity.kt
package com.example.vpncn2_app

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.net.VpnService

class MainActivity : FlutterActivity() {
    private val CHANNEL = "vpn_channel"
    private val REQ_VPN = 1001
    private var vpnServicePlugin: VpnServicePlugin? = null
    private var outlineSdkPlugin: OutlineSdkPlugin? = null
    private var webViewProxyPlugin: WebViewProxyPlugin? = null

    private var pendingHost: String? = null
    private var pendingPort: Int? = null
    private var pendingUdp: Boolean = true
    private var pendingStart = false
    private var methodResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Register VpnServicePlugin for vpncn2/vpn_service channel
        vpnServicePlugin = VpnServicePlugin()
        flutterEngine.plugins.add(vpnServicePlugin!!)
        
                // Register OutlineSdkPlugin for outline_sdk channel
                outlineSdkPlugin = OutlineSdkPlugin()
                flutterEngine.plugins.add(outlineSdkPlugin!!)

                // Register WebViewProxyPlugin for webview_proxy channel
                webViewProxyPlugin = WebViewProxyPlugin()
                flutterEngine.plugins.add(webViewProxyPlugin!!)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "start" -> {
                    val host = call.argument<String>("host")
                    val port = call.argument<Int>("port")
                    val udp = call.argument<Boolean>("udp") ?: true
                    if (host.isNullOrBlank() || port == null) {
                        result.success(false)
                        return@setMethodCallHandler
                    }
                    methodResult = result
                    pendingHost = host
                    pendingPort = port
                    pendingUdp = udp
                    pendingStart = true

                    val intent = VpnService.prepare(this)
                    if (intent != null) {
                        // Hiện consent dialog
                        startActivityForResult(intent, REQ_VPN)
                    } else {
                        // Đã có quyền, xử lý ngay
                        onActivityResult(REQ_VPN, Activity.RESULT_OK, null)
                    }
                }

                "stop" -> {
                    val i = Intent(this, MyVpnService::class.java).apply {
                        action = MyVpnService.ACTION_DISCONNECT
                    }
                    startService(i)
                    result.success(null)
                }

                "isConnected" -> {
                    result.success(MyVpnService.isConnected)
                }

                else -> result.notImplemented()
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        
        // Handle VPN permission result from VpnServicePlugin
        if (vpnServicePlugin?.onActivityResult(requestCode, resultCode, data) == true) {
            return
        }
        
        if (requestCode == REQ_VPN) {
            val r = methodResult
            methodResult = null

            if (resultCode == Activity.RESULT_OK && pendingStart) {
                val host = pendingHost ?: return
                val port = pendingPort ?: return
                val udp = pendingUdp

                // Bắt đầu VPN service
                startForegroundService(Intent(this, MyVpnService::class.java).apply {
                    action = MyVpnService.ACTION_CONNECT
                    putExtra("SOCKS_HOST", host)
                    putExtra("SOCKS_PORT", port)
                    putExtra("ENABLE_UDP", udp)
                })
                pendingStart = false
                r?.success(true)
            } else {
                pendingStart = false
                r?.success(false)
            }
        }
    }
}
