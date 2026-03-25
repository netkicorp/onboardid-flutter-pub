package com.netki.netki_sdk

import android.app.Activity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class NetkiSdkPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var methodChannel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private var activity: Activity? = null

    private val onBoardIdBridge = OnBoardIdBridge()
    private val onBoardIdUiBridge = OnBoardIdUiBridge()

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "netki_sdk")
        methodChannel.setMethodCallHandler(this)

        eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "netki_sdk/events")
        eventChannel.setStreamHandler(onBoardIdBridge)

        onBoardIdBridge.setContext(flutterPluginBinding.applicationContext)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }
            "applyTheme" -> {
                onBoardIdUiBridge.handle(call, result)
            }
            else -> {
                onBoardIdBridge.handle(call, result, activity)
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        onBoardIdBridge.setActivityBinding(binding)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
        onBoardIdBridge.clearActivityBinding()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
        onBoardIdBridge.setActivityBinding(binding)
    }

    override fun onDetachedFromActivity() {
        activity = null
        onBoardIdBridge.clearActivityBinding()
    }
}
