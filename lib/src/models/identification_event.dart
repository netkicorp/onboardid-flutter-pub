import 'result_info.dart';

sealed class IdentificationEvent {
  const IdentificationEvent();

  factory IdentificationEvent.fromMap(Map<String, dynamic> map) {
    final event = map['event'] as String;

    switch (event) {
      case 'onCaptureIdentificationSuccessfully':
        return IdentificationSuccess(
          extraData: (map['extraData'] as Map<Object?, Object?>?)?.map(
            (key, value) => MapEntry(key.toString(), value),
          ),
        );
      case 'onCaptureIdentificationCancelled':
        final resultInfoMap = map['resultInfo'] as Map<Object?, Object?>?;
        return IdentificationCancelled(
          resultInfo: resultInfoMap != null
              ? ResultInfo.fromMap(
                  resultInfoMap.map((k, v) => MapEntry(k.toString(), v)),
                )
              : null,
        );
      default:
        return IdentificationUnknown(event: event);
    }
  }
}

class IdentificationSuccess extends IdentificationEvent {
  final Map<String, dynamic>? extraData;

  const IdentificationSuccess({this.extraData});
}

class IdentificationCancelled extends IdentificationEvent {
  final ResultInfo? resultInfo;

  const IdentificationCancelled({this.resultInfo});
}

class IdentificationUnknown extends IdentificationEvent {
  final String event;

  const IdentificationUnknown({required this.event});
}
