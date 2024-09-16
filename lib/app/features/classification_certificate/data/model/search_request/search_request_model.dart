abstract class SearchRequestModel {
  final int pageSize;
  final int pageNumber;

  SearchRequestModel({
    required this.pageSize,
    required this.pageNumber,
  });

  SearchRequestModel copyWith({
    int pageSize,
    int pageNumber,
  });

  Map<String, dynamic> toJson();
}
