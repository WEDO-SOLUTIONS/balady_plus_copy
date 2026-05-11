import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/entities/saudi_pass/offers_group.dart';
import 'package:mapness/features/saudi_pass/async_iterable/async_iterable.dart';
import 'package:mapness/features/saudi_pass/repo/lookups_body.dart' as lookups_body;
import 'package:mapness/features/saudi_pass/views/offers_view.dart';

abstract class OffersScreenView implements OffersView {
  void tapBack();

  bool get isByPreferencesElseAll;

  void tapByPreferences();

  void tapAll();

  void tapRetryPrefs();

  Future<PrefsOffersView> get prefsOffersViewFuture;

  /// Snapshot of the active list's filtering / preference context, used by
  /// the Offers Map to render the same offer set (BRD US-03 BR-02). The
  /// snapshot resolves the currently active tab (By Preference vs All Offers)
  /// at the moment of access.
  Future<OffersMapContext> get activeMapContext;
}

/// Filtering / preference context used by the Offers Map.
///
/// Built by the originating list (By Preference or All Offers) and passed
/// to the Map provider so the map reflects exactly the same offer set as
/// the list it was launched from (BRD US-03 BR-02). The Map provider must
/// NOT re-derive these by calling `getPreferences()` internally.
class OffersMapContext {
  final Set<String> cityIds;
  final Set<lookups_body.Category> categories;
  final Set<lookups_body.SubCategory> subCategories;
  final Set<lookups_body.RecommendedType> recommendedTypes;

  /// Human-readable city label for the Map's top bar. For single-city
  /// contexts this is the city name; for multi-city (By Preference with
  /// multiple cities) this is the first city's name, matching the existing
  /// `PrefsOffersView.cityTitle` convention. Purely cosmetic — filter
  /// behavior is driven by [cityIds].
  final String cityTitle;

  const OffersMapContext({
    required this.cityIds,
    required this.cityTitle,
    this.categories = const {},
    this.subCategories = const {},
    this.recommendedTypes = const {},
  });
}

abstract class PrefsOffersView implements Listenable {
  bool get isSetPreferencesOrOffersVisible;

  String get cityTitle;

  int get types;

  int get categories;

  void tapIconEdit();

  void tapGotoPreferences();

  AsyncIterable<OfferView> get asyncIterableOffers;

  /// Snapshot of the active By Preference filtering context (preferences +
  /// resolved city) for the Offers Map. See [OffersMapContext].
  OffersMapContext get mapContext;
}

abstract class OffersFiltersView implements Listenable {
  void tapSort();

  void tapSettings();

  void tapCity();

  void tapType();

  void tapShowAllCategories();

  void reset();

  bool get isSortHighlighted;

  bool get isSettingsHighlighted;

  FilterView get cityFilterView;

  FilterView get typeFilterView;

  FilterView get categoryFilterView;

  AsyncIterable<OfferView> get asyncIterableOffers;

  Set<lookups_body.SubCategory> get subCategories;

  Set<lookups_body.Category> get categories;

  lookups_body.City get city;

  Set<lookups_body.RecommendedType> get recommendedTypes;

  /// Snapshot of the active All Offers filtering context (single selected
  /// city + manual filter selections) for the Offers Map. See
  /// [OffersMapContext].
  OffersMapContext get mapContext;
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

  String get branchName;

  String? get distance;

  ({String url, Map<String, String> headers}) get logo;

  OffersGroup get offersGroup;

  void onTap();

  void onHeartTap();
}
