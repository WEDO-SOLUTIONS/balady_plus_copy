class TopRatedProviderParams {
  String cityId;
  String pageSize;
  String pageIndex;
  String? name;

  TopRatedProviderParams(
      {required this.pageSize,
      required this.pageIndex,
      required this.cityId,
      this.name});

  TopRatedProviderParams copyWith(
      {String? cityId,
      String? pageSize,
      String? pageIndex,
      String? name,
      String? classificationId}) {
    return TopRatedProviderParams(
        pageSize: pageSize ?? this.pageSize,
        pageIndex: pageIndex ?? this.pageIndex,
        cityId: cityId ?? this.cityId,
        name: name ?? this.name);
  }
}
