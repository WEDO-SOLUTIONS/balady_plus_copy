import 'package:flutter/foundation.dart';
import 'package:mapness/features/saudi_pass/views/offers_screen_view.dart';

abstract class OffersView implements Listenable {
  void tapRetryAll();

  Future<OffersFiltersView> get offersFiltersFuture;
}
