import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/saudi_pass/notifiers/offers_view_notifier.dart';
import 'package:mapness/features/saudi_pass/views/favourite_offers_screen_view.dart';

class FavouriteOffersScreenViewNotifier extends OffersViewNotifier implements FavouriteOffersScreenView {
  FavouriteOffersScreenViewNotifier({
    required super.saudiPassRepository,
    required super.cityByLocation,
    required super.stackRouter,
  });

  @override
  bool get isFavoritesOnly => true;

  @override
  void tapBack() => stackRouter.popForced();

  @override
  void tapGotoAllOffers() => stackRouter.push(OffersScreenViewRoute());
}
