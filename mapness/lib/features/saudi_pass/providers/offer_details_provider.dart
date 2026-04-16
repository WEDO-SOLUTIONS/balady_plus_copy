import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapness/entities/saudi_pass/offer_feedback.dart';
import 'package:mapness/features/saudi_pass/providers/offer_favorites_provider.dart';
import 'package:mapness/features/saudi_pass/providers/offer_redeem_provider.dart';
import 'package:mapness/features/saudi_pass/providers/saudi_pass_repository_riverpod.dart';
import 'package:mapness/features/saudi_pass/repo/offer_details_body.dart';
import 'package:mapness/features/saudi_pass/repo/offer_location.dart';
import 'package:mapness/features/saudi_pass/repo/promotions_body.dart';
import 'package:mapness/shared/extensions/double_ext.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'offer_details_provider.g.dart';

final offerDetailsProvider = _offerDetailsProvider;
final currentSelectedOfferProvider = StateProvider<Offer?>((ref) => null);

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

    final repository = await ref.watch(saudiPassRepositoryProvider.future);
    OfferDetails offerDetails;
    try {
      offerDetails = await repository.getOfferDetails(offerId: offerId);
    } catch (e) {
      final selectedTempOffer = ref.read(currentSelectedOfferProvider);
      if (selectedTempOffer != null && selectedTempOffer.id == offerId) {
        final localOffer = selectedTempOffer;
        offerDetails = OfferDetails(
          id: localOffer.id,
          number: localOffer.number,
          name: localOffer.name,
          description: localOffer.description,
          type: localOffer.type,
          provider: localOffer.provider,
          categories: localOffer.categories,
          images: localOffer.images,
          publishStartDate: localOffer.publishStartDate,
          publishEndDate: localOffer.publishEndDate,
          lastUpdateTime: localOffer.lastUpdateTime,
          branchId: localOffer.branchId,
          branchName: localOffer.branchName,
          city: localOffer.city,
          location: localOffer.location,
          commercialLicenseNumber: localOffer.commercialLicenseNumber,
          crNumber: localOffer.crNumber,
          favorite: localOffer.favorite,
          redeemed: localOffer.redeemed,
          typeDetails: localOffer.typeDetails,
          terms: '',
          distance: localOffer.distance,
          briefDurationTo: null,
        );
      } else {
        rethrow;
      }
    }
    final location = ref.refresh(locationProvider);

    final duration = await _getDuration(
      location,
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

  Future<double?> _getDuration(Position? location, double lat, double lon) async {
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

final offerDistanceProvider = FutureProvider.autoDispose.family<double?, String>((ref, coords) async {
  final parts = coords.split(',');
  final lat = double.tryParse(parts[0]) ?? 0.0;
  final lon = double.tryParse(parts[1]) ?? 0.0;
  
  final location = ref.refresh(locationProvider);
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
    if (location == null) {
      return null;
    }
    return CommonFunctions.distance(
      location.latitude,
      location.longitude,
      lat,
      lon,
    );
  }
});
