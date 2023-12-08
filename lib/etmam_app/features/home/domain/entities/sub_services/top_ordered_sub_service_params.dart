class TopOrderedSubServiceParams {
  String cityId;
  String? pageSize;
  String? pageIndex;
  TopOrderedSubServiceParams(
      {required this.pageIndex, required this.cityId, required this.pageSize});

  TopOrderedSubServiceParams copyWith({
    String? cityId,
    String? pageSize,
    String? pageIndex,
  }) {
    return TopOrderedSubServiceParams(
        pageSize: pageSize ?? this.pageSize,
        cityId: cityId ?? this.cityId,
        pageIndex: pageIndex ?? this.pageIndex);
  }
}
