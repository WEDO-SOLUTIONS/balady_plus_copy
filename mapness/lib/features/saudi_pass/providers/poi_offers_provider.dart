import 'package:mapness/features/saudi_pass/providers/saudi_pass_city_by_location_riverpod.dart';
import 'package:mapness/features/saudi_pass/providers/saudi_pass_repository_riverpod.dart';
import 'package:mapness/features/saudi_pass/repo/promotions_body.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'poi_offers_provider.g.dart';

/// Provider class for fetching offers by licenseIds.
/// State is Map, key contains licenseId, value contains offers list for licenseId
@riverpod
class PoiOffers extends _$PoiOffers {
  static const _pageSize = 20;

  @override
  Map<String, List<Offer>> build() => {};

  Future<void> fetchOffers(Set<String> licenseIds) async {
    try {
      final repository = await ref.read(saudiPassRepositoryProvider.future);
      if (!ref.mounted) {
        return;
      }

      final fixedLicenseIds = licenseIds.map((e) => e.trim()).toSet();
      final newIds = fixedLicenseIds.where((e) => !state.containsKey(e)).toSet();
      if (newIds.isEmpty) {
        return;
      }

      final updatedState = Map<String, List<Offer>>.from(state);
      final cityId = await ref.read(saudiPassCityIdByLocationProvider.future);
      if (!ref.mounted) {
        return;
      }

      var pageNumber = 0;
      var pagesCount = 1;
      do {
        final promotions = await repository.getPromotions(
          cityIds: {cityId},
          licenseIds: newIds,
          pageNumber: pageNumber,
          pageSize: _pageSize,
        );
        if (!ref.mounted) {
          return;
        }

        for (final offer in promotions.records) {
          final offerList = updatedState[offer.commercialLicenseNumber] ??= [];
          // ignore: cascade_invocations
          offerList.add(offer);
        }
        pagesCount = promotions.pagingStatus.pagesCount;
        pageNumber++;
      } while (pageNumber < pagesCount);

      state = updatedState;
    } catch (_) {
      // skip, offers updating must not block other functionality
    }
  }
}
