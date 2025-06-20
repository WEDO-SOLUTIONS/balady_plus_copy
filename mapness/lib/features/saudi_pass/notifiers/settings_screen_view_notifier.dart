import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/saudi_pass/notifiers/category_selection_dialog_view_notifier.dart';
import 'package:mapness/features/saudi_pass/notifiers/city_selection_dialog_view_notifier.dart';
import 'package:mapness/features/saudi_pass/notifiers/offers_screen_view_notifier.dart';
import 'package:mapness/features/saudi_pass/notifiers/recommended_type_selection_dialog_view_notifier.dart';
import 'package:mapness/features/saudi_pass/repo/lookups_body.dart';
import 'package:mapness/features/saudi_pass/views/settings_screen_view.dart';

class SettingsScreenViewNotifier extends ChangeNotifier implements SettingsScreenView {
  final OffersFiltersViewNotifier parent;

  SettingsScreenViewNotifier(this.parent);

  late City citySelected = parent.citySelected;
  late final recommendedTypesSelected = Set.of(parent.recommendedTypesSelected);
  late final categoriesSelected = Set.of(parent.categoriesSelected);

  @override
  late final typeSelectionViews = parent.lookups.recommendedTypes.map(
    (it) => RecommendedTypeSelectionView(it, recommendedTypesSelected),
  );

  @override
  late final categorySelectionViews = parent.lookups.categories.map(
    (it) => CategorySelectionView(it, categoriesSelected),
  );

  @override
  void tapBack(BuildContext context) => context.router.popForced();

  @override
  String get cityTitle => citySelected.name;

  @override
  Future<void> tapCity(BuildContext context) async {
    final citySelectionDialog = CitySelectionDialogViewNotifier(parent.lookups.cities);
    final city = await context.router.push<City>(
      CitySelectionDialogViewRoute(citySelectionDialogView: citySelectionDialog),
    );
    if (city != null) {
      citySelected = city;
      notifyListeners();
    }
  }

  @override
  void tapReset() {
    citySelected = parent.defaultCity;
    recommendedTypesSelected.clear();
    categoriesSelected.clear();
    notifyListeners();
  }

  @override
  void tapSave(BuildContext context) {
    parent.applySettings(citySelected, recommendedTypesSelected, categoriesSelected);
    context.router.popForced();
  }
}
