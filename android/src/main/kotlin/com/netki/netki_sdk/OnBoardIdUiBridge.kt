package com.netki.netki_sdk

import com.netki.OnBoardIdUiV2
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result

class OnBoardIdUiBridge {

    fun handle(call: MethodCall, result: Result) {
        when (call.method) {
            "applyTheme" -> applyTheme(call, result)
            else -> result.notImplemented()
        }
    }

    private fun applyTheme(call: MethodCall, result: Result) {
        try {
            @Suppress("UNCHECKED_CAST")
            val args = call.arguments as? Map<String, Any?>
            if (args == null) {
                result.error("INVALID_ARGUMENT", "Arguments are required", null)
                return
            }

            @Suppress("UNCHECKED_CAST")
            val themeMap = args["theme"] as? Map<String, Any?>
            if (themeMap == null) {
                result.error("INVALID_ARGUMENT", "Theme map is required", null)
                return
            }

            val theme = Mappers.mapToOnBoardIdTheme(themeMap)
            OnBoardIdUiV2.applyTheme(theme)
            result.success(null)
        } catch (e: Exception) {
            result.error("THEME_ERROR", e.message, e.stackTraceToString())
        }
    }
}
