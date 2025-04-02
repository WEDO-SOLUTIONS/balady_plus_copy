import 'package:flutter/foundation.dart';

abstract class CitySelectionDialogView implements Listenable {
  Iterable<SearchView> get searchViews;

  String get search;

  void onSearchInput(String input);

  void onCrossTap();
}

abstract class SearchView {
  String get title;

  bool get isMagnifierVisible;

  void onTap();
}
