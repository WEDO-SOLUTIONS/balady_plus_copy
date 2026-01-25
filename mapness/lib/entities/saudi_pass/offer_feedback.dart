import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mapness/features/saudi_pass/repo/offer_location.dart';

part 'offer_feedback.freezed.dart';

part 'offer_feedback.g.dart';

enum OfferFeedbackType { rate, note, redeem, view, favorite }

@freezed
abstract class OfferFeedback with _$OfferFeedback {
  factory OfferFeedback({
    required final OfferFeedbackType typeId,
    required final OfferLocation location,
    final String? value,
  }) = _OfferFeedback;

  factory OfferFeedback.fromJson(Map<String, dynamic> json) => _$OfferFeedbackFromJson(json);
}
