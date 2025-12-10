import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/saudi_pass/offers_group.dart';
import 'package:mapness/entities/saudi_pass/offers_group_mapper.dart';
import 'package:mapness/features/saudi_pass/notifiers/offers_screen_view_notifier.dart';
import 'package:mapness/features/saudi_pass/repo/lookups_body.dart';
import 'package:mapness/features/saudi_pass/repo/saudi_pass_repository.dart';
import 'package:mapness/features/saudi_pass/views/offers_view.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';

abstract class OffersViewNotifier extends ChangeNotifier implements OffersView {
  Future<String> cityIdByLocation;
  final Future<SaudiPassRepository> saudiPassRepository;
  final Ref ref;

  OffersViewNotifier({
    required this.saudiPassRepository,
    required this.cityIdByLocation,
    required this.ref,
  });

  bool get isFavoritesOnly;

  OffersGroup? get offersGroup => null;

  @override
  late Future<OffersFiltersViewNotifier> offersFiltersFuture =
      createFiltersAndOffersView();

  @override
  void tapRetryAll() {
    offersFiltersFuture = createFiltersAndOffersView();
    notifyListeners();
  }

  late Future<Lookups> futureLookups =
      saudiPassRepository.then((it) => it.getAllLookups());

  Future<Iterable<SubCategory>> getSubcategories(String categoryId) =>
      saudiPassRepository
          .then((it) => it.getSubcategories(categoryId: categoryId));

  Future<City> cityByLocation() async {
    final lookups = await futureLookups;
    final cityIdByLocation = await this.cityIdByLocation;
    return lookups.cities
            .where((city) => city.id == cityIdByLocation)
            .firstOrNull ??
        lookups.cities.first;
  }

  Future<OffersFiltersViewNotifier> createFiltersAndOffersView() async {
    final saudiPassRepository = await this.saudiPassRepository;
    final lookups = await futureLookups;
    final controller = await ref.read(dgisControllerProvider.future);
    final cameraPosition = await controller.getCameraPosition();

    final subcategoriesFutures = lookups.categories.map((category) async {
      final subs = await getSubcategories(category.id);
      return subs
          .map((sub) =>
              SubCategory(id: sub.id, name: sub.name, categoryId: category.id))
          .toList();
    }).toList();

    final results = await Future.wait(subcategoriesFutures);

    final subcategories = results.expand((it) => it).toList();

    return OffersFiltersViewNotifier(
      ref: ref,
      saudiPassRepository: saudiPassRepository,
      defaultCity: await cityByLocation(),
      lookups: lookups,
      isFavoritesOnly: isFavoritesOnly,
      subCategoriesSelected: mapPreSelected(subcategories).toSet(),
      allSubCategories: subcategories,
      point: cameraPosition.point,
    );
  }

  Iterable<SubCategory> mapPreSelected(Iterable<SubCategory> subCategories) =>
      subCategories.where((subCategory) =>
          subCategory.categoryId == offersGroup?.toCategoryId());
}
