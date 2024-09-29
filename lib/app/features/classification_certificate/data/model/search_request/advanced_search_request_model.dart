import 'package:balady_plus/app/features/classification_certificate/data/model/search_request/search_request_model.dart';
import 'package:intl/intl.dart';

import '../lookups/activity_lookups_model.dart';
import '../lookups/city_lookups_model.dart';
import '../lookups/classification_certificate_lookup_model.dart';

class AdvancedSearchRequestModel implements SearchRequestModel {
  @override
  final int pageNumber;
  @override
  final int pageSize;

  //////////////////////// Required Field //////////////////////////
  ClassificationCertificateLookupModel? classificationType;
  ClassificationCertificateLookupModel? sector;
  CityLookupsModel? city;

  //////////////////////////////////////////////////
  ActivityLookupsModel? activity;
  ClassificationCertificateLookupModel? classificationGrade;
  DateTime? expiryDateFrom;
  DateTime? expiryDateTo;
  String? phoneNumber;
  ClassificationCertificateLookupModel? service;

  AdvancedSearchRequestModel({
    this.pageSize = 10,
    this.pageNumber = 1,
    ////////////////////////////////////////////////////
    this.classificationType,
    this.sector,
    this.city,
    ////////////////////////////////////////////////////
    this.activity,
    this.classificationGrade,
    this.expiryDateFrom,
    this.expiryDateTo,
    this.phoneNumber,
    this.service,
  });

  @override
  AdvancedSearchRequestModel copyWith({
    int? pageSize,
    int? pageNumber,
    ////////////////////////////////////////////////////
    ClassificationCertificateLookupModel? classificationType,
    ClassificationCertificateLookupModel? sector,
    CityLookupsModel? city,
    ////////////////////////////////////////////////////
    ActivityLookupsModel? activity,
    ClassificationCertificateLookupModel? classificationGrade,
    DateTime? expiryDateFrom,
    DateTime? expiryDateTo,
    String? phoneNumber,
    ClassificationCertificateLookupModel? service,
    ////////////////////////////////////////////////////
    bool deleteSector = false,
    bool deleteActivity = false,
    bool deleteService = false,
  }) =>
      AdvancedSearchRequestModel(
        pageSize: pageSize ?? this.pageSize,
        pageNumber: pageSize ?? this.pageNumber,
        ////////////////////////////////////////////////////
        classificationType: classificationType ?? this.classificationType,
        sector: deleteSector ? null : sector ?? this.sector,
        city: city ?? this.city,
        ////////////////////////////////////////////////////
        activity: deleteActivity ? null : activity ?? this.activity,
        classificationGrade: classificationGrade ?? this.classificationGrade,
        expiryDateFrom: expiryDateFrom ?? this.expiryDateFrom,
        expiryDateTo: expiryDateTo ?? this.expiryDateTo,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        service: deleteService ? null :  service ?? this.service,
      );

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {
      "page-size": pageSize,
      "page-number": pageNumber,
    };
    //////////////////////////////////////////////////
    if (classificationType != null) {
      data['classification-type'] = classificationType!.code;
    }
    if (sector != null) {
      data['classification-domain'] = sector!.code;
    }
    if (city != null) {
      data['city'] = city!.cityCode;
    }
    //////////////////////////////////////////////////
    if (activity != null) {
      data['activity-id'] = activity!.activityValue;
    }
    if (classificationGrade != null) {
      data['classification-grade'] = classificationGrade!.code;
    }
    if (expiryDateFrom != null) {
      data['expiry-date-from'] = DateFormat(
        'yyyyMMdd',
        "en",
      ).format(expiryDateFrom!);
    }
    if (expiryDateTo != null) {
      data['expiry-date-to'] = DateFormat(
        'yyyyMMdd',
        "en",
      ).format(expiryDateTo!);
    }
    if (phoneNumber != null) {
      data['phone-number'] = phoneNumber;
    }
    if (service != null) {
      data['service-id'] = service!.code;
    }
    return data;
  }
}
