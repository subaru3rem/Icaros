package com.example.hello

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.net.NetworkInterface

class MainActivity: FlutterActivity() {
  private val CHANNEL = "samples.flutter.dev/ip"

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
      call, result ->
      if (call.method == "teste"){
        var ip = Ip()
        result.success(ip)
      }else{
        result.notImplemented()
      }
    }
  }
  fun Ip(teste: Int=0):String{
    val networkInterfaces = NetworkInterface.getNetworkInterfaces()
    while (networkInterfaces.hasMoreElements()) {
        val networkInterface = networkInterfaces.nextElement()
        val hardwareAddress = networkInterface.hardwareAddress
        if (hardwareAddress != null) {
            return networkInterface.name + " " + hardwareAddress.joinToString(separator = ":")
        }
        
    }
    return "seila"

  }
}

