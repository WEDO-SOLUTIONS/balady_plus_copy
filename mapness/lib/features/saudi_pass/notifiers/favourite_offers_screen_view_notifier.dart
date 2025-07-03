import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/saudi_pass/notifiers/offers_view_notifier.dart';
import 'package:mapness/features/saudi_pass/views/favourite_offers_screen_view.dart';

class FavouriteOffersScreenViewNotifier extends OffersViewNotifier implements FavouriteOffersScreenView {
  FavouriteOffersScreenViewNotifier({
    required super.saudiPassRepository,
    required super.cityIdByLocation,
    required super.ref,
  });

  @override
  bool get isFavoritesOnly => true;

  @override
  void tapBack(BuildContext context) => context.router.popForced();

  @override
  Future<T?> tapGotoAllOffers<T>(BuildContext context) async => context.router.push(OffersScreenViewRoute());
}
