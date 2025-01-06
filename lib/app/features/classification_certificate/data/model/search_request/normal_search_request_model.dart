import 'package:balady_plus/app/features/classification_certificate/data/model/search_request/search_request_model.dart';

class NormalSearchRequestModel implements SearchRequestModel {
  String searchQuery;
  @override
  final int pageNumber;
  @override
  final int pageSize;

  NormalSearchRequestModel({
    required this.searchQuery,
    this.pageSize = 10,
    this.pageNumber = 1,
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
    super.pageSize,
    super.pageNumber,
  });

  @override
  CertificateNumberSearchRequestModel copyWith({
    String? searchQuery,
    int? pageSize,
    int? pageNumber,
  }) =>
      CertificateNumberSearchRequestModel(
        searchQuery: searchQuery ?? this.searchQuery,
        pageSize: pageSize ?? this.pageSize,
        pageNumber: pageSize ?? this.pageNumber,
      );

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = super.toJson();
    data['serial-number'] = super.searchQuery;
    return data;
  }
}

class FacilityNameSearchRequestModel extends NormalSearchRequestModel {
  FacilityNameSearchRequestModel({
    required super.searchQuery,
    super.pageSize,
    super.pageNumber,
  });

  @override
  FacilityNameSearchRequestModel copyWith({
    String? searchQuery,
    int? pageSize,
    int? pageNumber,
  }) =>
      FacilityNameSearchRequestModel(
        searchQuery: searchQuery ?? this.searchQuery,
        pageSize: pageSize ?? this.pageSize,
        pageNumber: pageSize ?? this.pageNumber,
      );

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
    super.pageSize,
    super.pageNumber,
  });

  @override
  CRLICNumberSearchRequestModel copyWith({
    String? searchQuery,
    int? pageSize,
    int? pageNumber,
  }) =>
      CRLICNumberSearchRequestModel(
        searchQuery: searchQuery ?? this.searchQuery,
        pageSize: pageSize ?? this.pageSize,
        pageNumber: pageSize ?? this.pageNumber,
      );

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
    super.pageSize,
    super.pageNumber,
  });

  @override
  EstablishmentIdSearchRequestModel copyWith({
    String? searchQuery,
    int? pageSize,
    int? pageNumber,
  }) =>
      EstablishmentIdSearchRequestModel(
        searchQuery: searchQuery ?? this.searchQuery,
        pageSize: pageSize ?? this.pageSize,
        pageNumber: pageSize ?? this.pageNumber,
      );

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = super.toJson();
    data['establishment-id'] = super.searchQuery;
    return data;
  }
}
