import 'package:flutter/widgets.dart';
import 'package:mapness/features/saudi_pass/views/search_view.dart';

abstract class CitySelectionDialogView implements Listenable {
  Iterable<SearchView> get searchViews;

  String get search;

  void onSearchInput(String input);
}
