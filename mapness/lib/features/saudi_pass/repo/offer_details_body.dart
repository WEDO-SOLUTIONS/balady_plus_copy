import 'package:json_annotation/json_annotation.dart';

import 'lookups_body.dart';
import 'momra_body.dart';
import 'promotions_body.dart';

part 'offer_details_body.g.dart';

@noRenameNoToJson
class OfferDetailsBody extends MomraBody<OfferDetails, OfferDetailsData> {
  OfferDetailsBody({required super.statusDetails, super.data});

  factory OfferDetailsBody.fromJson(Map<String, dynamic> json) => _$OfferDetailsBodyFromJson(json);
}

@noRenameNoToJson
class OfferDetailsData extends Data<OfferDetails> {
  OfferDetailsData({
    required super.responseCode,
    required super.responseMessage,
    required super.responseId,
    required super.result,
  });

  factory OfferDetailsData.fromJson(Map<String, dynamic> json) => _$OfferDetailsDataFromJson(json);
}

@noRenameNoToJson
class OfferDetails extends Offer {
  final TypeDetails typeDetails;
  final String terms;

  OfferDetails({
    required super.id,
    required super.number,
    required super.name,
    required super.description,
    required super.type,
    required super.provider,
    required super.categories,
    required super.images,
    required super.publishStartDate,
    required super.publishEndDate,
    required super.lastUpdateTime,
    required super.branchId,
    required super.branchName,
    required super.city,
    required super.location,
    required super.commercialLicenseNumber,
    required super.crNumber,
    required super.favorite,
    required super.redeemed,
    required this.typeDetails,
    required this.terms,
  });

  factory OfferDetails.fromJson(Map<String, dynamic> json) => _$OfferDetailsFromJson(json);
}

@noRenameNoToJson
class TypeDetails {
  final int ratio;
  final String code;

  TypeDetails({required this.ratio, required this.code});

  factory TypeDetails.fromJson(Map<String, dynamic> json) => _$TypeDetailsFromJson(json);
}
