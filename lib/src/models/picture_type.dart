enum PictureType {
  front('front'),
  back('back'),
  liveness('liveness_image'),
  selfie('selfie'),
  epassport('e-passport');

  const PictureType(this.value);
  final String value;

  static PictureType? fromValue(String value) {
    return PictureType.values.cast<PictureType?>().firstWhere(
      (e) => e?.value == value,
      orElse: () => null,
    );
  }
}
