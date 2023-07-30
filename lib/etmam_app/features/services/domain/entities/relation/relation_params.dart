class RelationParams {
  String cityId;
  String subServiceId;
  String serviceProviderId;
  String serviceProviderName;

  RelationParams(
      {required this.cityId,
      required this.subServiceId,
      required this.serviceProviderId,
      required this.serviceProviderName});

  RelationParams copyWith(
      {String? cityId,
      String? subServiceId,
      String? serviceProviderId,
      String? serviceProviderName}) {
    return RelationParams(
        cityId: cityId ?? this.cityId,
        subServiceId: subServiceId ?? this.subServiceId,
        serviceProviderId: serviceProviderId ?? this.serviceProviderId,
        serviceProviderName: serviceProviderName ?? this.serviceProviderName);
  }
}
