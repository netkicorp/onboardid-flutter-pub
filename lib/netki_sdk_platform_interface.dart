import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'netki_sdk_method_channel.dart';
import 'src/models/models.dart';

abstract class NetkiSdkPlatform extends PlatformInterface {
  NetkiSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static NetkiSdkPlatform _instance = MethodChannelNetkiSdk();

  static NetkiSdkPlatform get instance => _instance;

  static set instance(NetkiSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  // Initialization & Configuration

  Future<void> initialize({Environment? environment}) {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  Future<ResultInfo> configureWithToken({
    required String token,
    String accessCode = '',
  }) {
    throw UnimplementedError('configureWithToken() has not been implemented.');
  }

  // Security Code

  Future<ResultInfo> requestSecurityCode({required String phoneNumber}) {
    throw UnimplementedError('requestSecurityCode() has not been implemented.');
  }

  Future<void> bypassSecurityCode({required String phoneNumber}) {
    throw UnimplementedError('bypassSecurityCode() has not been implemented.');
  }

  Future<ResultInfo> confirmSecurityCode({
    required String phoneNumber,
    required String securityCode,
  }) {
    throw UnimplementedError('confirmSecurityCode() has not been implemented.');
  }

  // Business Metadata

  Future<void> setBusinessMetadata({required Map<String, String> metadata}) {
    throw UnimplementedError('setBusinessMetadata() has not been implemented.');
  }

  // Identification

  Future<void> startIdentification({
    required IdType idType,
    required IdCountry idCountry,
  }) {
    throw UnimplementedError('startIdentification() has not been implemented.');
  }

  Future<ResultInfo> submitIdentification({
    Map<AdditionalDataField, String> additionalData = const {},
  }) {
    throw UnimplementedError(
      'submitIdentification() has not been implemented.',
    );
  }

  // Biometrics

  Future<void> startBiometrics({required String transactionId}) {
    throw UnimplementedError('startBiometrics() has not been implemented.');
  }

  Future<ResultInfo> submitBiometrics({
    Map<AdditionalDataField, String> additionalData = const {},
  }) {
    throw UnimplementedError('submitBiometrics() has not been implemented.');
  }

  // Data Retrieval

  Future<List<IdType>> getAvailableIdTypes() {
    throw UnimplementedError('getAvailableIdTypes() has not been implemented.');
  }

  Future<List<IdCountry>> getAvailableCountries() {
    throw UnimplementedError(
      'getAvailableCountries() has not been implemented.',
    );
  }

  Future<BusinessConfiguration> getBusinessConfiguration() {
    throw UnimplementedError(
      'getBusinessConfiguration() has not been implemented.',
    );
  }

  // Settings

  Future<void> setLocation({required String lat, required String lon}) {
    throw UnimplementedError('setLocation() has not been implemented.');
  }

  Future<void> setLivenessSettings({required bool enabled}) {
    throw UnimplementedError('setLivenessSettings() has not been implemented.');
  }

  Future<void> setClientGuid({required String clientGuid}) {
    throw UnimplementedError('setClientGuid() has not been implemented.');
  }

  // UI Customization

  Future<void> applyTheme({required OnBoardIdTheme theme}) {
    throw UnimplementedError('applyTheme() has not been implemented.');
  }

  // Events

  Stream<IdentificationEvent> get identificationEvents {
    throw UnimplementedError('identificationEvents has not been implemented.');
  }
}
