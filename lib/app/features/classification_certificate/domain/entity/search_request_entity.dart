abstract class SearchRequestEntity {
  int pageSize;
  int pageNumber;

  SearchRequestEntity({required this.pageSize, required this.pageNumber});

  SearchRequestEntity copyWith({
    int pageSize,
    int pageNumber,
  });

  Map<String, dynamic> toJson();
}
