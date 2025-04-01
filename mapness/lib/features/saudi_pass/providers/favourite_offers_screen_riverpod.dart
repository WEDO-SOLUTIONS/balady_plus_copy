import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/features/saudi_pass/notifiers/favourite_offers_screen_notifier.dart';
import 'package:mapness/features/saudi_pass/providers/offers_screen_riverpod.dart';
import 'package:mapness/features/saudi_pass/providers/saudi_pass_city_by_location_riverpod.dart';
import 'package:mapness/features/saudi_pass/providers/saudi_pass_repository_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favourite_offers_screen_riverpod.g.dart';

@riverpod
class FavouriteOffersScreenRiverpod extends _$FavouriteOffersScreenRiverpod {
  @override
  FavouriteOffersScreenNotifier build() {
    final futureRepo = ref.read(saudiPassRepositoryProvider.future);

    final notifier = FavouriteOffersScreenNotifier(
      saudiPassRepository: futureRepo,
      stackRouter: ref.read(appRouterProvider),
      cityByLocation: ref.read(saudiPassCityByLocationProvider.future),
      offersScreenNotifier: ref.watch(offersScreenRiverpodProvider()),
    );

    ref.onDispose(notifier.dispose);

    return notifier;
  }
}
