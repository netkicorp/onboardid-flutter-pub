enum RequestStatus {
  SUCCESS,
  ERROR;

  static RequestStatus fromString(String value) {
    return value == 'SUCCESS' ? RequestStatus.SUCCESS : RequestStatus.ERROR;
  }
}

enum ErrorType {
  NO_INTERNET,
  INVALID_DATA,
  INVALID_TOKEN,
  INVALID_ACCESS_CODE,
  INVALID_PHONE_NUMBER,
  INVALID_CONFIRMATION_CODE,
  USER_CANCEL_IDENTIFICATION,
  TRANSACTION_NOT_FOUND,
  CONFIGURATION_ERROR,
  UNEXPECTED_ERROR;

  static ErrorType? fromString(String? value) {
    if (value == null) return null;
    return ErrorType.values.cast<ErrorType?>().firstWhere(
      (e) => e?.name == value,
      orElse: () => null,
    );
  }
}

class ResultInfo {
  final RequestStatus status;
  final Map<String, String>? extraData;
  final ErrorType? errorType;
  final String? message;

  const ResultInfo({
    required this.status,
    this.extraData,
    this.errorType,
    this.message,
  });

  bool get isSuccessful => status == RequestStatus.SUCCESS;

  factory ResultInfo.fromMap(Map<String, dynamic> map) {
    return ResultInfo(
      status: RequestStatus.fromString(map['status'] as String? ?? 'ERROR'),
      extraData: (map['extraData'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
      errorType: ErrorType.fromString(map['errorType'] as String?),
      message: map['message'] as String?,
    );
  }

  factory ResultInfo.success({Map<String, String>? extraData}) {
    return ResultInfo(status: RequestStatus.SUCCESS, extraData: extraData);
  }

  factory ResultInfo.error({ErrorType? errorType, String? message}) {
    return ResultInfo(
      status: RequestStatus.ERROR,
      errorType: errorType,
      message: message,
    );
  }
}
