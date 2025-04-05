import 'dart:async';

import 'package:mapness/entities/saudi_pass/offer_feedback.dart';
import 'package:mapness/features/saudi_pass/providers/offer_favorites_provider.dart';
import 'package:mapness/features/saudi_pass/providers/offer_redeem_provider.dart';
import 'package:mapness/features/saudi_pass/providers/saudi_pass_repository_riverpod.dart';
import 'package:mapness/features/saudi_pass/repo/offer_details_body.dart';
import 'package:mapness/features/saudi_pass/repo/offer_location.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'offer_details_provider.g.dart';

const offerDetailsProvider = _offerDetailsProvider;

@riverpod
class _OfferDetails extends _$OfferDetails {
  @override
  Future<OfferDetails> build(String offerId) async {
    ref
      ..listen(
        offerRedeemProvider(offerId),
        (_, next) {
          if (next == OfferRedeemState.redeemed) {
            _updateStateValue(state.value!.copyWith(redeemed: true));
          }
        },
      )
      ..listen(
        offerFavoritesProvider(offerId),
        (_, next) {
          if (next == OfferFavoritesState.added) {
            _updateStateValue(state.value!.copyWith(favorite: true));
          } else if (next == OfferFavoritesState.removed) {
            _updateStateValue(state.value!.copyWith(favorite: false));
          }
        },
      );

    final repository = await ref.read(saudiPassRepositoryProvider.future);
    final offerDetails = await repository.getOfferDetails(offerId: offerId);
    unawaited(_sendOfferView());
    return offerDetails;
  }

  void _updateStateValue(OfferDetails offer) {
    if (state.hasValue) {
      state = AsyncValue.data(offer);
    }
  }

  Future<void> _sendOfferView() async {
    final position = ref.read(locationProvider);
    if (position == null) {
      return;
    }

    final repository = await ref.read(saudiPassRepositoryProvider.future);
    await repository.sendFeedback(
      offerId: offerId,
      feedbackModel: OfferFeedback(
        typeId: OfferFeedbackType.view,
        location: OfferLocation(latitude: position.latitude.toString(), longitude: position.longitude.toString()),
      ),
    );
  }
}
