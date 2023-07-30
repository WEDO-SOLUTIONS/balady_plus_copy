class ServiceParams {
  String cityId;
  String subServiceId;
  String subServiceName;
  String pageIndex;
  String? name;

  ServiceParams(
      {required this.pageIndex,
      required this.cityId,
      required this.subServiceId,
      required this.subServiceName,
      this.name});

  ServiceParams copyWith(
      {String? cityId,
      String? pageIndex,
      String? subServiceId,
      String? subServiceName,
      String? name}) {
    return ServiceParams(
        pageIndex: pageIndex ?? this.pageIndex,
        cityId: cityId ?? this.cityId,
        subServiceId: subServiceId ?? this.subServiceId,
        subServiceName: subServiceName ?? this.subServiceName,
        name: name ?? this.name);
  }
}
