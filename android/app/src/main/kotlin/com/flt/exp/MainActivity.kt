package com.flt.exp

import android.os.Bundle
import android.util.Log
import android.widget.EditText
import androidx.annotation.NonNull
import com.flt.exp.base.ChannelResponse
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
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


    private fun registerMethodChannel(exe :DartExecutor){
        val channel = MethodChannel(exe, "intent")
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
