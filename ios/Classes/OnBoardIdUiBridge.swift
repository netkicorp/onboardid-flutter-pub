import Flutter
import NetkiSDK

class OnBoardIdUiBridge {

    func handle(call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "applyTheme":
            applyTheme(call: call, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func applyTheme(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any],
              let themeMap = args["theme"] as? [String: Any] else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "Theme is required", details: nil))
            return
        }

        let theme = Mappers.mapToOnBoardIdTheme(themeMap)
        OnBoardIdUiV2.applyTheme(theme)
        result(nil)
    }
}
