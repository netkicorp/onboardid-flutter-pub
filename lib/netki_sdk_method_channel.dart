import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'netki_sdk_platform_interface.dart';
import 'src/models/models.dart';

class MethodChannelNetkiSdk extends NetkiSdkPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('netki_sdk');

  @visibleForTesting
  final eventChannel = const EventChannel('netki_sdk/events');

  Stream<IdentificationEvent>? _identificationEventsStream;

  // Initialization & Configuration

  @override
  Future<void> initialize({Environment? environment}) async {
    await methodChannel.invokeMethod('initialize', {
      'environment': environment?.value,
    });
  }

  @override
  Future<ResultInfo> configureWithToken({
    required String token,
    String accessCode = '',
  }) async {
    final result = await methodChannel.invokeMapMethod<String, dynamic>(
      'configureWithToken',
      {'token': token, 'accessCode': accessCode},
    );
    return ResultInfo.fromMap(result ?? {});
  }

  // Security Code

  @override
  Future<ResultInfo> requestSecurityCode({required String phoneNumber}) async {
    final result = await methodChannel.invokeMapMethod<String, dynamic>(
      'requestSecurityCode',
      {'phoneNumber': phoneNumber},
    );
    return ResultInfo.fromMap(result ?? {});
  }

  @override
  Future<void> bypassSecurityCode({required String phoneNumber}) async {
    await methodChannel.invokeMethod('bypassSecurityCode', {
      'phoneNumber': phoneNumber,
    });
  }

  @override
  Future<ResultInfo> confirmSecurityCode({
    required String phoneNumber,
    required String securityCode,
  }) async {
    final result = await methodChannel.invokeMapMethod<String, dynamic>(
      'confirmSecurityCode',
      {'phoneNumber': phoneNumber, 'securityCode': securityCode},
    );
    return ResultInfo.fromMap(result ?? {});
  }

  // Business Metadata

  @override
  Future<void> setBusinessMetadata({
    required Map<String, String> metadata,
  }) async {
    await methodChannel.invokeMethod('setBusinessMetadata', {
      'metadata': metadata,
    });
  }

  // Identification

  @override
  Future<void> startIdentification({
    required IdType idType,
    required IdCountry idCountry,
  }) async {
    await methodChannel.invokeMethod('startIdentification', {
      'idType': idType.value,
      'idCountry': idCountry.toMap(),
    });
  }

  @override
  Future<ResultInfo> submitIdentification({
    Map<AdditionalDataField, String> additionalData = const {},
  }) async {
    final result = await methodChannel
        .invokeMapMethod<String, dynamic>('submitIdentification', {
          'additionalData': additionalData.map(
            (key, value) => MapEntry(key.value, value),
          ),
        });
    return ResultInfo.fromMap(result ?? {});
  }

  // Biometrics

  @override
  Future<void> startBiometrics({required String transactionId}) async {
    await methodChannel.invokeMethod('startBiometrics', {
      'transactionId': transactionId,
    });
  }

  @override
  Future<ResultInfo> submitBiometrics({
    Map<AdditionalDataField, String> additionalData = const {},
  }) async {
    final result = await methodChannel
        .invokeMapMethod<String, dynamic>('submitBiometrics', {
          'additionalData': additionalData.map(
            (key, value) => MapEntry(key.value, value),
          ),
        });
    return ResultInfo.fromMap(result ?? {});
  }

  // Data Retrieval

  @override
  Future<List<IdType>> getAvailableIdTypes() async {
    final result = await methodChannel.invokeListMethod<String>(
      'getAvailableIdTypes',
    );
    return result
            ?.map((e) => IdType.fromValue(e))
            .whereType<IdType>()
            .toList() ??
        [];
  }

  @override
  Future<List<IdCountry>> getAvailableCountries() async {
    final result = await methodChannel.invokeListMethod<Map<Object?, Object?>>(
      'getAvailableCountries',
    );
    return result
            ?.map(
              (e) =>
                  IdCountry.fromMap(e.map((k, v) => MapEntry(k.toString(), v))),
            )
            .toList() ??
        [];
  }

  @override
  Future<BusinessConfiguration> getBusinessConfiguration() async {
    final result = await methodChannel.invokeMapMethod<String, dynamic>(
      'getBusinessConfiguration',
    );
    return BusinessConfiguration.fromMap(result ?? {});
  }

  // Settings

  @override
  Future<void> setLocation({required String lat, required String lon}) async {
    await methodChannel.invokeMethod('setLocation', {'lat': lat, 'lon': lon});
  }

  @override
  Future<void> setLivenessSettings({required bool enabled}) async {
    await methodChannel.invokeMethod('setLivenessSettings', {
      'enabled': enabled,
    });
  }

  @override
  Future<void> setClientGuid({required String clientGuid}) async {
    await methodChannel.invokeMethod('setClientGuid', {
      'clientGuid': clientGuid,
    });
  }

  // UI Customization

  @override
  Future<void> applyTheme({required OnBoardIdTheme theme}) async {
    await methodChannel.invokeMethod('applyTheme', {'theme': theme.toMap()});
  }

  // Events

  @override
  Stream<IdentificationEvent> get identificationEvents {
    _identificationEventsStream ??= eventChannel.receiveBroadcastStream().map(
      (event) => IdentificationEvent.fromMap(
        (event as Map<Object?, Object?>).map(
          (k, v) => MapEntry(k.toString(), v),
        ),
      ),
    );
    return _identificationEventsStream!;
  }
}
