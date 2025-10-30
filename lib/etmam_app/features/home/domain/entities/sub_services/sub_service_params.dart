class SubServiceParams {
  String cityId;
  String mainServiceId;
  String mainServiceName;

  SubServiceParams(
      {required this.mainServiceId,
      required this.cityId,
      required this.mainServiceName});

  SubServiceParams copyWith(
      {String? cityId, String? mainServiceId, String? mainServiceName}) {
    return SubServiceParams(
        mainServiceId: mainServiceId ?? this.mainServiceId,
        cityId: cityId ?? this.cityId,
        mainServiceName: mainServiceName ?? this.mainServiceName);
  }
}
