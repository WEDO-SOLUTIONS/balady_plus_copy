import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/saudi_pass/notifiers/offers_screen_notifier.dart';
import 'package:mapness/features/saudi_pass/notifiers/offers_view_notifier.dart';
import 'package:mapness/features/saudi_pass/views/favourite_offers_screen.dart';

class FavouriteOffersScreenNotifier extends OffersViewNotifier implements FavouriteOffersScreen {
  FavouriteOffersScreenNotifier({
    required super.saudiPassRepository,
    required super.cityByLocation,
    required super.stackRouter,
    required this.offersScreenNotifier,
  });

  final OffersScreenNotifier offersScreenNotifier;

  @override
  bool get isFavoritesOnly => true;

  @override
  void tapBack() => stackRouter.popForced();

  @override
  void tapGotoAllOffers() => stackRouter.push(OffersScreenRoute(offersScreenNotifier: offersScreenNotifier));
}
