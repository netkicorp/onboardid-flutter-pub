package com.netki.netki_sdk

import android.app.Activity
import android.content.Context
import android.content.Intent
import com.google.accompanist.permissions.ExperimentalPermissionsApi
import com.netki.OnBoardId
import com.netki.model.AdditionalDataField
import com.netki.model.Environment
import com.netki.model.ErrorType
import com.netki.model.IdType
import com.netki.model.ResultInfo
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

@OptIn(ExperimentalPermissionsApi::class)
class OnBoardIdBridge : EventChannel.StreamHandler, PluginRegistry.ActivityResultListener {
    private var eventSink: EventChannel.EventSink? = null
    private var context: Context? = null
    private var activityBinding: ActivityPluginBinding? = null
    private var pendingResult: Result? = null

    companion object {
        private const val IDENTIFICATION_REQUEST_CODE = 1001
        private const val BIOMETRICS_REQUEST_CODE = 1002
    }

    fun setContext(context: Context) {
        this.context = context
    }

    fun setActivityBinding(binding: ActivityPluginBinding) {
        activityBinding = binding
        binding.addActivityResultListener(this)
    }

    fun clearActivityBinding() {
        activityBinding?.removeActivityResultListener(this)
        activityBinding = null
    }

    fun handle(call: MethodCall, result: Result, activity: Activity?) {
        when (call.method) {
            "initialize" -> initialize(call, result)
            "configureWithToken" -> configureWithToken(call, result)
            "requestSecurityCode" -> requestSecurityCode(call, result)
            "bypassSecurityCode" -> bypassSecurityCode(call, result)
            "confirmSecurityCode" -> confirmSecurityCode(call, result)
            "setBusinessMetadata" -> setBusinessMetadata(call, result)
            "startIdentification" -> startIdentification(call, result, activity)
            "submitIdentification" -> submitIdentification(call, result)
            "startBiometrics" -> startBiometrics(call, result, activity)
            "submitBiometrics" -> submitBiometrics(call, result)
            "getAvailableIdTypes" -> getAvailableIdTypes(result)
            "getAvailableCountries" -> getAvailableCountries(result)
            "getBusinessConfiguration" -> getBusinessConfiguration(result)
            "setLocation" -> setLocation(call, result)
            "setLivenessSettings" -> setLivenessSettings(call, result)
            "setClientGuid" -> setClientGuid(call, result)
            else -> result.notImplemented()
        }
    }

    // MARK: - Initialization & Configuration

    private fun initialize(call: MethodCall, result: Result) {
        val ctx = context ?: run {
            result.error("NO_CONTEXT", "Context not available", null)
            return
        }

        val environmentStr = call.argument<String>("environment")
        val environment = environmentStr?.let { Environment.valueOf(it) }

        OnBoardId.initialize(ctx, environment)
        result.success(null)
    }

    private fun configureWithToken(call: MethodCall, result: Result) {
        val token = call.argument<String>("token") ?: run {
            result.error("INVALID_ARGUMENTS", "Token is required", null)
            return
        }
        val accessCode = call.argument<String>("accessCode") ?: ""

        CoroutineScope(Dispatchers.Main).launch {
            val resultInfo = OnBoardId.configureWithToken(token, accessCode)
            result.success(Mappers.resultInfoToMap(resultInfo))
        }
    }

    // MARK: - Security Code

    private fun requestSecurityCode(call: MethodCall, result: Result) {
        val phoneNumber = call.argument<String>("phoneNumber") ?: run {
            result.error("INVALID_ARGUMENTS", "Phone number is required", null)
            return
        }

        CoroutineScope(Dispatchers.Main).launch {
            val resultInfo = OnBoardId.requestSecurityCode(phoneNumber)
            result.success(Mappers.resultInfoToMap(resultInfo))
        }
    }

    private fun bypassSecurityCode(call: MethodCall, result: Result) {
        val phoneNumber = call.argument<String>("phoneNumber") ?: run {
            result.error("INVALID_ARGUMENTS", "Phone number is required", null)
            return
        }

        OnBoardId.bypassSecurityCode(phoneNumber)
        result.success(null)
    }

    private fun confirmSecurityCode(call: MethodCall, result: Result) {
        val phoneNumber = call.argument<String>("phoneNumber") ?: run {
            result.error("INVALID_ARGUMENTS", "Phone number is required", null)
            return
        }
        val securityCode = call.argument<String>("securityCode") ?: run {
            result.error("INVALID_ARGUMENTS", "Security code is required", null)
            return
        }

        CoroutineScope(Dispatchers.Main).launch {
            val resultInfo = OnBoardId.confirmSecurityCode(phoneNumber, securityCode)
            result.success(Mappers.resultInfoToMap(resultInfo))
        }
    }

    // MARK: - Business Metadata

    private fun setBusinessMetadata(call: MethodCall, result: Result) {
        val metadata = call.argument<Map<String, String>>("metadata") ?: run {
            result.error("INVALID_ARGUMENTS", "Metadata is required", null)
            return
        }

        OnBoardId.setBusinessMetadata(metadata)
        result.success(null)
    }

    // MARK: - Identification

    private fun startIdentification(call: MethodCall, result: Result, activity: Activity?) {
        if (activity == null) {
            result.error("NO_ACTIVITY", "Activity not available", null)
            return
        }

        val idTypeStr = call.argument<String>("idType") ?: run {
            result.error("INVALID_ARGUMENTS", "ID type is required", null)
            return
        }
        val idCountryMap = call.argument<Map<String, Any>>("idCountry") ?: run {
            result.error("INVALID_ARGUMENTS", "ID country is required", null)
            return
        }

        val idType = IdType.entries.firstOrNull { it.type == idTypeStr } ?: run {
            result.error("INVALID_ARGUMENTS", "Invalid ID type", null)
            return
        }
        val idCountry = Mappers.mapToIdCountry(idCountryMap)

        pendingResult = result
        val intent = OnBoardId.getIdentificationIntent(idType, idCountry)
        activity.startActivityForResult(intent, IDENTIFICATION_REQUEST_CODE)
    }

    private fun submitIdentification(call: MethodCall, result: Result) {
        val additionalDataMap = call.argument<Map<String, String>>("additionalData") ?: emptyMap()
        val additionalData = Mappers.mapToAdditionalDataFields(additionalDataMap)

        CoroutineScope(Dispatchers.Main).launch {
            val resultInfo = OnBoardId.submitIdentification(additionalData)
            result.success(Mappers.resultInfoToMap(resultInfo))
        }
    }

    // MARK: - Biometrics

    private fun startBiometrics(call: MethodCall, result: Result, activity: Activity?) {
        if (activity == null) {
            result.error("NO_ACTIVITY", "Activity not available", null)
            return
        }

        val transactionId = call.argument<String>("transactionId") ?: run {
            result.error("INVALID_ARGUMENTS", "Transaction ID is required", null)
            return
        }

        pendingResult = result
        val intent = OnBoardId.getBiometricsIntent(transactionId)
        activity.startActivityForResult(intent, BIOMETRICS_REQUEST_CODE)
    }

    private fun submitBiometrics(call: MethodCall, result: Result) {
        val additionalDataMap = call.argument<Map<String, String>>("additionalData") ?: emptyMap()
        val additionalData = Mappers.mapToAdditionalDataFields(additionalDataMap)

        CoroutineScope(Dispatchers.Main).launch {
            val resultInfo = OnBoardId.submitBiometrics(additionalData)
            result.success(Mappers.resultInfoToMap(resultInfo))
        }
    }

    // MARK: - Data Retrieval

    private fun getAvailableIdTypes(result: Result) {
        val idTypes = OnBoardId.getAvailableIdTypes()
        val idTypeStrings = idTypes.map { it.type }
        result.success(idTypeStrings)
    }

    private fun getAvailableCountries(result: Result) {
        val countries = OnBoardId.getAvailableCountries()
        val countryMaps = countries.map { Mappers.idCountryToMap(it) }
        result.success(countryMaps)
    }

    private fun getBusinessConfiguration(result: Result) {
        val config = OnBoardId.getBusinessConfiguration()
        result.success(Mappers.businessConfigurationToMap(config))
    }

    // MARK: - Settings

    private fun setLocation(call: MethodCall, result: Result) {
        val lat = call.argument<String>("lat") ?: run {
            result.error("INVALID_ARGUMENTS", "Latitude is required", null)
            return
        }
        val lon = call.argument<String>("lon") ?: run {
            result.error("INVALID_ARGUMENTS", "Longitude is required", null)
            return
        }

        OnBoardId.setLocation(lat, lon)
        result.success(null)
    }

    private fun setLivenessSettings(call: MethodCall, result: Result) {
        val enabled = call.argument<Boolean>("enabled") ?: run {
            result.error("INVALID_ARGUMENTS", "Enabled flag is required", null)
            return
        }

        OnBoardId.setLivenessSettings(enabled)
        result.success(null)
    }

    private fun setClientGuid(call: MethodCall, result: Result) {
        val clientGuid = call.argument<String>("clientGuid") ?: run {
            result.error("INVALID_ARGUMENTS", "Client GUID is required", null)
            return
        }

        OnBoardId.setClientGuid(clientGuid)
        result.success(null)
    }

    // MARK: - Activity Result Handling

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode != IDENTIFICATION_REQUEST_CODE && requestCode != BIOMETRICS_REQUEST_CODE) {
            return false
        }

        when (resultCode) {
            Activity.RESULT_OK -> {
                @Suppress("UNCHECKED_CAST", "DEPRECATION")
                val pictures = data?.getSerializableExtra(ResultInfo.ExtraData.PICTURES.description) as? List<com.netki.model.Picture>
                val extraData = mutableMapOf<String, Any>()
                pictures?.let { extraData["pictures"] = Mappers.picturesToList(it) }

                sendEvent(mapOf(
                    "event" to "onCaptureIdentificationSuccessfully",
                    "extraData" to extraData
                ))
            }
            Activity.RESULT_CANCELED -> {
                val errorType = data?.getSerializableExtra(ResultInfo.ExtraData.ERROR_TYPE.description) as? ErrorType
                val message = data?.getStringExtra(ResultInfo.ExtraData.MESSAGE.description)

                val resultInfo = ResultInfo.error(errorType, message)
                sendEvent(mapOf(
                    "event" to "onCaptureIdentificationCancelled",
                    "resultInfo" to Mappers.resultInfoToMap(resultInfo)
                ))
            }
        }

        pendingResult?.success(null)
        pendingResult = null
        return true
    }

    // MARK: - Event Sending

    private fun sendEvent(event: Map<String, Any?>) {
        eventSink?.success(event)
    }

    // MARK: - EventChannel.StreamHandler

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }
}
