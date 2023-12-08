class ServiceDetailsParams {
  String cityId;
  String serviceProviderId;
  String subServiceId;

  ServiceDetailsParams(
      {required this.serviceProviderId,
      required this.cityId,
      required this.subServiceId});

  ServiceDetailsParams copyWith(
      {String? cityId, String? serviceProviderId, String? subServiceId}) {
    return ServiceDetailsParams(
        cityId: cityId ?? this.cityId,
        serviceProviderId: serviceProviderId ?? this.serviceProviderId,
        subServiceId: subServiceId ?? this.subServiceId);
  }
}
