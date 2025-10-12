package com.example.vpncn2_app

import android.content.Context
import android.content.Intent
import android.net.VpnService
import android.os.ParcelFileDescriptor
import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import org.json.JSONObject
import java.io.FileInputStream
import java.io.FileOutputStream
import java.net.InetSocketAddress
import java.nio.channels.DatagramChannel
import java.nio.channels.SocketChannel

class VpnServicePlugin : FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler, ActivityAware {
    private lateinit var channel: MethodChannel
    private lateinit var statusChannel: EventChannel
    private lateinit var context: Context
    private var activityBinding: ActivityPluginBinding? = null
    
    private var vpnService: CustomVpnService? = null
    private var statusSink: EventChannel.EventSink? = null
    private var currentVpnService: CustomVpnService? = null
    
    companion object {
        private const val CHANNEL = "vpncn2/vpn_service"
        private const val STATUS_CHANNEL = "vpncn2/vpn_status"
        private const val TAG = "VpnServicePlugin"
        private const val VPN_REQUEST_CODE = 1
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler(this)
        
        statusChannel = EventChannel(flutterPluginBinding.binaryMessenger, STATUS_CHANNEL)
        statusChannel.setStreamHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        statusChannel.setStreamHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activityBinding = binding
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activityBinding = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activityBinding = binding
    }

    override fun onDetachedFromActivity() {
        activityBinding = null
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "initialize" -> {
                initializeVpn(result)
            }
            "requestPermission" -> {
                requestVpnPermission(result)
            }
            "startVpn" -> {
                val remark = call.argument<String>("remark") ?: "VPNCN2"
                val config = call.argument<String>("config") ?: ""
                val keyId = call.argument<String>("keyId") ?: ""
                startVpn(remark, config, keyId, result)
            }
            "stopVpn" -> {
                stopVpn(result)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun initializeVpn(result: Result) {
        try {
            Log.d(TAG, "Initializing VPN service")
            vpnService = CustomVpnService()
            result.success(true)
        } catch (e: Exception) {
            Log.e(TAG, "Failed to initialize VPN service", e)
            result.error("INIT_ERROR", e.message, null)
        }
    }

    private fun requestVpnPermission(result: Result) {
        val activity = activityBinding?.activity ?: run {
            result.error("NO_ACTIVITY", "No activity available", null)
            return
        }
        
        val intent = VpnService.prepare(activity)
        if (intent != null) {
            activity.startActivityForResult(intent, VPN_REQUEST_CODE)
            result.success(false) // Permission not granted yet
        } else {
            result.success(true) // Permission already granted
        }
    }

    private fun startVpn(remark: String, config: String, keyId: String, result: Result) {
        try {
            Log.d(TAG, "Starting VPN: $remark")
            
            // Parse Shadowsocks config from Xray config
            val ssConfig = parseShadowsocksConfig(config)
            
            // Create new VPN service instance
            currentVpnService = CustomVpnService()
            currentVpnService?.startVpn(remark, ssConfig, keyId)
            
            result.success(true)
            
            // Notify status change
            statusSink?.success("connected")
            
        } catch (e: Exception) {
            Log.e(TAG, "Failed to start VPN", e)
            result.error("START_ERROR", e.message, null)
            statusSink?.success("error")
        }
    }

    private fun stopVpn(result: Result) {
        try {
            Log.d(TAG, "Stopping VPN")
            currentVpnService?.stopVpn()
            currentVpnService = null
            result.success(true)
            
            // Notify status change
            statusSink?.success("disconnected")
            
        } catch (e: Exception) {
            Log.e(TAG, "Failed to stop VPN", e)
            result.error("STOP_ERROR", e.message, null)
        }
    }

    private fun parseShadowsocksConfig(xrayConfig: String): ShadowsocksConfig {
        try {
            val json = JSONObject(xrayConfig)
            val outbounds = json.getJSONArray("outbounds")
            val shadowsocksOutbound = outbounds.getJSONObject(0)
            val settings = shadowsocksOutbound.getJSONObject("settings")
            val servers = settings.getJSONArray("servers")
            val server = servers.getJSONObject(0)
            
            return ShadowsocksConfig(
                address = server.getString("address"),
                port = server.getInt("port"),
                method = server.getString("method"),
                password = server.getString("password")
            )
        } catch (e: Exception) {
            Log.e(TAG, "Failed to parse Shadowsocks config", e)
            throw IllegalArgumentException("Invalid config format")
        }
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        statusSink = events
    }

    override fun onCancel(arguments: Any?) {
        statusSink = null
    }

    data class ShadowsocksConfig(
        val address: String,
        val port: Int,
        val method: String,
        val password: String
    )
}

class CustomVpnService : VpnService() {
    private var vpnInterface: ParcelFileDescriptor? = null
    private var isRunning = false
    private var tunnelThread: Thread? = null
    
    fun startVpn(remark: String, config: VpnServicePlugin.ShadowsocksConfig, keyId: String) {
        Log.d("CustomVpnService", "Starting VPN tunnel for $remark")
        
        try {
            // Build VPN interface
            val builder = Builder()
                .setSession(remark)
                .addAddress("10.0.0.2", 32)
                .addRoute("0.0.0.0", 0)
                .addDnsServer("8.8.8.8")
                .addDnsServer("8.8.4.4")
                .setMtu(1500)
                .setBlocking(false)
            
            vpnInterface = builder.establish()
            
            if (vpnInterface != null) {
                isRunning = true
                
                // Start tunnel thread
                tunnelThread = Thread {
                    runVpnTunnel(config)
                }
                tunnelThread?.start()
                
                Log.d("CustomVpnService", "VPN tunnel started successfully")
            } else {
                Log.e("CustomVpnService", "Failed to establish VPN interface")
            }
        } catch (e: Exception) {
            Log.e("CustomVpnService", "Failed to start VPN tunnel", e)
            throw e
        }
    }
    
    private fun runVpnTunnel(config: VpnServicePlugin.ShadowsocksConfig) {
        Log.d("CustomVpnService", "Starting tunnel thread")
        
        var serverSocket: SocketChannel? = null
        var vpnInput: FileInputStream? = null
        var vpnOutput: FileOutputStream? = null
        
        try {
            vpnInput = FileInputStream(vpnInterface?.fileDescriptor)
            vpnOutput = FileOutputStream(vpnInterface?.fileDescriptor)
            
            // Connect to Shadowsocks server
            serverSocket = SocketChannel.open()
            serverSocket.connect(InetSocketAddress(config.address, config.port))
            
            Log.d("CustomVpnService", "Connected to Shadowsocks server: ${config.address}:${config.port}")
            
            // Start forwarding data
            val forwardToServer = Thread {
                try {
                    val buffer = ByteArray(2048)
                    while (isRunning && serverSocket.isConnected) {
                        val bytesRead = vpnInput?.read(buffer) ?: 0
                        if (bytesRead > 0) {
                            // Here you would encrypt with Shadowsocks
                            serverSocket.write(java.nio.ByteBuffer.wrap(buffer, 0, bytesRead))
                        }
                    }
                } catch (e: Exception) {
                    Log.e("CustomVpnService", "Error forwarding to server", e)
                }
            }
            
            val forwardFromServer = Thread {
                try {
                    while (isRunning && serverSocket.isConnected) {
                        val byteBuffer = java.nio.ByteBuffer.allocate(2048)
                        val bytesRead = serverSocket.read(byteBuffer)
                        if (bytesRead > 0) {
                            byteBuffer.flip()
                            val data = ByteArray(bytesRead)
                            byteBuffer.get(data)
                            // Here you would decrypt with Shadowsocks
                            vpnOutput?.write(data)
                        }
                    }
                } catch (e: Exception) {
                    Log.e("CustomVpnService", "Error forwarding from server", e)
                }
            }
            
            forwardToServer.start()
            forwardFromServer.start()
            
            // Wait for threads to finish
            forwardToServer.join()
            forwardFromServer.join()
            
        } catch (e: Exception) {
            Log.e("CustomVpnService", "Tunnel error", e)
        } finally {
            try {
                serverSocket?.close()
                vpnInput?.close()
                vpnOutput?.close()
            } catch (e: Exception) {
                Log.e("CustomVpnService", "Error closing resources", e)
            }
        }
        
        Log.d("CustomVpnService", "Tunnel thread ended")
    }
    
    fun stopVpn() {
        Log.d("CustomVpnService", "Stopping VPN tunnel")
        
        isRunning = false
        
        try {
            tunnelThread?.interrupt()
            tunnelThread?.join(1000)
            
            vpnInterface?.close()
            vpnInterface = null
            
            Log.d("CustomVpnService", "VPN tunnel stopped")
        } catch (e: Exception) {
            Log.e("CustomVpnService", "Error stopping VPN tunnel", e)
        }
    }
}
