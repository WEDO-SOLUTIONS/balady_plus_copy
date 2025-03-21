import 'package:json_annotation/json_annotation.dart';
import 'package:mapness/features/saudi_pass/repo/lookups_body.dart';
import 'package:mapness/features/saudi_pass/repo/momra_body.dart';
import 'package:mapness/features/saudi_pass/repo/promotions_body.dart';

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

/// Promotion Type Details (Can be coupon or vouchers) [OfferType.id]
@noRenameNoToJson
class TypeDetails {
  /// Promotion Amount (Vouchers)
  final num? amount;

  /// Promotion Number (Vouchers)
  final String? number;

  /// Promotion discount ratio (Coupon)
  final num? ratio;

  /// Promotion max discount ratio (Coupon)
  final num? maxRatio;

  /// Promotion discount code (Coupon)
  final String? code;

  TypeDetails({
    this.amount,
    this.number,
    this.ratio,
    this.maxRatio,
    this.code,
  });

  factory TypeDetails.fromJson(Map<String, dynamic> json) => _$TypeDetailsFromJson(json);
}
