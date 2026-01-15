import 'package:freezed_annotation/freezed_annotation.dart';

part 'offer_location.freezed.dart';
part 'offer_location.g.dart';

@freezed
class OfferLocation with _$OfferLocation {
  factory OfferLocation({
    required final String latitude,
    required final String longitude,
  }) = _OfferLocation;

  factory OfferLocation.fromJson(Map<String, dynamic> json) => _$OfferLocationFromJson(json);
}
