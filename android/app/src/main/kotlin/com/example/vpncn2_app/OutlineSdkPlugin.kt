package com.example.vpncn2_app

import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import mobileproxy.Mobileproxy
import mobileproxy.Proxy
import mobileproxy.StreamDialer

class OutlineSdkPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private var proxy: Proxy? = null

    companion object {
        private const val CHANNEL = "outline_sdk"
        private const val TAG = "OutlineSdkPlugin"
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler(this)
        Log.d(TAG, "OutlineSdkPlugin attached to engine")
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        Log.d(TAG, "Method called: ${call.method}")
        
        when (call.method) {
            "startLocalProxy" -> startLocalProxy(call, result)
            "stopLocalProxy" -> stopLocalProxy(result)
            "isProxyRunning" -> {
                val isRunning = proxy != null
                Log.d(TAG, "isProxyRunning: $isRunning")
                result.success(isRunning)
            }
            "getProxyAddress" -> {
                val address = proxy?.address()
                Log.d(TAG, "getProxyAddress: $address")
                result.success(address)
            }
            else -> {
                Log.w(TAG, "Unknown method: ${call.method}")
                result.notImplemented()
            }
        }
    }

    private fun startLocalProxy(call: MethodCall, result: Result) {
        try {
            Log.d(TAG, "Starting local proxy...")
            
            // Get parameters from Flutter
            Log.d(TAG, "All arguments: ${call.arguments}")
            
            val config = call.argument<String>("config") ?: ""
            val port = call.argument<Int>("port")?.toString() ?: "1080"
            val bindHost = call.argument<String>("bindHost") ?: "127.0.0.1"
            val preferSmart = call.argument<Boolean>("preferSmart") ?: false
            
            Log.d(TAG, "Config: '$config'")
            Log.d(TAG, "Port: '$port'")
            Log.d(TAG, "BindHost: '$bindHost'")
            Log.d(TAG, "PreferSmart: '$preferSmart'")
            
            if (config.isEmpty()) {
                Log.e(TAG, "Config is empty")
                result.error("INVALID_CONFIG", "Config cannot be empty", null)
                return
            }
            
            // Stop existing proxy if running
            if (proxy != null) {
                Log.d(TAG, "Stopping existing proxy...")
                proxy?.stop(0)
                proxy = null
            }
            
            // Create stream dialer from config
            Log.d(TAG, "Creating stream dialer from config...")
            val streamDialer: StreamDialer = Mobileproxy.newStreamDialerFromConfig(config)
            Log.d(TAG, "Stream dialer created successfully")
            
            // Start proxy
            Log.d(TAG, "Starting proxy on $bindHost:$port...")
            proxy = Mobileproxy.runProxy("$bindHost:$port", streamDialer)
            Log.d(TAG, "Proxy started successfully")
            
            val proxyAddress = proxy?.address()
            Log.d(TAG, "Proxy address: $proxyAddress")
            
            // Return success response
            val response = mapOf(
                "success" to true,
                "ok" to true,
                "address" to proxyAddress,
                "host" to proxy?.host(),
                "port" to proxy?.port(),
                "error" to null
            )
            
            Log.d(TAG, "Proxy started successfully: $response")
            result.success(response)
            
        } catch (e: Exception) {
            Log.e(TAG, "Error starting local proxy", e)
            val errorResponse = mapOf(
                "success" to false,
                "ok" to false,
                "address" to null,
                "host" to null,
                "port" to null,
                "error" to e.message
            )
            result.success(errorResponse)
        }
    }

    private fun stopLocalProxy(result: Result) {
        try {
            Log.d(TAG, "Stopping local proxy...")
            
            if (proxy != null) {
                proxy?.stop(0)
                proxy = null
                Log.d(TAG, "Proxy stopped successfully")
                result.success(true)
            } else {
                Log.d(TAG, "No proxy to stop")
                result.success(true)
            }
            
        } catch (e: Exception) {
            Log.e(TAG, "Error stopping local proxy", e)
            result.error("STOP_ERROR", e.message, null)
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        Log.d(TAG, "OutlineSdkPlugin detached from engine")
        channel.setMethodCallHandler(null)
        
        // Clean up proxy
        try {
            proxy?.stop(0)
            proxy = null
        } catch (e: Exception) {
            Log.e(TAG, "Error stopping proxy on detach", e)
        }
    }
}
