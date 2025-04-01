import 'package:mapness/features/saudi_pass/views/offers_screen.dart';
import 'package:mapness/features/saudi_pass/views/offers_view.dart';

abstract class FavouriteOffersScreen implements OffersView {
  @override
  void tapRetryAll();

  @override
  Future<OffersFiltersView> get offersFiltersFuture;

  void tapBack();

  void tapGotoAllOffers();
}
