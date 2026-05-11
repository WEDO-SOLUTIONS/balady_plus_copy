import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/saudi_pass/offers_group.dart';
import 'package:mapness/entities/saudi_pass/offers_group_mapper.dart';
import 'package:mapness/features/saudi_pass/notifiers/offers_screen_view_notifier.dart';
import 'package:mapness/features/saudi_pass/repo/lookups_body.dart';
import 'package:mapness/features/saudi_pass/repo/saudi_pass_repository.dart';
import 'package:mapness/features/saudi_pass/services/city_resolver/all_offers_city_resolver_provider.dart';
import 'package:mapness/features/saudi_pass/views/offers_view.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';

abstract class OffersViewNotifier extends ChangeNotifier implements OffersView {
  final Future<SaudiPassRepository> saudiPassRepository;
  final Ref ref;

  OffersViewNotifier({
    required this.saudiPassRepository,
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

    // Determine default city per BRD US-02 BR-01 priority chain:
    // `Current Location -> Preference -> Riyadh`. The resolver is the single
    // source of truth; do not reimplement the chain inline here. The user
    // may subsequently override the city via `tapCity()` in the All Offers
    // filter — that override is independent of this default.
    final resolution = await ref.read(allOffersCityResolverProvider.future);
    final defaultCity = resolution.city;

    return OffersFiltersViewNotifier(
      ref: ref,
      saudiPassRepository: saudiPassRepository,
      defaultCity: defaultCity,
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
