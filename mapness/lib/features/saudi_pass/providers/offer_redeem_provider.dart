import 'package:mapness/entities/saudi_pass/offer_feedback.dart';
import 'package:mapness/features/saudi_pass/providers/saudi_pass_repository_riverpod.dart';
import 'package:mapness/features/saudi_pass/repo/offer_location.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'offer_redeem_provider.g.dart';

enum OfferRedeemState { initial, loading, redeemed, error }

@riverpod
class OfferRedeem extends _$OfferRedeem {
  @override
  OfferRedeemState build(String offerId) => OfferRedeemState.initial;

  Future<void> send() async {
    final repository = await ref.read(saudiPassRepositoryProvider.future);
    final position = ref.read(locationProvider);
    if (position == null) {
      return;
    }

    state = OfferRedeemState.loading;
    try {
      await repository.sendFeedback(
        offerId: offerId,
        feedbackModel: OfferFeedback(
          typeId: OfferFeedbackType.redeem,
          location: OfferLocation(latitude: position.latitude.toString(), longitude: position.longitude.toString()),
        ),
      );
      state = OfferRedeemState.redeemed;
    } catch (_) {
      state = OfferRedeemState.error;
    }
  }
}
