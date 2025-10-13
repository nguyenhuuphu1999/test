package com.example.vpncn2_app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.net.VpnService
import android.os.Build
import android.util.Log
import androidx.core.content.ContextCompat
import kotlinx.coroutines.*

class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action != Intent.ACTION_BOOT_COMPLETED &&
            intent.action != Intent.ACTION_LOCKED_BOOT_COMPLETED) return

        // Chỉ auto-start nếu user đã từng bật (prepare == null) và bạn có cờ "autoStart" lưu trong SharedPreferences
        val prefs = context.getSharedPreferences("vpn_prefs", Context.MODE_PRIVATE)
        val autoStart = prefs.getBoolean("autoStart", true) // cho phép cấu hình

        if (VpnService.prepare(context) == null && autoStart) {
            // Android vừa boot xong, delay 5–10 giây cho chắc (dịch vụ hệ thống ổn định)
            GlobalScope.launch(Dispatchers.Default) {
                delay(7000)
                try {
                    val svc = Intent(context, MyVpnService::class.java).apply {
                        // putExtra nếu cần cấu hình (key_data) đã lưu trước đó
                        val saved = prefs.getString("key_json", null)
                        if (saved != null) putExtra("key_data_json", saved)
                    }
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        ContextCompat.startForegroundService(context, svc)
                    } else {
                        context.startService(svc)
                    }
                    Log.d("BootReceiver", "Started MyVpnService after boot")
                } catch (e: Exception) {
                    Log.e("BootReceiver", "Failed to start VPN after boot: ${e.message}", e)
                }
            }
        } else {
            Log.d("BootReceiver", "Consent not granted or autoStart=false, skip auto start")
        }
    }
}
