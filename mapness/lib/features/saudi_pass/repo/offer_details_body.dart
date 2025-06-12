import 'package:json_annotation/json_annotation.dart';
import 'package:mapness/features/saudi_pass/repo/lookups_body.dart';
import 'package:mapness/features/saudi_pass/repo/momra_body.dart';
import 'package:mapness/features/saudi_pass/repo/offer_location.dart';
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
  @JsonKey(defaultValue: '')
  final String terms;

  final double? briefDurationTo;

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
    required super.typeDetails,
    required this.terms,
    required this.briefDurationTo,
  });

  OfferDetails copyWith({
    String? id,
    String? number,
    String? name,
    String? description,
    OfferType? type,
    OfferProvider? provider,
    Iterable<Category>? categories,
    Iterable<String>? images,
    DateTime? publishStartDate,
    DateTime? publishEndDate,
    DateTime? lastUpdateTime,
    String? branchId,
    String? branchName,
    City? city,
    OfferLocation? location,
    String? commercialLicenseNumber,
    String? crNumber,
    bool? favorite,
    bool? redeemed,
    TypeDetails? typeDetails,
    String? terms,
    double? briefDurationTo,
  }) =>
      OfferDetails(
        id: id ?? this.id,
        number: number ?? this.number,
        name: name ?? this.name,
        description: description ?? this.description,
        type: type ?? this.type,
        provider: provider ?? this.provider,
        categories: categories ?? this.categories,
        images: images ?? this.images,
        publishStartDate: publishStartDate ?? this.publishStartDate,
        publishEndDate: publishEndDate ?? this.publishEndDate,
        lastUpdateTime: lastUpdateTime ?? this.lastUpdateTime,
        branchId: branchId ?? this.branchId,
        branchName: branchName ?? this.branchName,
        city: city ?? this.city,
        location: location ?? this.location,
        commercialLicenseNumber: commercialLicenseNumber ?? this.commercialLicenseNumber,
        crNumber: crNumber ?? this.crNumber,
        favorite: favorite ?? this.favorite,
        redeemed: redeemed ?? this.redeemed,
        typeDetails: typeDetails ?? this.typeDetails,
        terms: terms ?? this.terms,
        briefDurationTo: briefDurationTo ?? this.briefDurationTo,
      );

  factory OfferDetails.fromJson(Map<String, dynamic> json) => _$OfferDetailsFromJson(json);
}
