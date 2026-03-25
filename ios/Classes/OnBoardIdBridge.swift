import Flutter
import UIKit
import NetkiSDK
import SwiftUI

class OnBoardIdBridge: NSObject, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?

    func handle(call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "initialize":
            initialize(call: call, result: result)
        case "configureWithToken":
            configureWithToken(call: call, result: result)
        case "requestSecurityCode":
            requestSecurityCode(call: call, result: result)
        case "bypassSecurityCode":
            bypassSecurityCode(call: call, result: result)
        case "confirmSecurityCode":
            confirmSecurityCode(call: call, result: result)
        case "setBusinessMetadata":
            setBusinessMetadata(call: call, result: result)
        case "startIdentification":
            startIdentification(call: call, result: result)
        case "submitIdentification":
            submitIdentification(call: call, result: result)
        case "startBiometrics":
            startBiometrics(call: call, result: result)
        case "submitBiometrics":
            submitBiometrics(call: call, result: result)
        case "getAvailableIdTypes":
            getAvailableIdTypes(result: result)
        case "getAvailableCountries":
            getAvailableCountries(result: result)
        case "getBusinessConfiguration":
            getBusinessConfiguration(result: result)
        case "setLocation":
            setLocation(call: call, result: result)
        case "setLivenessSettings":
            setLivenessSettings(call: call, result: result)
        case "setClientGuid":
            setClientGuid(call: call, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // MARK: - Initialization & Configuration

    private func initialize(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? [String: Any]
        let environmentStr = args?["environment"] as? String

        var environment: Environments? = nil
        if let envStr = environmentStr {
            environment = Environments(rawValue: envStr)
        }

        OnBoardId.shared.initialize(environment: environment)
        result(nil)
    }

    private func configureWithToken(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let token = args["token"] as? String else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Token is required", details: nil))
            return
        }

        let accessCode = args["accessCode"] as? String ?? ""

        Task {
            let resultInfo = await OnBoardId.shared.configureWithToken(token: token, accessCode: accessCode)
            DispatchQueue.main.async {
                result(Mappers.resultInfoToMap(resultInfo))
            }
        }
    }

    // MARK: - Security Code

    private func requestSecurityCode(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let phoneNumber = args["phoneNumber"] as? String else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Phone number is required", details: nil))
            return
        }

        Task {
            let resultInfo = await OnBoardId.shared.requestSecurityCode(phoneNumber: phoneNumber)
            DispatchQueue.main.async {
                result(Mappers.resultInfoToMap(resultInfo))
            }
        }
    }

    private func bypassSecurityCode(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let phoneNumber = args["phoneNumber"] as? String else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Phone number is required", details: nil))
            return
        }

        OnBoardId.shared.bypassSecurityCode(phoneNumber: phoneNumber)
        result(nil)
    }

    private func confirmSecurityCode(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let phoneNumber = args["phoneNumber"] as? String,
              let securityCode = args["securityCode"] as? String else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Phone number and security code are required", details: nil))
            return
        }

        Task {
            let resultInfo = await OnBoardId.shared.confirmSecurityCode(
                phoneNumber: phoneNumber,
                securityCode: securityCode
            )
            DispatchQueue.main.async {
                result(Mappers.resultInfoToMap(resultInfo))
            }
        }
    }

    // MARK: - Business Metadata

    private func setBusinessMetadata(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let metadata = args["metadata"] as? [String: String] else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Metadata is required", details: nil))
            return
        }

        OnBoardId.shared.setBusinessMetadata(businessMetadata: metadata)
        result(nil)
    }

    // MARK: - Identification

    private func startIdentification(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let idTypeStr = args["idType"] as? String,
              let idCountryMap = args["idCountry"] as? [String: Any] else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "ID type and country are required", details: nil))
            return
        }

        guard let idType = IdType(rawValue: idTypeStr) else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid ID type", details: nil))
            return
        }

        let idCountry = Mappers.mapToIdCountry(idCountryMap)

        let identificationView = OnBoardId.shared.getIdentificationView(
            idType: idType,
            idCountry: idCountry,
            identificationDelegate: self
        )

        presentView(identificationView, result: result)
    }

    private func submitIdentification(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? [String: Any]
        let additionalDataMap = args?["additionalData"] as? [String: String] ?? [:]
        let additionalData = Mappers.mapToAdditionalDataFields(additionalDataMap)

        Task {
            let resultInfo = await OnBoardId.shared.submitIdentification(additionalData: additionalData)
            DispatchQueue.main.async {
                result(Mappers.resultInfoToMap(resultInfo))
            }
        }
    }

    // MARK: - Biometrics

    private func startBiometrics(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let transactionId = args["transactionId"] as? String else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Transaction ID is required", details: nil))
            return
        }

        let biometricsView = OnBoardId.shared.getBiometricsView(
            transactionId: transactionId,
            identificationDelegate: self
        )

        presentView(biometricsView, result: result)
    }

    private func submitBiometrics(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? [String: Any]
        let additionalDataMap = args?["additionalData"] as? [String: String] ?? [:]
        let additionalData = Mappers.mapToAdditionalDataFields(additionalDataMap)

        Task {
            let resultInfo = await OnBoardId.shared.submitBiometrics(additionalData: additionalData)
            DispatchQueue.main.async {
                result(Mappers.resultInfoToMap(resultInfo))
            }
        }
    }

    // MARK: - Data Retrieval

    private func getAvailableIdTypes(result: @escaping FlutterResult) {
        let idTypes = OnBoardId.shared.getAvailableIdTypes()
        let idTypeStrings = idTypes.map { $0.rawValue }
        result(idTypeStrings)
    }

    private func getAvailableCountries(result: @escaping FlutterResult) {
        let countries = OnBoardId.shared.getAvailableCountries()
        let countryMaps = countries.map { Mappers.idCountryToMap($0) }
        result(countryMaps)
    }

    private func getBusinessConfiguration(result: @escaping FlutterResult) {
        let config = OnBoardId.shared.getBusinessConfiguration()
        result(Mappers.businessConfigurationToMap(config))
    }

    // MARK: - Settings

    private func setLocation(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let lat = args["lat"] as? String,
              let lon = args["lon"] as? String else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Latitude and longitude are required", details: nil))
            return
        }

        OnBoardId.shared.setLocation(lat: lat, lon: lon)
        result(nil)
    }

    private func setLivenessSettings(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let enabled = args["enabled"] as? Bool else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Enabled flag is required", details: nil))
            return
        }

        OnBoardId.shared.setLivenessSettings(enabled: enabled)
        result(nil)
    }

    private func setClientGuid(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let clientGuid = args["clientGuid"] as? String else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Client GUID is required", details: nil))
            return
        }

        OnBoardId.shared.setClientGuid(clientGuid: clientGuid)
        result(nil)
    }

    // MARK: - View Presentation

    private func presentView<V: View>(_ view: V, result: @escaping FlutterResult) {
        guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else {
            result(FlutterError(code: "NO_VIEW_CONTROLLER", message: "Cannot get root view controller", details: nil))
            return
        }

        let hostingController = UIHostingController(rootView: view)
        hostingController.modalPresentationStyle = .fullScreen
        rootViewController.present(hostingController, animated: true) {
            result(nil)
        }
    }

    private func dismissPresentedViewController() {
        DispatchQueue.main.async {
            if let rootViewController = UIApplication.shared.keyWindow?.rootViewController,
               let presentedVC = rootViewController.presentedViewController {
                presentedVC.dismiss(animated: true)
            }
        }
    }

    // MARK: - Event Sending

    private func sendEvent(_ event: [String: Any]) {
        DispatchQueue.main.async {
            self.eventSink?(event)
        }
    }

    // MARK: - FlutterStreamHandler

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
}

// MARK: - IdentificationDelegate

extension OnBoardIdBridge: IdentificationDelegate {
    func onCaptureIdentificationSuccessfully(extraData: [String: Any]?) {
        dismissPresentedViewController()
        sendEvent([
            "event": "onCaptureIdentificationSuccessfully",
            "extraData": Mappers.sanitizeForFlutter(extraData) ?? [:]
        ])
    }

    func onCaptureIdentificationCancelled(resultInfo: ResultInfo) {
        dismissPresentedViewController()
        sendEvent([
            "event": "onCaptureIdentificationCancelled",
            "resultInfo": Mappers.resultInfoToMap(resultInfo)
        ])
    }
}
