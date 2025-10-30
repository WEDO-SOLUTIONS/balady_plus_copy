class ProviderDetailsParams {
  String cityId;
  String providerId;

  ProviderDetailsParams({required this.providerId, required this.cityId});

  ProviderDetailsParams copyWith({String? cityId, String? providerId}) {
    return ProviderDetailsParams(
      providerId: providerId ?? this.providerId,
      cityId: cityId ?? this.cityId,
    );
  }
}
