class ProviderParams {
  String cityId;
  String pageIndex;

  ProviderParams({required this.pageIndex, required this.cityId});

  ProviderParams copyWith({String? cityId, String? pageIndex}) {
    return ProviderParams(
      pageIndex: pageIndex ?? this.pageIndex,
      cityId: cityId ?? this.cityId,
    );
  }
}
