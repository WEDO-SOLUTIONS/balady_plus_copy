import 'package:balady_plus/app/features/classification_certificate/data/model/search_request/search_request_model.dart';

class AdvancedSearchRequestModel implements SearchRequestModel {
  @override
  final int pageNumber;
  @override
  final int pageSize;

  AdvancedSearchRequestModel({
    this.pageSize = 10,
    this.pageNumber = 1,
  });

  @override
  AdvancedSearchRequestModel copyWith({
    int? pageSize,
    int? pageNumber,
  }) =>
      AdvancedSearchRequestModel(
        pageSize: pageSize ?? this.pageSize,
        pageNumber: pageSize ?? this.pageNumber,
      );


  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {
      "page-size": pageSize,
      "page-number": pageNumber,
    };
    data[''] = "";
    data[''] = "";
    data[''] = "";
    data[''] = "";

    return data;
  }

}
