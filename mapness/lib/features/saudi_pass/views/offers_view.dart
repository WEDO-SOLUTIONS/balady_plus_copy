import 'package:flutter/foundation.dart';
import 'package:mapness/features/saudi_pass/views/offers_screen.dart';

abstract class OffersView implements Listenable {
  void tapRetryAll();

  Future<OffersFiltersView> get offersFiltersFuture;
}
