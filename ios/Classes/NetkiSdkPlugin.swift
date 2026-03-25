import Flutter
import UIKit

public class NetkiSdkPlugin: NSObject, FlutterPlugin {
    private let onBoardIdBridge = OnBoardIdBridge()
    private let onBoardIdUiBridge = OnBoardIdUiBridge()

    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = NetkiSdkPlugin()

        let methodChannel = FlutterMethodChannel(
            name: "netki_sdk",
            binaryMessenger: registrar.messenger()
        )
        registrar.addMethodCallDelegate(instance, channel: methodChannel)

        let eventChannel = FlutterEventChannel(
            name: "netki_sdk/events",
            binaryMessenger: registrar.messenger()
        )
        eventChannel.setStreamHandler(instance.onBoardIdBridge)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)

        case "applyTheme":
            onBoardIdUiBridge.handle(call: call, result: result)

        default:
            onBoardIdBridge.handle(call: call, result: result)
        }
    }
}
