import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/features/saudi_pass/repo/lookups_body.dart';
import 'package:mapness/features/saudi_pass/views/city_selection_dialog_view.dart';
import 'package:mapness/features/saudi_pass/views/search_view.dart';

class CitySelectionDialogViewNotifier extends ChangeNotifier
    implements CitySelectionDialogView {
  final Iterable<City> cities;

  CitySelectionDialogViewNotifier(this.cities);

  void onCityTap(City city, BuildContext context) =>
      context.router.popForced(city);

  late final Iterable<SearchView> _all =
      cities.map((city) => CitySearchView(city, this)).toList();

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
  final CitySelectionDialogViewNotifier parent;
  final City city;

  CitySearchView(this.city, this.parent);

  @override
  String get title => city.name;

  @override
  bool get isMagnifierVisible =>
      parent.search.isNotEmpty &&
      city.name.toLowerCase().contains(parent.search.toLowerCase());

  @override
  void onTap(BuildContext context) => parent.onCityTap(city, context);
}
