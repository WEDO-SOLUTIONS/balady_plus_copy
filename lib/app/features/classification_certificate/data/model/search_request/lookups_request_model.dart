import 'package:balady_plus/app/features/classification_certificate/data/model/search_request/search_request_model.dart';

class LookupsRequestModel implements SearchRequestModel {
  @override
  final int pageNumber;
  @override
  final int pageSize;

  LookupsRequestModel({
    this.pageSize = 10000,
    this.pageNumber = 1,
  });

  @override
  LookupsRequestModel copyWith({
    int? pageSize,
    int? pageNumber,
  }) =>
      LookupsRequestModel(
        pageSize: pageSize ?? this.pageSize,
        pageNumber: pageSize ?? this.pageNumber,
      );


  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {
      "size": pageSize,
      "page": pageNumber,
    };
    return data;
  }

}
