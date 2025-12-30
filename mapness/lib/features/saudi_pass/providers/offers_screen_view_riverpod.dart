import 'package:mapness/entities/saudi_pass/offers_group.dart';
import 'package:mapness/features/saudi_pass/notifiers/offers_screen_view_notifier.dart';
import 'package:mapness/features/saudi_pass/providers/saudi_pass_city_by_location_riverpod.dart';
import 'package:mapness/features/saudi_pass/providers/saudi_pass_repository_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'offers_screen_view_riverpod.g.dart';

@riverpod
class OffersScreenViewRiverpod extends _$OffersScreenViewRiverpod {
  @override
  OffersScreenViewNotifier build({OffersGroup? offersGroup}) {
    final notifier = OffersScreenViewNotifier(
      saudiPassRepository: ref.read(saudiPassRepositoryProvider.future),
      ref: ref,
      cityIdByLocation: ref.read(saudiPassCityIdByLocationProvider.future),
      offersGroup: offersGroup,
    );

    // Initialize tab state based on user preferences
    // This will check if user has preferences and set the appropriate tab
    notifier.initializeTabState();

    ref.onDispose(notifier.dispose);

    return notifier;
  }
}
