import 'package:flutter/widgets.dart';

abstract class CitySelectionDialogView implements Listenable {
  Iterable<SearchView> get searchViews;

  String get search;

  void onSearchInput(String input);
}

abstract class SearchView {
  String get title;

  bool get isMagnifierVisible;

  void onTap(BuildContext context);
}
