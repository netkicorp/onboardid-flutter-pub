class BusinessConfiguration {
  final String? name;
  final String? identificationId;
  final String? welcomeMessage;
  final String? logoLight;
  final String? minimumAppVersion;
  final int? phonePinTimeout;
  final int? phoneRetryAttemptLimit;
  final bool? phoneUseAutomaticBypass;
  final String? clientGuid;
  final String? redirectBackLink;
  final String? completedMessage;
  final bool isGeolocationEnabled;

  const BusinessConfiguration({
    this.name,
    this.identificationId,
    this.welcomeMessage,
    this.logoLight,
    this.minimumAppVersion,
    this.phonePinTimeout,
    this.phoneRetryAttemptLimit,
    this.phoneUseAutomaticBypass,
    this.clientGuid,
    this.redirectBackLink,
    this.completedMessage,
    this.isGeolocationEnabled = false,
  });

  factory BusinessConfiguration.fromMap(Map<String, dynamic> map) {
    return BusinessConfiguration(
      name: map['name'] as String?,
      identificationId: map['identificationId'] as String?,
      welcomeMessage: map['welcomeMessage'] as String?,
      logoLight: map['logoLight'] as String?,
      minimumAppVersion: map['minimumAppVersion'] as String?,
      phonePinTimeout: map['phonePinTimeout'] as int?,
      phoneRetryAttemptLimit: map['phoneRetryAttemptLimit'] as int?,
      phoneUseAutomaticBypass: map['phoneUseAutomaticBypass'] as bool?,
      clientGuid: map['clientGuid'] as String?,
      redirectBackLink: map['redirectBackLink'] as String?,
      completedMessage: map['completedMessage'] as String?,
      isGeolocationEnabled: map['isGeolocationEnabled'] as bool? ?? false,
    );
  }
}
