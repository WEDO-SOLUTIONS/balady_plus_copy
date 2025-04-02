import 'package:mapness/features/saudi_pass/views/offers_screen_view.dart';
import 'package:mapness/features/saudi_pass/views/offers_view.dart';

abstract class FavouriteOffersScreenView implements OffersView {
  @override
  void tapRetryAll();

  @override
  Future<OffersFiltersView> get offersFiltersFuture;

  void tapBack();

  void tapGotoAllOffers();
}
