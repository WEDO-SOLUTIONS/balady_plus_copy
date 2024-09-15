import 'package:balady_plus/app/features/classification_certificate/data/model/search_request/search_request_model.dart';

class NormalSearchRequestModel implements SearchRequestModel {
  final String searchQuery;
  @override
  final int pageNumber;
  @override
  final int pageSize;

  NormalSearchRequestModel({
    required this.searchQuery,
    required this.pageSize,
    required this.pageNumber,
  });

  @override
  NormalSearchRequestModel copyWith({
    String? searchQuery,
    int? pageSize,
    int? pageNumber,
  }) =>
      NormalSearchRequestModel(
        searchQuery: searchQuery ?? this.searchQuery,
        pageSize: pageSize ?? this.pageSize,
        pageNumber: pageSize ?? this.pageNumber,
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

class CertificateNumberSearchRequestModel extends NormalSearchRequestModel {
  CertificateNumberSearchRequestModel({
    required super.searchQuery,
    required super.pageSize,
    required super.pageNumber,
  });
  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = super.toJson();
    data['Serial_number'] = super.searchQuery;
    return data;
  }
}

class FacilityNameSearchRequestModel
    extends NormalSearchRequestModel {
  FacilityNameSearchRequestModel({
    required super.searchQuery,
    required super.pageSize,
    required super.pageNumber,
  });

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = super.toJson();
    data['facility-name'] = super.searchQuery;
    return data;
  }
}

class CRLICNumberSearchRequestModel extends NormalSearchRequestModel {
  CRLICNumberSearchRequestModel({
    required super.searchQuery,
    required super.pageSize,
    required super.pageNumber,
  });

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = super.toJson();
    data['cr-lic-num'] = super.searchQuery;
    return data;
  }
}

class EstablishmentIdSearchRequestModel extends NormalSearchRequestModel {
  EstablishmentIdSearchRequestModel({
    required super.searchQuery,
    required super.pageSize,
    required super.pageNumber,
  });
  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = super.toJson();
    data['establishment-id'] = super.searchQuery;
    return data;
  }
}
