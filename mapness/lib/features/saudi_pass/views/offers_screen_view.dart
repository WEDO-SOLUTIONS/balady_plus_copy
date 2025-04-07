import 'package:flutter/foundation.dart';
import 'package:mapness/entities/saudi_pass/offers_group.dart';
import 'package:mapness/features/saudi_pass/async_iterable/async_iterable.dart';
import 'package:mapness/features/saudi_pass/views/offers_view.dart';

abstract class OffersScreenView implements OffersView {
  void tapBack();

  bool get isByPreferencesElseAll;

  void tapByPreferences();

  void tapAll();

  void tapRetryPrefs();

  Future<PrefsOffersView> get prefsOffersViewFuture;
}

abstract class PrefsOffersView implements Listenable {
  bool get isSetPreferencesOrOffersVisible;

  String get cityTitle;

  int get types;

  int get categories;

  void tapIconEdit();

  void tapGotoPreferences();

  AsyncIterable<OfferView> get asyncIterableOffers;
}

abstract class OffersFiltersView implements Listenable {
  void tapSort();

  void tapSettings();

  void tapCity();

  void tapType();

  void tapCategory();

  bool get isSortHighlighted;

  bool get isSettingsHighlighted;

  FilterView get cityFilterView;

  FilterView get typeFilterView;

  FilterView get categoryFilterView;

  AsyncIterable<OfferView> get asyncIterableOffers;
}

typedef FilterView = ({String? title, String? plusMore, bool isHighlighted, void Function()? tapCross});

abstract class OfferView implements Listenable {
  String get offerId;

  String get title;

  num? get ratio;

  num? get amount;

  String get subTitle;

  DateTime get byDate;

  bool get isHeartRedAndFilled;

  bool get isByDateRed;

  ({String url, Map<String, String> headers}) get logo;

  OffersGroup get offersGroup;

  void onTap();

  void onHeartTap();
}
