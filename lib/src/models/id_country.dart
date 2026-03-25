class IdCountry {
  final String name;
  final String alpha2;
  final String alpha3;
  final String countryCallingCode;
  final bool hasBarcodeId;
  final String? flag;
  final bool isBanned;
  final bool hasNfcPassport;

  const IdCountry({
    required this.name,
    required this.alpha2,
    required this.alpha3,
    required this.countryCallingCode,
    required this.hasBarcodeId,
    this.flag,
    this.isBanned = false,
    this.hasNfcPassport = false,
  });

  factory IdCountry.fromMap(Map<String, dynamic> map) {
    return IdCountry(
      name: map['name'] as String? ?? '',
      alpha2: map['alpha2'] as String? ?? '',
      alpha3: map['alpha3'] as String? ?? '',
      countryCallingCode: map['countryCallingCode'] as String? ?? '',
      hasBarcodeId: map['hasBarcodeId'] as bool? ?? false,
      flag: map['flag'] as String?,
      isBanned: map['isBanned'] as bool? ?? false,
      hasNfcPassport: map['hasNfcPassport'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'alpha2': alpha2,
      'alpha3': alpha3,
      'countryCallingCode': countryCallingCode,
      'hasBarcodeId': hasBarcodeId,
      'flag': flag,
      'isBanned': isBanned,
      'hasNfcPassport': hasNfcPassport,
    };
  }
}
