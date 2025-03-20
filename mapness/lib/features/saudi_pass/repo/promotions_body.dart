import 'package:json_annotation/json_annotation.dart';

import 'lookups_body.dart';
import 'momra_body.dart';

part 'promotions_body.g.dart';

@noRenameNoToJson
class PromotionsBody extends MomraBody<Promotions, PromotionsData> {
  PromotionsBody({required super.statusDetails, super.data});

  factory PromotionsBody.fromJson(Map<String, dynamic> json) => _$PromotionsBodyFromJson(json);
}

@noRenameNoToJson
class PromotionsData extends Data<Promotions> {
  PromotionsData({
    required super.responseCode,
    required super.responseMessage,
    required super.responseId,
    required super.result,
  });

  factory PromotionsData.fromJson(Map<String, dynamic> json) => _$PromotionsDataFromJson(json);
}

@noRenameNoToJson
class PagingStatus {
  final int totalRecordsCount;
  final int pageSize;
  final int pagesCount;
  final int pageNo;
  final int recordsCount;

  const PagingStatus({
    required this.totalRecordsCount,
    required this.pageSize,
    required this.pagesCount,
    required this.pageNo,
    required this.recordsCount,
  });

  factory PagingStatus.fromJson(Map<String, dynamic> json) => _$PagingStatusFromJson(json);
}

@noRenameNoToJson
class Promotions {
  final PagingStatus pagingStatus;
  @JsonKey(defaultValue: [])
  final Iterable<Offer> records;

  const Promotions({required this.pagingStatus, required this.records});

  factory Promotions.fromJson(Map<String, dynamic> json) => _$PromotionsFromJson(json);
}

@noRenameNoToJson
class Offer {
  final String id;
  final String number;
  final String name;
  final String description;
  @JsonKey(fromJson: OfferType.fromJson)
  final OfferType type;
  @JsonKey(fromJson: OfferProvider.fromJson)
  final OfferProvider provider;
  final Iterable<Category> categories;
  final Iterable<String> images;
  final DateTime publishStartDate;
  final DateTime publishEndDate;
  final DateTime lastUpdateTime;
  final String branchId;
  final String branchName;
  @JsonKey(fromJson: City.fromJson)
  final City city;
  final Location location;
  final String commercialLicenseNumber;
  final String crNumber;
  final bool favorite;
  final bool redeemed;

  Offer({
    required this.id,
    required this.number,
    required this.name,
    required this.description,
    required this.type,
    required this.provider,
    required this.categories,
    required this.images,
    required this.publishStartDate,
    required this.publishEndDate,
    required this.lastUpdateTime,
    required this.branchId,
    required this.branchName,
    required this.city,
    required this.location,
    required this.commercialLicenseNumber,
    required this.crNumber,
    required this.favorite,
    required this.redeemed,
  });

  factory Offer.fromJson(Map<String, dynamic> json) => _$OfferFromJson(json);
}

@noRenameNoToJson
class Location {
  final String latitude;
  final String longitude;

  const Location({required this.latitude, required this.longitude});

  factory Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);
}
