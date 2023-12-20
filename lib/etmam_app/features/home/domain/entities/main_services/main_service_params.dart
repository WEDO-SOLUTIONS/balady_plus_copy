class MainServiceParams {
  String cityId;
  String pageIndex;
  String pageSize;

  MainServiceParams({
    required this.pageIndex,
    required this.cityId,
    required this.pageSize,
  });

  MainServiceParams copyWith({
    String? cityId,
    String? pageIndex,
    String? pageSize,
  }) {
    return MainServiceParams(
        pageIndex: pageIndex ?? this.pageIndex,
        cityId: cityId ?? this.cityId,
        pageSize: pageSize ?? this.pageSize);
  }
}
