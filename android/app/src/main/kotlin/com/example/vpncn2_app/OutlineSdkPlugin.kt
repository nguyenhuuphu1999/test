package com.example.vpncn2_app

import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.ServiceConnection
import android.net.VpnService
import android.os.IBinder
import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.json.JSONArray
import org.json.JSONObject
import tun2socks.Tun2socks
import tun2socks.ConnectRemoteDeviceResult
import tun2socks.RemoteDevice
import outline.ClientConfig as OutlineClientConfig
import outline.NewClientResult as OutlineNewClientResult
import outline.Client as OutlineClient

class OutlineSdkPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    
    // VpnTunnelService connection
    private var vpnTunnelService: VpnTunnelService? = null
    private var isVpnServiceBound = false
    
    // Go method constants (copied from official Outline app)
    companion object {
        const val MethodCloseVPN = "CloseVPN"
        const val MethodEraseServiceStorage = "EraseServiceStorage"
        const val MethodEstablishVPN = "EstablishVPN"
        const val MethodFetchResource = "FetchResource"
        const val MethodParseTunnelConfig = "ParseTunnelConfig"
        const val MethodSetVPNStateChangeListener = "SetVPNStateChangeListener"
    }
    private lateinit var channel: MethodChannel
    private var context: Context? = null
    private var activity: android.app.Activity? = null
    
    // InvokeMethod wrapper (copied from official Outline app)
    private fun invokeMethod(method: String, input: String): InvokeMethodResult {
        Log.d("OutlineSdkPlugin", "=== invokeMethod START ===")
        Log.d("OutlineSdkPlugin", "Method: $method")
        Log.d("OutlineSdkPlugin", "Input: $input")
        
        return try {
            val result = when (method) {
                MethodCloseVPN -> {
                    Log.d("OutlineSdkPlugin", "Handling MethodCloseVPN")
                    // TODO: Implement CloseVPN
                    InvokeMethodResult(null, null)
                }
                MethodEraseServiceStorage -> {
                    Log.d("OutlineSdkPlugin", "Handling MethodEraseServiceStorage")
                    // TODO: Implement EraseServiceStorage
                    InvokeMethodResult(null, null)
                }
                MethodEstablishVPN -> {
                    Log.d("OutlineSdkPlugin", "Handling MethodEstablishVPN")
                    // TODO: Implement EstablishVPN
                    InvokeMethodResult(null, null)
                }
                MethodFetchResource -> {
                    Log.d("OutlineSdkPlugin", "Handling MethodFetchResource")
                    Log.d("OutlineSdkPlugin", "Input URL: $input")
                    
                    // This is what we need for outlineFetch
                    // Run HTTP request in background thread
                    try {
                        Log.d("OutlineSdkPlugin", "Calling fetchResourceAsync...")
                        val content = fetchResourceAsync(input)
                        Log.d("OutlineSdkPlugin", "fetchResourceAsync returned: $content")
                        Log.d("OutlineSdkPlugin", "Content length: ${content?.length}")
                        InvokeMethodResult(content, null)
                    } catch (e: Exception) {
                        Log.e("OutlineSdkPlugin", "fetchResource failed", e)
                        Log.e("OutlineSdkPlugin", "Exception type: ${e.javaClass.simpleName}")
                        Log.e("OutlineSdkPlugin", "Exception message: ${e.message}")
                        InvokeMethodResult(null, PlatformError("FetchError", e.message ?: "Unknown fetch error"))
                    }
                }
                MethodParseTunnelConfig -> {
                    Log.d("OutlineSdkPlugin", "Handling MethodParseTunnelConfig")
                    // TODO: Implement ParseTunnelConfig
                    InvokeMethodResult(null, null)
                }
                MethodSetVPNStateChangeListener -> {
                    Log.d("OutlineSdkPlugin", "Handling MethodSetVPNStateChangeListener")
                    // TODO: Implement SetVPNStateChangeListener
                    InvokeMethodResult(null, null)
                }
                else -> {
                    Log.w("OutlineSdkPlugin", "Unsupported method: $method")
                    InvokeMethodResult(null, PlatformError("InternalError", "unsupported Go method: $method"))
                }
            }
            Log.d("OutlineSdkPlugin", "invokeMethod result: $result")
            result
        } catch (e: Exception) {
            Log.e("OutlineSdkPlugin", "invokeMethod exception", e)
            InvokeMethodResult(null, PlatformError("InternalError", e.message ?: "Unknown error"))
        }
    }
    
    // REAL fetchResource implementation - actual HTTP fetch in background thread
    private fun fetchResourceAsync(url: String): String? {
        Log.d("OutlineSdkPlugin", "=== fetchResourceAsync START ===")
        Log.d("OutlineSdkPlugin", "URL: $url")
        
        return try {
            Log.d("OutlineSdkPlugin", "Making REAL HTTP request in background thread...")
            
            // Use CountDownLatch to wait for async result
            val latch = java.util.concurrent.CountDownLatch(1)
            var result: String? = null
            var exception: Exception? = null
            
            // Run HTTP request in background thread
            Thread {
                try {
                    Log.d("OutlineSdkPlugin", "Background thread: Starting HTTP request...")
                    
                    // Use OkHttp for actual HTTP fetch
                    val client = okhttp3.OkHttpClient.Builder()
                        .connectTimeout(30, java.util.concurrent.TimeUnit.SECONDS)
                        .readTimeout(30, java.util.concurrent.TimeUnit.SECONDS)
                        .build()
                    
                    val request = okhttp3.Request.Builder()
                        .url(url)
                        .addHeader("User-Agent", "Outline-Android/1.0")
                        .build()
                    
                    Log.d("OutlineSdkPlugin", "Background thread: Executing HTTP request...")
                    val response = client.newCall(request).execute()
                    
                    if (response.isSuccessful) {
                        val responseBody = response.body?.string()
                        Log.d("OutlineSdkPlugin", "Background thread: HTTP response received: ${responseBody?.length} characters")
                        Log.d("OutlineSdkPlugin", "Background thread: Response body: $responseBody")
                        
                        // Wrap response in expected format for Flutter
                        val wrappedResponse = """
                        {
                            "success": true,
                            "body": ${responseBody}
                        }
                        """.trimIndent()
                        
                        Log.d("OutlineSdkPlugin", "Background thread: Wrapped response: $wrappedResponse")
                        result = wrappedResponse
                    } else {
                        Log.e("OutlineSdkPlugin", "Background thread: HTTP request failed: ${response.code} ${response.message}")
                        exception = Exception("HTTP ${response.code}: ${response.message}")
                    }
                } catch (e: Exception) {
                    Log.e("OutlineSdkPlugin", "Background thread: HTTP request exception", e)
                    exception = e
                } finally {
                    latch.countDown()
                }
            }.start()
            
            // Wait for background thread to complete (max 35 seconds)
            val completed = latch.await(35, java.util.concurrent.TimeUnit.SECONDS)
            
            if (!completed) {
                Log.e("OutlineSdkPlugin", "HTTP request timeout")
                throw Exception("HTTP request timeout")
            }
            
            if (exception != null) {
                Log.e("OutlineSdkPlugin", "HTTP request failed with exception", exception)
                throw exception!!
            }
            
            Log.d("OutlineSdkPlugin", "=== fetchResourceAsync END (SUCCESS) ===")
            result
        } catch (e: Exception) {
            Log.e("OutlineSdkPlugin", "fetchResourceAsync exception", e)
            Log.e("OutlineSdkPlugin", "Exception type: ${e.javaClass.simpleName}")
            Log.e("OutlineSdkPlugin", "Exception message: ${e.message}")
            Log.e("OutlineSdkPlugin", "=== fetchResourceAsync END (ERROR) ===")
            throw e
        }
    }
    
    // Data classes for InvokeMethod result (copied from official Outline app)
    data class InvokeMethodResult(
        val value: String?,
        val error: PlatformError?
    )
    
    data class PlatformError(
        val code: String,
        val message: String
    )

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "outline_sdk")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        // Initialize Outline services
        Log.d("OutlineSdkPlugin", "OutlineSdkPlugin attached to activity")
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        // Cleanup if needed
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        // Reinitialize if needed
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        // Cleanup if needed
        activity = null
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        Log.d("OutlineSdkPlugin", "=== onMethodCall START ===")
        Log.d("OutlineSdkPlugin", "Method: ${call.method}")
        Log.d("OutlineSdkPlugin", "Arguments: ${call.arguments}")
        Log.d("OutlineSdkPlugin", "Arguments type: ${call.arguments?.javaClass?.simpleName}")
        
        try {
        when (call.method) {
            "ping" -> {
                Log.d("OutlineSdkPlugin", "Method: ping")
                result.success("pong")
            }
            "outlineInit" -> {
                Log.d("OutlineSdkPlugin", "Method: outlineInit")
                try {
                    Log.d("OutlineSdkPlugin", "Initializing Outline SDK...")
                    // For now, return success - we'll implement proper initialization later
                    val response = """{"success":true}"""
                    Log.d("OutlineSdkPlugin", "Outline init successful")
                    result.success(response)
                } catch (e: Exception) {
                    Log.e("OutlineSdkPlugin", "Outline init failed", e)
                    val errorMessage = e.message ?: "Unknown initialization error"
                    result.error("INIT_ERROR", errorMessage, null)
                }
            }
            "outlineFetch" -> {
                Log.d("OutlineSdkPlugin", "=== outlineFetch START ===")
                Log.d("OutlineSdkPlugin", "Step 1: Method call received")
                
                try {
                    Log.d("OutlineSdkPlugin", "Step 2: Getting arguments...")
                    val url = call.argument<String>("url") ?: ""
                    val config = call.argument<String>("config") ?: "{}"
                    
                    Log.d("OutlineSdkPlugin", "Step 3: Arguments extracted")
                    Log.d("OutlineSdkPlugin", "URL extracted: '$url'")
                    Log.d("OutlineSdkPlugin", "Config extracted: '$config'")
                    Log.d("OutlineSdkPlugin", "URL length: ${url.length}")
                    Log.d("OutlineSdkPlugin", "Config length: ${config.length}")
                    
                    if (url.isEmpty()) {
                        Log.e("OutlineSdkPlugin", "Step 4: URL is empty - returning error")
                        result.error("FETCH_ERROR", "URL is empty", null)
                        return
                    }

                    Log.d("OutlineSdkPlugin", "Step 5: URL validation passed")
                    Log.d("OutlineSdkPlugin", "Step 6: Calling invokeMethod...")
                    Log.d("OutlineSdkPlugin", "MethodFetchResource constant: $MethodFetchResource")
                    Log.d("OutlineSdkPlugin", "URL to fetch: $url")
                    
                    // Use official Outline app's InvokeMethod approach
                    val invokeResult = invokeMethod(MethodFetchResource, url)
                    
                    Log.d("OutlineSdkPlugin", "Step 7: invokeMethod completed")
                    Log.d("OutlineSdkPlugin", "invokeResult: $invokeResult")
                    Log.d("OutlineSdkPlugin", "invokeResult.error: ${invokeResult.error}")
                    Log.d("OutlineSdkPlugin", "invokeResult.value: ${invokeResult.value}")
                    Log.d("OutlineSdkPlugin", "invokeResult.value type: ${invokeResult.value?.javaClass?.simpleName}")
                    
                    if (invokeResult.error != null) {
                        Log.e("OutlineSdkPlugin", "Step 8: InvokeMethod failed: ${invokeResult.error}")
                        Log.e("OutlineSdkPlugin", "Error message: ${invokeResult.error!!.message}")
                        result.error("FETCH_ERROR", invokeResult.error!!.message, null)
                        Log.d("OutlineSdkPlugin", "Step 8: Error returned")
                    } else {
                        Log.d("OutlineSdkPlugin", "Step 8: InvokeMethod success: ${invokeResult.value}")
                        if (invokeResult.value != null) {
                            Log.d("OutlineSdkPlugin", "Step 9: Returning success")
                            result.success(invokeResult.value)
                            Log.d("OutlineSdkPlugin", "Step 9: Success returned")
                        } else {
                            Log.e("OutlineSdkPlugin", "Step 9: invokeResult.value is null")
                            result.error("FETCH_ERROR", "Result value is null", null)
                            Log.d("OutlineSdkPlugin", "Step 9: Null error returned")
                        }
                    }
                } catch (e: Exception) {
                    Log.e("OutlineSdkPlugin", "=== outlineFetch EXCEPTION ===")
                    Log.e("OutlineSdkPlugin", "Exception type: ${e.javaClass.simpleName}")
                    Log.e("OutlineSdkPlugin", "Exception message: ${e.message}")
                    Log.e("OutlineSdkPlugin", "Exception stack trace:", e)
                    val errorMessage = e.message ?: "Unknown fetch error"
                    Log.e("OutlineSdkPlugin", "Final error message: $errorMessage")
                    Log.e("OutlineSdkPlugin", "About to return exception error")
                    result.error("FETCH_ERROR", errorMessage, null)
                    Log.e("OutlineSdkPlugin", "Exception error returned")
                }
                Log.d("OutlineSdkPlugin", "=== outlineFetch END ===")
            }
            "outlineStart" -> {
                Log.d("OutlineSdkPlugin", "Method: outlineStart")
                try {
                    val config = call.argument<String>("config") ?: "{}"
                    val tunnelId = "tunnel_${System.currentTimeMillis()}"
                    
                    Log.d("OutlineSdkPlugin", "🚀 Starting REAL VPN tunnel for $tunnelId")
                    Log.d("OutlineSdkPlugin", "📋 Config: $config")
                    
                    // Parse config to get server details
                    val configJson = JSONObject(config)
                    val server = configJson.optString("server", "")
                    val serverPort = configJson.optInt("server_port", 443)
                    val method = configJson.optString("method", "")
                    val password = configJson.optString("password", "")
                    
                    Log.d("OutlineSdkPlugin", "🎯 VPN Server: $server:$serverPort")
                    Log.d("OutlineSdkPlugin", "🔐 Method: $method")
                    Log.d("OutlineSdkPlugin", "🔑 Password: ${password.take(3)}***")
                    
                    // Try to establish real VPN tunnel using VpnTunnelService
                    val vpnEstablished = establishVpnTunnelViaService(server, serverPort, method, password, tunnelId)
                    
                    if (vpnEstablished) {
                        Log.d("OutlineSdkPlugin", "✅ REAL VPN tunnel established successfully!")
                        val response = JSONObject().apply {
                            put("success", true)
                            put("tunnel_id", tunnelId)
                            put("server_name", server)
                            put("real_vpn", true)
                        }
                        result.success(response.toString())
                    } else {
                        Log.e("OutlineSdkPlugin", "❌ Failed to establish real VPN tunnel")
                        Log.e("OutlineSdkPlugin", "❌ NO MOCK FALLBACK - Real VPN tunnel establishment failed!")
                        
                        result.error("TUNNEL_ESTABLISHMENT_FAILED", "Failed to establish real VPN tunnel", null)
                    }
                } catch (e: Exception) {
                    Log.e("OutlineSdkPlugin", "❌ Outline start failed", e)
                    result.error("START_ERROR", e.message, null)
                }
            }
            "outlineStop" -> {
                Log.d("OutlineSdkPlugin", "Method: outlineStop")
                try {
                    val tunnelId = call.argument<String>("tunnel_id") ?: "tunnel_${System.currentTimeMillis()}"
                    
                    // For now, return success - we'll implement proper VPN stop later
                        result.success("""{"success":true}""")
                } catch (e: Exception) {
                    Log.e("OutlineSdkPlugin", "Outline stop failed", e)
                    result.error("STOP_ERROR", e.message, null)
                }
            }
            "outlineTestReachability" -> {
                Log.d("OutlineSdkPlugin", "Method: outlineTestReachability")
                try {
                    val config = call.argument<String>("config") ?: "{}"
                    Log.d("OutlineSdkPlugin", "Testing reachability with config: $config")
                    
                    // For now, return success - we'll implement proper reachability testing later
                    val response = JSONObject().apply {
                        put("success", true)
                    put("tcp_result", JSONObject().apply {
                            put("success", true)
                            put("duration_ms", 100)
                    })
                    put("udp_result", JSONObject().apply {
                            put("success", true)
                            put("duration_ms", 100)
                        })
                    }
                    Log.d("OutlineSdkPlugin", "Reachability test result: ${response.toString()}")
                    result.success(response.toString())
                } catch (e: Exception) {
                    Log.e("OutlineSdkPlugin", "Outline test reachability failed", e)
                    val errorMessage = e.message ?: "Unknown reachability test error"
                    result.error("TEST_ERROR", errorMessage, null)
                }
            }
            "outlineSpeedTest" -> {
                Log.d("OutlineSdkPlugin", "Method: outlineSpeedTest")
                try {
                    val url = call.argument<String>("url") ?: ""
                    val tunnelId = call.argument<String>("tunnel_id") ?: "tunnel_${System.currentTimeMillis()}"
                    
                    Log.d("OutlineSdkPlugin", "Speed test for: $url")
                    
                    // For now, return mock speed test result
                    val response = JSONObject().apply {
                                put("success", true)
                        put("download_speed_mbps", 50.5)
                        put("upload_speed_mbps", 25.3)
                        put("latency_ms", 45)
                    }
                    result.success(response.toString())
                } catch (e: Exception) {
                    Log.e("OutlineSdkPlugin", "Outline speed test failed", e)
                    result.error("SPEED_TEST_ERROR", e.message, null)
                }
            }
            "FetchResource" -> {
                Log.d("OutlineSdkPlugin", "Method: FetchResource (Official Outline method)")
                try {
                    val url = call.arguments as? String ?: ""
                    Log.d("OutlineSdkPlugin", "FetchResource called with URL: $url")
                    
                    // Use official Outline app's InvokeMethod approach
                    val invokeResult = invokeMethod(MethodFetchResource, url)
                    
                    if (invokeResult.error != null) {
                        Log.e("OutlineSdkPlugin", "FetchResource InvokeMethod failed: ${invokeResult.error}")
                        result.error("FETCH_ERROR", invokeResult.error!!.message, null)
                    } else {
                        Log.d("OutlineSdkPlugin", "FetchResource InvokeMethod success: ${invokeResult.value}")
                        result.success(invokeResult.value)
                    }
                    } catch (e: Exception) {
                    Log.e("OutlineSdkPlugin", "FetchResource failed", e)
                    val errorMessage = e.message ?: "Unknown fetch error"
                    result.error("FETCH_ERROR", errorMessage, null)
                }
            }
            "ParseTunnelConfig" -> {
                Log.d("OutlineSdkPlugin", "Method: ParseTunnelConfig (Official Outline method)")
                try {
                    val configText = call.arguments as? String ?: ""
                    Log.d("OutlineSdkPlugin", "ParseTunnelConfig called with: $configText")
                    
                    // Use official Outline app's InvokeMethod approach
                    val invokeResult = invokeMethod(MethodParseTunnelConfig, configText)
                    
                    if (invokeResult.error != null) {
                        Log.e("OutlineSdkPlugin", "ParseTunnelConfig InvokeMethod failed: ${invokeResult.error}")
                        result.error("PARSE_ERROR", invokeResult.error!!.message, null)
                    } else {
                        Log.d("OutlineSdkPlugin", "ParseTunnelConfig InvokeMethod success: ${invokeResult.value}")
                        result.success(invokeResult.value)
                    }
        } catch (e: Exception) {
                    Log.e("OutlineSdkPlugin", "ParseTunnelConfig failed", e)
                    val errorMessage = e.message ?: "Unknown parse error"
                    result.error("PARSE_ERROR", errorMessage, null)
                }
            }
            "EstablishVPN" -> {
                Log.d("OutlineSdkPlugin", "Method: EstablishVPN (Official Outline method)")
                try {
                    val configJson = call.arguments as? String ?: "{}"
                    Log.d("OutlineSdkPlugin", "EstablishVPN called with config: $configJson")
                    
                    // Use official Outline app's InvokeMethod approach
                    val invokeResult = invokeMethod(MethodEstablishVPN, configJson)
                    
                    if (invokeResult.error != null) {
                        Log.e("OutlineSdkPlugin", "EstablishVPN InvokeMethod failed: ${invokeResult.error}")
                        result.error("CONNECTION_ERROR", invokeResult.error!!.message, null)
                    } else {
                        Log.d("OutlineSdkPlugin", "EstablishVPN InvokeMethod success: ${invokeResult.value}")
                        result.success(invokeResult.value)
                    }
        } catch (e: Exception) {
                    Log.e("OutlineSdkPlugin", "EstablishVPN failed", e)
                    val errorMessage = e.message ?: "Unknown connection error"
                    result.error("CONNECTION_ERROR", errorMessage, null)
                }
            }
            "requestVpnPermission" -> {
                Log.d("OutlineSdkPlugin", "Method: requestVpnPermission")
                try {
                    Log.d("OutlineSdkPlugin", "Checking VPN permission...")
                    
                    val context = this.context ?: throw Exception("Context is null")
                    
                    // Check if VPN permission is already granted
                    val prepareIntent = android.net.VpnService.prepare(context)
            if (prepareIntent == null) {
                Log.d("OutlineSdkPlugin", "VPN permission already granted")
                        result.success("""{"granted":true}""")
                    } else {
                        Log.d("OutlineSdkPlugin", "VPN permission needed - opening system dialog")
                        
                        // Start VPN permission activity
                        if (activity != null) {
                            activity!!.startActivityForResult(prepareIntent, 1001)
                            Log.d("OutlineSdkPlugin", "VPN permission dialog opened")
                            result.success("""{"granted":false,"intent":"VPN_PERMISSION_STARTED"}""")
                        } else {
                            Log.e("OutlineSdkPlugin", "Activity is null - cannot request VPN permission")
                            result.error("PERMISSION_ERROR", "Activity is null", null)
                        }
                    }
                } catch (e: Exception) {
                    Log.e("OutlineSdkPlugin", "VPN permission request failed", e)
                    result.error("PERMISSION_ERROR", e.message, null)
                }
            }
            else -> {
                Log.w("OutlineSdkPlugin", "Method not implemented: ${call.method}")
                result.notImplemented()
            }
        }
            } catch (e: Exception) {
            Log.e("OutlineSdkPlugin", "CRITICAL ERROR in onMethodCall", e)
            Log.e("OutlineSdkPlugin", "Exception type: ${e.javaClass.simpleName}")
            Log.e("OutlineSdkPlugin", "Exception message: ${e.message}")
            Log.e("OutlineSdkPlugin", "Exception stack trace:", e)
            val errorMessage = e.message ?: "Critical error in onMethodCall"
            Log.e("OutlineSdkPlugin", "About to return CRITICAL_ERROR: $errorMessage")
            result.error("CRITICAL_ERROR", errorMessage, null)
            Log.e("OutlineSdkPlugin", "CRITICAL_ERROR returned successfully")
        }
        
        Log.d("OutlineSdkPlugin", "=== onMethodCall END ===")
    }

    /**
     * Establish real VPN tunnel using VpnTunnelService
     */
    private fun establishVpnTunnelViaService(
        server: String,
        serverPort: Int,
        method: String,
        password: String,
        tunnelId: String
    ): Boolean {
        return try {
            Log.d("OutlineSdkPlugin", "🔧 Establishing VPN tunnel via VpnTunnelService...")
            Log.d("OutlineSdkPlugin", "🔧 Parameters: server=$server, port=$serverPort, method=$method, tunnelId=$tunnelId")
            
            // Bind to VpnTunnelService
            Log.d("OutlineSdkPlugin", "🔧 Step 1: Binding to VpnTunnelService...")
            if (!bindVpnTunnelService()) {
                Log.e("OutlineSdkPlugin", "❌ Failed to bind VpnTunnelService")
                return false
            }
            Log.d("OutlineSdkPlugin", "✅ VpnTunnelService bound successfully")
            
            // Check if service is available
            if (vpnTunnelService == null) {
                Log.e("OutlineSdkPlugin", "❌ VpnTunnelService is null after binding")
                return false
            }
            Log.d("OutlineSdkPlugin", "✅ VpnTunnelService instance available: $vpnTunnelService")
            
            // Create tunnel config
            Log.d("OutlineSdkPlugin", "🔧 Step 2: Creating tunnel config...")
            val tunnelConfig = VpnTunnelService.TunnelConfig(
                id = tunnelId,
                server = server,
                port = serverPort,
                method = method,
                password = password,
                name = server
            )
            
            Log.d("OutlineSdkPlugin", "tunnelConfig: $tunnelConfig")
            
            // Start VPN tunnel
            Log.d("OutlineSdkPlugin", "🔧 Step 3: Starting VPN tunnel...")
            val success = vpnTunnelService?.startVpnTunnel(tunnelConfig) ?: false
            
            if (success) {
                Log.d("OutlineSdkPlugin", "✅ VPN tunnel started via VpnTunnelService")
            } else {
                Log.e("OutlineSdkPlugin", "❌ Failed to start VPN tunnel via VpnTunnelService")
            }
            
            success
        } catch (e: Exception) {
            Log.e("OutlineSdkPlugin", "❌ Failed to establish VPN tunnel via service", e)
            Log.e("OutlineSdkPlugin", "❌ Exception details: ${e.message}")
            e.printStackTrace()
            false
        }
    }

    /**
     * Bind to VpnTunnelService
     */
    private fun bindVpnTunnelService(): Boolean {
        return try {
            if (isVpnServiceBound && vpnTunnelService != null) {
                Log.d("OutlineSdkPlugin", "VpnTunnelService already bound")
                return true
            }
            
            Log.d("OutlineSdkPlugin", "🔧 Starting VpnTunnelService binding...")
            val intent = Intent(activity, VpnTunnelService::class.java)
            val bound = activity?.bindService(intent, vpnServiceConnection, Context.BIND_AUTO_CREATE) ?: false
            
            if (!bound) {
                Log.e("OutlineSdkPlugin", "❌ Failed to initiate VpnTunnelService binding")
                return false
            }
            
            Log.d("OutlineSdkPlugin", "✅ VpnTunnelService binding initiated")
            Log.d("OutlineSdkPlugin", "⏳ Waiting for service connection...")
            
            // Wait for service connection (max 5 seconds)
            var attempts = 0
            val maxAttempts = 50 // 5 seconds with 100ms intervals
            while (!isVpnServiceBound && attempts < maxAttempts) {
                Thread.sleep(100)
                attempts++
            }
            
            if (isVpnServiceBound && vpnTunnelService != null) {
                Log.d("OutlineSdkPlugin", "✅ VpnTunnelService connected successfully")
                true
            } else {
                Log.e("OutlineSdkPlugin", "❌ VpnTunnelService connection timeout after ${attempts * 100}ms")
                false
            }
        } catch (e: Exception) {
            Log.e("OutlineSdkPlugin", "❌ Failed to bind VpnTunnelService", e)
            false
        }
    }

    /**
     * Service connection for VpnTunnelService
     */
    private val vpnServiceConnection = object : ServiceConnection {
        override fun onServiceConnected(name: ComponentName?, service: IBinder?) {
            Log.d("OutlineSdkPlugin", "🔧 VpnTunnelService onServiceConnected called")
            Log.d("OutlineSdkPlugin", "🔧 ComponentName: $name")
            Log.d("OutlineSdkPlugin", "🔧 Service IBinder: $service")
            
            try {
                val binder = service as VpnTunnelService.VpnTunnelBinder
                Log.d("OutlineSdkPlugin", "🔧 Casting to VpnTunnelBinder successful")
                
                vpnTunnelService = binder.getService()
                isVpnServiceBound = true
                
                Log.d("OutlineSdkPlugin", "✅ VpnTunnelService connected successfully")
                Log.d("OutlineSdkPlugin", "✅ Service instance: $vpnTunnelService")
            } catch (e: Exception) {
                Log.e("OutlineSdkPlugin", "❌ Failed to get VpnTunnelService from binder", e)
                Log.e("OutlineSdkPlugin", "❌ Service class: ${service?.javaClass}")
            }
        }

        override fun onServiceDisconnected(name: ComponentName?) {
            Log.d("OutlineSdkPlugin", "🔧 VpnTunnelService onServiceDisconnected called")
            vpnTunnelService = null
            isVpnServiceBound = false
        }
    }

    /**
     * Establish real VPN tunnel using Outline SDK (based on official Outline client)
     * @deprecated Use establishVpnTunnelViaService instead
     */
    @Deprecated("Use establishVpnTunnelViaService instead")
    private fun establishVpnTunnel(
        server: String,
        serverPort: Int,
        method: String,
        password: String,
        tunnelId: String
    ): Boolean {
        return try {
            Log.d("OutlineSdkPlugin", "🔧 Establishing REAL VPN tunnel to $server:$serverPort")
            
            // Step 1: Create Shadowsocks transport config
            val transportConfig = createShadowsocksConfig(server, serverPort, method, password)
            if (transportConfig == null) {
                Log.e("OutlineSdkPlugin", "❌ Failed to create Shadowsocks config")
                return false
            }
            
            // Step 2: Create Outline client
            val client = createOutlineClient(tunnelId, transportConfig)
            if (client == null) {
                Log.e("OutlineSdkPlugin", "❌ Failed to create Outline client")
                return false
            }
            
            // Step 3: Establish VPN TUN interface
            val tunFd = establishVpnTunInterface()
            if (tunFd == null) {
                Log.e("OutlineSdkPlugin", "❌ Failed to establish VPN TUN interface")
                return false
            }
            
            // Step 4: Connect to remote device
            val remoteDevice = connectRemoteDevice(client)
            if (remoteDevice == null) {
                Log.e("OutlineSdkPlugin", "❌ Failed to connect to remote device")
                return false
            }
            
            // Step 5: Start traffic relay between TUN and remote device
            val relaySuccess = startTrafficRelay(tunFd, remoteDevice)
            if (!relaySuccess) {
                Log.e("OutlineSdkPlugin", "❌ Failed to start traffic relay")
                return false
            }
            
            Log.d("OutlineSdkPlugin", "✅ REAL VPN tunnel established successfully!")
            Log.d("OutlineSdkPlugin", "🎯 Traffic will now route through VPN server: $server")
            return true
            
        } catch (e: Exception) {
            Log.e("OutlineSdkPlugin", "❌ Failed to establish VPN tunnel", e)
            false
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
            Log.d("OutlineSdkPlugin", "🔧 Creating Shadowsocks config...")
            
            // Create Shadowsocks transport config similar to official Outline client
            val config = JSONObject().apply {
                put("host", server)
                put("port", serverPort)
                put("password", password)
                put("method", method)
                put("prefix", "")
            }
            
            val configString = config.toString()
            Log.d("OutlineSdkPlugin", "✅ Shadowsocks config created: ${configString.take(50)}...")
            configString
        } catch (e: Exception) {
            Log.e("OutlineSdkPlugin", "❌ Failed to create Shadowsocks config", e)
            null
        }
    }

    /**
     * Create Outline client (placeholder - requires actual Outline SDK integration)
     */
    private fun createOutlineClient(tunnelId: String, transportConfig: String): Any? {
        return try {
            Log.d("OutlineSdkPlugin", "🔧 Creating Outline client for tunnel: $tunnelId")
            
            // Based on official Outline client implementation:
            // final ClientConfig clientConfig = new ClientConfig();
            // clientConfig.setDataDir(this.getFilesDir().getAbsolutePath());
            // final NewClientResult clientResult = clientConfig.new_(config.id, config.transportConfig);
            
            // Create client config similar to official Outline client
            val clientConfig = createClientConfig()
            if (clientConfig == null) {
                Log.e("OutlineSdkPlugin", "❌ Failed to create client config")
                return null
            }
            
            // Create new client result similar to official Outline client
            val clientResult = createNewClientResult(tunnelId, transportConfig, clientConfig)
            if (clientResult == null) {
                Log.e("OutlineSdkPlugin", "❌ Failed to create client result")
                return null
            }
            
            // Check for errors (similar to official Outline client)
            if (clientResult.error != null) {
                Log.e("OutlineSdkPlugin", "❌ Client creation error: ${clientResult.error}")
                return null
            }
            
            Log.d("OutlineSdkPlugin", "✅ Outline client created successfully")
            clientResult.client
        } catch (e: Exception) {
            Log.e("OutlineSdkPlugin", "❌ Failed to create Outline client", e)
            null
        }
    }

    /**
     * Create client config (based on official Outline client)
     */
    private fun createClientConfig(): ClientConfig? {
        return try {
            Log.d("OutlineSdkPlugin", "🔧 Creating client config...")
            
            // Similar to official Outline client:
            // final ClientConfig clientConfig = new ClientConfig();
            // clientConfig.setDataDir(this.getFilesDir().getAbsolutePath());
            
            val clientConfig = ClientConfig()
            val dataDir = activity?.filesDir?.absolutePath
            if (dataDir != null) {
                clientConfig.dataDir = dataDir
                Log.d("OutlineSdkPlugin", "✅ Client config created with dataDir: $dataDir")
            } else {
                Log.w("OutlineSdkPlugin", "⚠️ Could not get files directory, using default")
            }
            
            clientConfig
        } catch (e: Exception) {
            Log.e("OutlineSdkPlugin", "❌ Failed to create client config", e)
            null
        }
    }

    /**
     * Create new client result (based on official Outline client)
     */
    private fun createNewClientResult(
        tunnelId: String, 
        transportConfig: String, 
        clientConfig: ClientConfig
    ): NewClientResult? {
        return try {
            Log.d("OutlineSdkPlugin", "🔧 Creating new client result...")
            
            // Similar to official Outline client:
            // final NewClientResult clientResult = clientConfig.new_(config.id, config.transportConfig);
            
            val clientResult = clientConfig.newClient(tunnelId, transportConfig)
            
            if (clientResult.error != null) {
                Log.e("OutlineSdkPlugin", "❌ Client creation failed: ${clientResult.error}")
            } else {
                Log.d("OutlineSdkPlugin", "✅ Client result created successfully")
            }
            
            clientResult
        } catch (e: Exception) {
            Log.e("OutlineSdkPlugin", "❌ Failed to create client result", e)
            null
        }
    }

    /**
     * Establish VPN TUN interface (based on official Outline client)
     */
    private fun establishVpnTunInterface(): android.os.ParcelFileDescriptor? {
        return try {
            Log.d("OutlineSdkPlugin", "🔧 Establishing VPN TUN interface...")
            
            // Check VPN permission first
            val vpnService = VpnService.prepare(activity)
            if (vpnService != null) {
                Log.e("OutlineSdkPlugin", "❌ VPN permission not granted")
                return null
            }
            
            // Create VPN TUN interface similar to official Outline client
            // Note: VpnService.Builder() requires a VpnService instance
            // For now, we'll return null as this requires proper VpnService implementation
            Log.w("OutlineSdkPlugin", "⚠️ VPN TUN interface creation requires proper VpnService implementation")
            Log.w("OutlineSdkPlugin", "⚠️ This requires extending VpnService class")
            
            // Placeholder - return null for now
            val tunFd: android.os.ParcelFileDescriptor? = null
            if (tunFd != null) {
                Log.d("OutlineSdkPlugin", "✅ VPN TUN interface established successfully")
            } else {
                Log.e("OutlineSdkPlugin", "❌ Failed to establish VPN TUN interface")
            }
            
            tunFd
        } catch (e: Exception) {
            Log.e("OutlineSdkPlugin", "❌ Failed to establish VPN TUN interface", e)
            null
        }
    }

    /**
     * Connect to remote device (placeholder)
     */
    private fun connectRemoteDevice(client: Any): Any? {
        return try {
            Log.d("OutlineSdkPlugin", "🔧 Connecting to remote device...")
            
            // Use actual tun2socks library from tun2socks-0.0.1.aar
            val result = Tun2socks.connectRemoteDevice(client as OutlineClient)
            if (result.error != null) {
                Log.e("OutlineSdkPlugin", "❌ Remote device connection failed: ${result.error}")
                return null
            }
            
            val remoteDevice = result.device
            Log.d("OutlineSdkPlugin", "✅ Remote device connected successfully")
            remoteDevice
        } catch (e: Exception) {
            Log.e("OutlineSdkPlugin", "❌ Failed to connect to remote device", e)
            null
        }
    }

    /**
     * Start traffic relay between TUN and remote device (placeholder)
     */
    private fun startTrafficRelay(tunFd: android.os.ParcelFileDescriptor, remoteDevice: Any): Boolean {
        return try {
            Log.d("OutlineSdkPlugin", "🔧 Starting traffic relay...")
            
            // Use actual tun2socks library from tun2socks-0.0.1.aar
            val err = Tun2socks.goRelayTraffic(tunFd.fd.toLong(), remoteDevice as RemoteDevice)
            if (err != null) {
                Log.e("OutlineSdkPlugin", "❌ Failed to relay traffic between TUN and remote devices: $err")
                return false
            }
            
            Log.d("OutlineSdkPlugin", "✅ Traffic relay started successfully")
            true
            } catch (e: Exception) {
            Log.e("OutlineSdkPlugin", "❌ Failed to start traffic relay", e)
            false
        }
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
                Log.d("OutlineSdkPlugin", "🔧 Creating new client with tunnelId: $tunnelId")
                Log.d("OutlineSdkPlugin", "🔧 Transport config: ${transportConfig.take(100)}...")
                
                // Use actual outline library from mobileproxy.aar
                // Based on official Outline client: clientConfig.new_(tunnelId, transportConfig)
                val clientConfig = OutlineClientConfig()
                clientConfig.setDataDir(dataDir)
                
                val result = clientConfig.new_(tunnelId, transportConfig)
                if (result.error != null) {
                    Log.e("OutlineSdkPlugin", "❌ Client creation failed: ${result.error}")
                    return NewClientResult(client = null, error = result.error.toString())
                }
                
                val actualClient = result.client
                val wrapperClient = OutlineClientWrapper(tunnelId, transportConfig, actualClient)
                Log.d("OutlineSdkPlugin", "✅ Client created successfully using outline library")
                NewClientResult(client = wrapperClient, error = null)
            } catch (e: Exception) {
                Log.e("OutlineSdkPlugin", "❌ Failed to create new client", e)
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
                Log.d("OutlineSdkPlugin", "🔧 Dialing stream to: $address")
                
                // Use actual client from outline library
                // Based on official Outline client: client.DialStream(context, address)
                // Note: We'll implement this when we have proper context handling
                Log.d("OutlineSdkPlugin", "✅ Stream dialing method called (actual implementation pending)")
                true
            } catch (e: Exception) {
                Log.e("OutlineSdkPlugin", "❌ Failed to dial stream to: $address", e)
                false
            }
        }
        
        fun newSession(): Boolean {
            return try {
                Log.d("OutlineSdkPlugin", "🔧 Creating new session")
                
                // Use actual client from outline library
                // Based on official Outline client: client.NewSession(resp)
                Log.d("OutlineSdkPlugin", "✅ New session method called (actual implementation pending)")
                true
            } catch (e: Exception) {
                Log.e("OutlineSdkPlugin", "❌ Failed to create new session", e)
                false
            }
        }
    }
}