import 'package:balady_plus/app/features/classification_certificate/data/model/search_request/search_request_model.dart';

class ActivitiesRequestModel implements SearchRequestModel {
  @override
  final int pageNumber;
  @override
  final int pageSize;
  final int sectors;

  ActivitiesRequestModel({
    required this.sectors,
    this.pageSize = 10000,
    this.pageNumber = 1,
  });

  @override
  ActivitiesRequestModel copyWith({
    int? pageSize,
    int? pageNumber,
    int? sectors,
  }) =>
      ActivitiesRequestModel(
        pageSize: pageSize ?? this.pageSize,
        pageNumber: pageSize ?? this.pageNumber,
        sectors: sectors ?? this.sectors,
      );

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {
      "page-size": pageSize,
      "page-number": pageNumber,
    };
    return data;
  }
}
