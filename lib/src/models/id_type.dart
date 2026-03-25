enum IdType {
  driversLicense('drivers_license'),
  passport('passport'),
  governmentId('government_id'),
  biometrics('biometrics');

  const IdType(this.value);
  final String value;

  static IdType? fromValue(String value) {
    return IdType.values.cast<IdType?>().firstWhere(
      (e) => e?.value == value,
      orElse: () => null,
    );
  }
}
