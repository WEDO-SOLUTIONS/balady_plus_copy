import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:mapness/entities/saudi_pass/offer_feedback.dart';
import 'package:mapness/features/saudi_pass/providers/offer_favorites_provider.dart';
import 'package:mapness/features/saudi_pass/providers/offer_redeem_provider.dart';
import 'package:mapness/features/saudi_pass/providers/saudi_pass_repository_riverpod.dart';
import 'package:mapness/features/saudi_pass/repo/offer_details_body.dart';
import 'package:mapness/features/saudi_pass/repo/offer_location.dart';
import 'package:mapness/shared/extensions/double_ext.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
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

    final duration = await _getDuration(
      double.tryParse(offerDetails.location.latitude) ?? 0.0,
      double.tryParse(offerDetails.location.longitude) ?? 0.0,
    );

    unawaited(_sendOfferView());

    return offerDetails.copyWith(briefDurationTo: duration);
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

  Future<double?> _getDuration(double lat, double lon) async {
    try {
      final controller = await ref.read(dgisControllerProvider.future);
      final duration = await controller.findBriefRouteInfos(
        options: RouteSearchOptionsMessage.car,
        finishPoint: RouteSearchPointMessage(
            coordinates: GeoPointMessage(
              latitude: lat,
              longitude: lon,
            ),
            objectId: DgisObjectIdMessage(
              objectId: 0,
              entranceId: 0,
            )),
      );
      return duration.firstOrNull?.extraInfo.distance.toDouble().toKilometers();
    } catch (_) {
      final location = ref.read(locationProvider);
      if (location == null) {
        return null;
      }
      final distance = CommonFunctions.distance(
        location.latitude,
        location.longitude,
        lat,
        lon,
      );

      return distance;
    }
  }
}
