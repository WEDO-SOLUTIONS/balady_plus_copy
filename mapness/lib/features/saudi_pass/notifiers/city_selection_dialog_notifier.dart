import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:mapness/features/saudi_pass/repo/lookups_body.dart';
import 'package:mapness/features/saudi_pass/views/city_selection_dialog.dart';

class CitySelectionDialogNotifier extends ChangeNotifier implements CitySelectionDialog {
  final Iterable<City> cities;
  final StackRouter stackRouter;

  CitySelectionDialogNotifier(this.cities, this.stackRouter);

  @override
  void onCrossTap() => stackRouter.popForced();

  void onCityTap(City city) => stackRouter.popForced(city);

  late final Iterable<SearchView> _all = cities.map((city) => CitySearchView(city, this));

  @override
  late Iterable<SearchView> searchViews = _all;

  @override
  String search = '';

  @override
  void onSearchInput(String input) {
    search = input;

    searchViews = _all.where((it) => it.isMagnifierVisible);

    if (searchViews.isEmpty) {
      searchViews = _all;
    }

    notifyListeners();
  }
}

class CitySearchView implements SearchView {
  final CitySelectionDialogNotifier parent;
  final City city;

  CitySearchView(this.city, this.parent);

  @override
  String get title => city.name;

  @override
  bool get isMagnifierVisible =>
      parent.search.isNotEmpty && city.name.toLowerCase().contains(parent.search.toLowerCase());

  @override
  void onTap() => parent.onCityTap(city);
}
