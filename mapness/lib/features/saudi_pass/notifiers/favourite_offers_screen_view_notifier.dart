import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/saudi_pass/notifiers/offers_view_notifier.dart';
import 'package:mapness/features/saudi_pass/views/favourite_offers_screen_view.dart';

class FavouriteOffersScreenViewNotifier extends OffersViewNotifier implements FavouriteOffersScreenView {
  FavouriteOffersScreenViewNotifier({
    required super.saudiPassRepository,
    required super.cityByLocation,
    required super.ref,
  });

  @override
  bool get isFavoritesOnly => true;

  @override
  void tapBack() => ref.read(appRouterProvider).popForced();

  @override
  void tapGotoAllOffers() => ref.read(appRouterProvider).push(OffersScreenViewRoute());
}
