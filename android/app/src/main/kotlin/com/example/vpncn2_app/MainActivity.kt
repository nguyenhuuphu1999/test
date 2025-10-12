package com.example.vpncn2_app

import android.content.Intent
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import com.example.vpncn2_app.VpnServicePlugin
import com.example.vpncn2_app.OutlineSdkPlugin

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Đăng ký plugin VPN cũ (nếu bạn vẫn dùng vài hàm)
        flutterEngine.plugins.add(VpnServicePlugin())

        // Đăng ký Outline SDK channel
        flutterEngine.plugins.add(OutlineSdkPlugin())
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        Log.d("MainActivity", "onActivityResult: request=$requestCode result=$resultCode")
    }
}
