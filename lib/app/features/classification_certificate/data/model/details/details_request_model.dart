abstract class DetailsRequestModel {
  final int pageSize;
  final int pageNumber;

  DetailsRequestModel({
    required this.pageSize,
    required this.pageNumber,
  });

  DetailsRequestModel copyWith({
    int pageSize,
    int pageNumber,
  });

  Map<String, dynamic> toJson();
}
