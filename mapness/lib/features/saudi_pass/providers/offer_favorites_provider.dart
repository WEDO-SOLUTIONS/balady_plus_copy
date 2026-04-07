import 'package:mapness/entities/saudi_pass/offer_feedback.dart';
import 'package:mapness/features/saudi_pass/providers/saudi_pass_repository_riverpod.dart';
import 'package:mapness/features/saudi_pass/repo/offer_location.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'offer_favorites_provider.g.dart';

enum OfferFavoritesState { initial, loading, added, removed, error }

@riverpod
class OfferFavorites extends _$OfferFavorites {
  @override
  OfferFavoritesState build(String offerId) => OfferFavoritesState.initial;

  void syncState({required bool isFavorite}) {
    if (!ref.mounted) {
      return;
    }
    state = switch (isFavorite) {
      true => OfferFavoritesState.added,
      false => OfferFavoritesState.removed,
    };
  }

  Future<void> addToFavorites() async {
    await _sendRequest(favorite: true);
  }

  Future<void> removeFromFavorites() async {
    await _sendRequest(favorite: false);
  }

  Future<void> _sendRequest({required bool favorite}) async {
    if (!ref.mounted) {
      return;
    }
    final repository = await ref.read(saudiPassRepositoryProvider.future);
    final position = ref.read(locationProvider);
    if (position == null) {
      state = OfferFavoritesState.error;
      return;
    }

    state = OfferFavoritesState.loading;
    try {
      await repository.sendFeedback(
        offerId: offerId,
        feedbackModel: OfferFeedback(
          typeId: OfferFeedbackType.favorite,
          value: favorite.toString(),
          location: OfferLocation(latitude: position.latitude.toString(), longitude: position.longitude.toString()),
        ),
      );
      if (!ref.mounted) {
        return;
      }
      state = favorite ? OfferFavoritesState.added : OfferFavoritesState.removed;
    } catch (_) {
      if (!ref.mounted) {
        return;
      }
      state = OfferFavoritesState.error;
    }
  }
}