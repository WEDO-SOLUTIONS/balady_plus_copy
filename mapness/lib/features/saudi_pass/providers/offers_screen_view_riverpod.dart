import 'package:mapness/app/auto_route/app_routes.dart';
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
      stackRouter: ref.read(appRouterProvider),
      cityByLocation: ref.read(saudiPassCityByLocationProvider.future),
      offersGroup: offersGroup,
    );

    ref.onDispose(notifier.dispose);

    return notifier;
  }
}
