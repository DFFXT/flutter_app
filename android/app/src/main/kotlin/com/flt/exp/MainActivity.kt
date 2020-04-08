package com.flt.exp

import android.util.Log
import androidx.annotation.NonNull
import com.flt.exp.base.ChannelResponse
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        val channel = MethodChannel(flutterEngine.dartExecutor, "intent")
        channel.setMethodCallHandler { call, result ->
            val argument = call.arguments as Map<*, *>


            val res=when(call.method){
                "test" ->  {
                    //result.success("ok!")
                    result.error("error",null,null)
                    ChannelResponse(argument["flag"] as String,argument["argument"] as String)
                }
                else -> null
            }
            Log.i("logInfo","$res")
        }
    }
}
