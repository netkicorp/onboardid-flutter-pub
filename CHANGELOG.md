## 13.0.1

* Consumes native NetkiSDK 13.0.1 on iOS and 13.0.0 on Android (Android from Maven Central, iOS from CocoaPods trunk)
* On-device ID document recognition and screen-capture fraud detection are reported to the backend; neither surfaces anything in the UI, and both are controlled per country by the backend

## 12.1.0

* First public release to pub.dev
* Consumes native NetkiSDK 12.1.0 (Android from Maven Central, iOS from CocoaPods trunk)

## 12.0.1

* Consumes native NetkiSDK 12.0.1 (Android from Maven Central, iOS from CocoaPods trunk)
* netkicv is bundled into the shipped SDK artifacts — no more `art.myverify.io` Maven repository configuration required on consumer apps
* iOS bridge updated for `getIdentificationView` / `getBiometricsView` becoming `throws` in NetkiSDK 12.0.0

## 11.5.0

* Version alignment with SDK ecosystem

## 11.2.0

* Version alignment with SDK ecosystem

## 11.0.0-SNAPSHOT

* Add GitHub Actions for CI/CD
* Initial release of the Flutter bridge for NetkiSDK
* iOS and Android native bridge implementation
* Full identification flow support (document capture, submission)
* Business metadata and identity data support
* UI customization with OnBoardIdTheme
