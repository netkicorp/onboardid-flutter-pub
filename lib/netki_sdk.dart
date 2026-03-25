export 'src/models/models.dart';

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'netki_sdk_platform_interface.dart';
import 'src/models/models.dart';

class NetkiSdk {
  NetkiSdk._();
  static final NetkiSdk instance = NetkiSdk._();

  // Initialization & Configuration

  Future<void> initialize({Environment? environment}) {
    return NetkiSdkPlatform.instance.initialize(environment: environment);
  }

  Future<ResultInfo> configureWithToken({
    required String token,
    String accessCode = '',
  }) {
    return NetkiSdkPlatform.instance.configureWithToken(
      token: token,
      accessCode: accessCode,
    );
  }

  // Security Code

  Future<ResultInfo> requestSecurityCode({required String phoneNumber}) {
    return NetkiSdkPlatform.instance.requestSecurityCode(
      phoneNumber: phoneNumber,
    );
  }

  Future<void> bypassSecurityCode({required String phoneNumber}) {
    return NetkiSdkPlatform.instance.bypassSecurityCode(
      phoneNumber: phoneNumber,
    );
  }

  Future<ResultInfo> confirmSecurityCode({
    required String phoneNumber,
    required String securityCode,
  }) {
    return NetkiSdkPlatform.instance.confirmSecurityCode(
      phoneNumber: phoneNumber,
      securityCode: securityCode,
    );
  }

  // Business Metadata

  Future<void> setBusinessMetadata({required Map<String, String> metadata}) {
    return NetkiSdkPlatform.instance.setBusinessMetadata(metadata: metadata);
  }

  // Identification

  Future<void> startIdentification({
    required IdType idType,
    required IdCountry idCountry,
  }) {
    return NetkiSdkPlatform.instance.startIdentification(
      idType: idType,
      idCountry: idCountry,
    );
  }

  Future<ResultInfo> submitIdentification({
    Map<AdditionalDataField, String> additionalData = const {},
  }) {
    return NetkiSdkPlatform.instance.submitIdentification(
      additionalData: additionalData,
    );
  }

  // Biometrics

  Future<void> startBiometrics({required String transactionId}) {
    return NetkiSdkPlatform.instance.startBiometrics(
      transactionId: transactionId,
    );
  }

  Future<ResultInfo> submitBiometrics({
    Map<AdditionalDataField, String> additionalData = const {},
  }) {
    return NetkiSdkPlatform.instance.submitBiometrics(
      additionalData: additionalData,
    );
  }

  // Data Retrieval

  Future<List<IdType>> getAvailableIdTypes() {
    return NetkiSdkPlatform.instance.getAvailableIdTypes();
  }

  Future<List<IdCountry>> getAvailableCountries() {
    return NetkiSdkPlatform.instance.getAvailableCountries();
  }

  Future<BusinessConfiguration> getBusinessConfiguration() {
    return NetkiSdkPlatform.instance.getBusinessConfiguration();
  }

  // Settings

  Future<void> setLocation({required String lat, required String lon}) {
    return NetkiSdkPlatform.instance.setLocation(lat: lat, lon: lon);
  }

  Future<void> setLivenessSettings({required bool enabled}) {
    return NetkiSdkPlatform.instance.setLivenessSettings(enabled: enabled);
  }

  Future<void> setClientGuid({required String clientGuid}) {
    return NetkiSdkPlatform.instance.setClientGuid(clientGuid: clientGuid);
  }

  // UI Customization

  Future<void> applyTheme({required OnBoardIdTheme theme}) {
    return NetkiSdkPlatform.instance.applyTheme(theme: theme);
  }

  // Asset Helper

  /// Resolves a Flutter asset path to a file path that can be used by native SDKs.
  ///
  /// This method copies the asset to a temporary directory and returns the file path.
  /// Use this when you need to pass Flutter assets to theme customization.
  ///
  /// Example:
  /// ```dart
  /// final iconPath = await NetkiSdk.instance.resolveAssetPath('assets/icons/my_icon.png');
  /// final theme = OnBoardIdTheme(
  ///   instructions: [
  ///     InstructionContent(
  ///       idType: IdType.driversLicense,
  ///       pictureType: PictureType.front,
  ///       steps: [
  ///         InstructionItem(text: 'Step 1', iconUrl: iconPath),
  ///       ],
  ///     ),
  ///   ],
  /// );
  /// await NetkiSdk.instance.applyTheme(theme: theme);
  /// ```
  Future<String> resolveAssetPath(String assetPath) async {
    final byteData = await rootBundle.load(assetPath);
    final tempDir = await getTemporaryDirectory();
    final fileName = assetPath.split('/').last;
    final file = File('${tempDir.path}/netki_assets/$fileName');

    await file.parent.create(recursive: true);
    await file.writeAsBytes(byteData.buffer.asUint8List());

    return file.path;
  }

  /// Resolves multiple Flutter asset paths at once.
  ///
  /// Returns a map of asset paths to their resolved file paths.
  Future<Map<String, String>> resolveAssetPaths(List<String> assetPaths) async {
    final results = <String, String>{};
    for (final path in assetPaths) {
      results[path] = await resolveAssetPath(path);
    }
    return results;
  }

  // Events

  Stream<IdentificationEvent> get identificationEvents {
    return NetkiSdkPlatform.instance.identificationEvents;
  }
}
