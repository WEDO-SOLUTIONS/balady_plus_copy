import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/saudi_pass/offers_group.dart';
import 'package:mapness/entities/saudi_pass/offers_group_mapper.dart';
import 'package:mapness/features/saudi_pass/notifiers/offers_screen_view_notifier.dart';
import 'package:mapness/features/saudi_pass/repo/lookups_body.dart';
import 'package:mapness/features/saudi_pass/repo/saudi_pass_repository.dart';
import 'package:mapness/features/saudi_pass/views/offers_view.dart';

abstract class OffersViewNotifier extends ChangeNotifier implements OffersView {
  Future<City> cityByLocation;
  final Future<SaudiPassRepository> saudiPassRepository;
  final Ref ref;

  OffersViewNotifier({
    required this.saudiPassRepository,
    required this.cityByLocation,
    required this.ref,
  });

  bool get isFavoritesOnly;

  OffersGroup? get offersGroup => null;

  @override
  late Future<OffersFiltersViewNotifier> offersFiltersFuture = createFiltersAndOffersView();

  @override
  void tapRetryAll() {
    offersFiltersFuture = createFiltersAndOffersView();
    notifyListeners();
  }

  Future<OffersFiltersViewNotifier> createFiltersAndOffersView() async {
    final saudiPassRepository = await this.saudiPassRepository;
    final lookups = await saudiPassRepository.getAllLookups();
    final cityByLocation = await this.cityByLocation;

    return OffersFiltersViewNotifier(
      ref: ref,
      saudiPassRepository: saudiPassRepository,
      defaultCity: cityByLocation,
      lookups: lookups,
      isFavoritesOnly: isFavoritesOnly,
      categoriesSelected: mapPreSelected(lookups.categories).toSet(),
    );
  }

  Iterable<Category> mapPreSelected(Iterable<Category> categories) =>
      categories.where((category) => category.id == offersGroup?.toCategoryId());
}
