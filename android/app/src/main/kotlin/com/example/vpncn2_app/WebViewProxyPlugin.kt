package com.example.vpncn2_app

import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class WebViewProxyPlugin : FlutterPlugin, MethodChannel.MethodCallHandler {

    private lateinit var channel: MethodChannel

    companion object {
        private const val CHANNEL = "webview_proxy"
        private const val TAG = "WebViewProxyPlugin"
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler(this)
        Log.d(TAG, "WebViewProxyPlugin attached")
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        Log.d(TAG, "Method called: ${call.method}")
        
        when (call.method) {
            "clearWebViewProxy" -> {
                Log.d(TAG, "Clearing WebView proxy (mock implementation)")
                result.success(true)
            }
            "setWebViewProxy" -> {
                val host = call.argument<String>("host") ?: ""
                val port = call.argument<Int>("port") ?: 0
                Log.d(TAG, "Setting WebView proxy to $host:$port (mock implementation)")
                result.success(true)
            }
            else -> {
                Log.w(TAG, "Unknown method: ${call.method}")
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        Log.d(TAG, "WebViewProxyPlugin detached")
    }
}
