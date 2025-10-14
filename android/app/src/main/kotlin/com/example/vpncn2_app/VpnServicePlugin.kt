package com.example.vpncn2_app

import android.app.Activity
import android.content.Intent
import android.net.VpnService
import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class VpnServicePlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var channel: MethodChannel
    private var activity: Activity? = null
    private var pendingResult: Result? = null
    private val REQUEST_VPN_PERMISSION = 1001

    companion object {
        private const val CHANNEL = "vpncn2/vpn_service"
        private const val TAG = "VpnServicePlugin"
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        Log.d(TAG, "Method called: ${call.method}")
        
        when (call.method) {
            "initialize" -> {
                // Initialize the plugin
                result.success(true)
            }
            "requestPermission" -> {
                Log.d(TAG, "Requesting VPN permission...")
                activity?.let { act ->
                    val intent = VpnService.prepare(act)
                    if (intent != null) {
                        Log.d(TAG, "VPN permission not granted, showing dialog...")
                        pendingResult = result
                        act.startActivityForResult(intent, REQUEST_VPN_PERMISSION)
                    } else {
                        Log.d(TAG, "VPN permission already granted")
                        result.success(true)
                    }
                } ?: run {
                    Log.e(TAG, "Activity not available")
                    result.error("NO_ACTIVITY", "Activity not available", null)
                }
            }
            "startVpn" -> {
                Log.d(TAG, "Starting VPN service...")
                val config = call.argument<String>("config") ?: ""
                val port = call.argument<String>("port") ?: "1080"
                val socksUpstream = call.argument<String>("socks_upstream") ?: ""
                val perApp = call.argument<Boolean>("per_app") ?: true
                
                Log.d(TAG, "Config: $config")
                Log.d(TAG, "Port: $port")
                Log.d(TAG, "SocksUpstream: $socksUpstream")
                Log.d(TAG, "PerApp: $perApp")
                
                activity?.let { act ->
                    val intent = Intent(act, MyVpnService::class.java).apply {
                        action = MyVpnService.ACTION_CONNECT
                        putExtra("CONFIG", config)
                        putExtra("PORT", port)
                        putExtra("PROXY_ADDRESS", socksUpstream)
                        putExtra("socks_upstream", socksUpstream)
                        putExtra("per_app", perApp)
                    }
                    Log.d(TAG, "Starting MyVpnService...")
                    act.startForegroundService(intent)
                    Log.d(TAG, "MyVpnService started successfully")
                    result.success(true)
                } ?: run {
                    Log.e(TAG, "Activity not available")
                    result.error("NO_ACTIVITY", "Activity not available", null)
                }
            }
            "stopVpn" -> {
                Log.d(TAG, "Stopping VPN service...")
                activity?.let { act ->
                    val intent = Intent(act, MyVpnService::class.java).apply {
                        action = MyVpnService.ACTION_DISCONNECT
                    }
                    Log.d(TAG, "Stopping MyVpnService...")
                    act.startService(intent)
                    Log.d(TAG, "MyVpnService stop command sent")
                    result.success(true)
                } ?: run {
                    Log.e(TAG, "Activity not available")
                    result.error("NO_ACTIVITY", "Activity not available", null)
                }
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode == REQUEST_VPN_PERMISSION) {
            val result = pendingResult
            pendingResult = null
            
            if (resultCode == Activity.RESULT_OK) {
                result?.success(true)
            } else {
                result?.success(false)
            }
            return true
        }
        return false
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }
}
