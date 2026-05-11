part of 'offers_screen_view_notifier.dart';

class OffersFiltersViewNotifier extends ChangeNotifier implements OffersFiltersView {
  City defaultCity;
  final Ref ref;

  StackRouter get stackRouter => ref.read(appRouterProvider);
  final SaudiPassRepository saudiPassRepository;
  final Lookups lookups;
  final bool isFavoritesOnly;
  final Iterable<SubCategory> allSubCategories;
  final GeoPointMessage point;

  OffersFiltersViewNotifier({
    required this.ref,
    required this.saudiPassRepository,
    required this.defaultCity,
    required this.lookups,
    required this.isFavoritesOnly,
    required this.subCategoriesSelected,
    required this.allSubCategories,
    required this.point,
  });

  late City citySelected = defaultCity;
  final Set<SubCategory> subCategoriesSelected;
  final recommendedTypesSelected = <RecommendedType>{};
  final sortingSelected = <Sorting>{};

  @override
  Set<SubCategory> get subCategories => subCategoriesSelected;

  @override
  Set<Category> get categories => getCategoryWithSelectedSubCategory();

  @override
  City get city => citySelected;

  @override
  Set<RecommendedType> get recommendedTypes => recommendedTypesSelected;

  @override
  OffersMapContext get mapContext => OffersMapContext(
        cityIds: {citySelected.id},
        cityTitle: citySelected.name,
        categories: categories,
        subCategories: subCategoriesSelected,
        recommendedTypes: recommendedTypesSelected,
      );

  @override
  late AsyncIterable<OfferView> asyncIterableOffers = createOffersAsyncIterable();

  AsyncIterable<OfferView> createOffersAsyncIterable() {
    final chunked = OffersChunkedAsyncIterable(
      saudiPassRepository: saudiPassRepository,
      cities: {citySelected},
      recommendedTypes: recommendedTypesSelected,
      categories: categories,
      subCategories: subCategories,
      favorites: isFavoritesOnly ? true : null,
      sorting: sortingSelected.firstOrNull,
      mapPoint: point,
    );

    OfferView createOfferCardView(Offer offer) =>
        OfferViewImpl(offer, ref, saudiPassRepository, reloadOnFavoriteChanges);

    return MappedAsyncIterable(
      decorated: FlatChunkedAsyncIterable(CachedAsyncIterable(chunked), chunked.chunkSize),
      transformation: createOfferCardView,
    );
  }

  @override
  void reset() {
    citySelected = defaultCity;
    recommendedTypesSelected.clear();
    subCategoriesSelected.clear();
    sortingSelected.clear();
    createNewListAndNotify();
  }

  void createNewListAndNotify() {
    asyncIterableOffers = createOffersAsyncIterable();
    notifyListeners();
  }

  void reloadOnFavoriteChanges() {
    if (isFavoritesOnly) {
      createNewListAndNotify();
    }
  }

  @override
  Future<void> tapCity() async {
    final citySelectionDialog = CitySelectionDialogViewNotifier(lookups.cities);

    final city = await stackRouter.push<City>(
      CitySelectionDialogViewRoute(citySelectionDialogView: citySelectionDialog),
    );

    if (city != null && city != citySelected) {
      citySelected = city;

      createNewListAndNotify();
    }
  }

  @override
  void tapType() {
    final selectionDialog = RecommendedTypeSelectionDialogViewNotifier(this);
    stackRouter.push(TypeSelectionDialogViewRoute(selectionDialog: selectionDialog));
  }

  @override
  Future<void> tapShowAllCategories() async {
    final selectionDialog = CategorySelectionDialogViewNotifier((
      lookups.categories,
      allSubCategories,
      subCategoriesSelected,
      applyCategories,
    ));

    if (await stackRouter.push(AllCategoriesSelectionDialogViewRoute(selectionDialogView: selectionDialog)) == true) {
      createNewListAndNotify();
    }
  }

  @override
  void tapSort() {
    final selectionDialog = SortingSelectionDialogViewNotifier(this);
    stackRouter.push(SortingSelectionDialogRoute(selectionDialog: selectionDialog));
  }

  bool update<T>(Set<T> current, Set<T> updated) {
    if (!setEquals(current, updated)) {
      current
        ..clear()
        ..addAll(updated);
      return true;
    }
    return false;
  }

  void updateAndNotify<T>(Set<T> current, Set<T> updated) {
    if (update(current, updated)) {
      createNewListAndNotify();
    }
  }

  void applyCategories(Set<SubCategory> set) => updateAndNotify(subCategoriesSelected, set);

  void applySorting(Set<Sorting> set) => updateAndNotify(sortingSelected, set);

  void applyRecommendedTypes(Set<RecommendedType> set) => updateAndNotify(recommendedTypesSelected, set);

  void applySettings(City city, Set<RecommendedType> recommendedTypes, Set<SubCategory> categories) {
    final isCityUpdated = city != citySelected;
    citySelected = city;
    if (update(recommendedTypesSelected, recommendedTypes) |
        update(subCategoriesSelected, categories) |
        isCityUpdated) {
      createNewListAndNotify();
    }
  }

  @override
  void tapSettings() {
    final settingsScreen = SettingsScreenViewNotifier(this);

    stackRouter.push(SettingsScreenViewRoute(settingsScreenView: settingsScreen));
  }

  FilterView mapSelectionToFilterView(Set<NameId> set) {
    final length = set.length;
    final plusMore = length > 1 ? '+${length - 1}' : null;
    return (
      title: set.firstOrNull?.name,
      plusMore: plusMore,
      isHighlighted: set.isNotEmpty,
      tapCross: () {
        set.clear();
        createNewListAndNotify();
      },
    );
  }

  Set<Category> getCategoryWithSelectedSubCategory() {
    final cats = lookups.categories;
    // Group all subcategories by category
    final Map<Category, List<SubCategory>> grouped = {};

    for (final sub in allSubCategories) {
      grouped.putIfAbsent(cats.firstWhere((it) => it.id == sub.categoryId), () => []).add(sub);
    }

    // Return categories where at least one of their subcategories are selected
    return grouped.entries
        .where((entry) => entry.value.any(subCategoriesSelected.contains))
        .map((entry) => entry.key)
        .toSet();
  }

  @override
  FilterView get typeFilterView {
    if (recommendedTypesSelected.isEmpty) {
      return (title: null, plusMore: null, isHighlighted: false, tapCross: null);
    }

    final typeCount = recommendedTypesSelected.length;

    if (typeCount == 1) {
      // Show type name only
      return (
        title: recommendedTypesSelected.first.name,
        plusMore: null,
        isHighlighted: true,
        tapCross: () {
          recommendedTypesSelected.clear();
          createNewListAndNotify();
        },
      );
    } else {
      // Show "Type" + type count
      return (
        title: null, // Will use l10nString from widget
        plusMore: typeCount.toString(),
        isHighlighted: true,
        tapCross: () {
          recommendedTypesSelected.clear();
          createNewListAndNotify();
        },
      );
    }
  }

  @override
  FilterView get categoryFilterView {
    if (subCategoriesSelected.isEmpty) {
      return (title: null, plusMore: null, isHighlighted: false, tapCross: null);
    }

    final selectedCategories = getCategoryWithSelectedSubCategory();
    final categoryCount = selectedCategories.length;

    if (categoryCount == 1) {
      // Show category name + subcategory count
      final category = selectedCategories.first;
      final subcategoryCount = subCategoriesSelected.where((sub) => sub.categoryId == category.id).length;
      return (
        title: category.name,
        plusMore: subcategoryCount > 0 ? subcategoryCount.toString() : null,
        isHighlighted: true,
        tapCross: () {
          subCategoriesSelected.clear();
          createNewListAndNotify();
        },
      );
    } else {
      // Show "Category" + category count
      return (
        title: null, // Will use l10nString from widget
        plusMore: categoryCount.toString(),
        isHighlighted: true,
        tapCross: () {
          subCategoriesSelected.clear();
          createNewListAndNotify();
        },
      );
    }
  }

  @override
  FilterView get cityFilterView => (
    title: citySelected.name,
    plusMore: null,
    isHighlighted: citySelected != defaultCity,
    tapCross: () {
      citySelected = defaultCity;
      createNewListAndNotify();
    },
  );

  @override
  bool get isSortHighlighted => sortingSelected.isNotEmpty;

  @override
  bool get isSettingsHighlighted =>
      subCategoriesSelected.isNotEmpty || recommendedTypesSelected.isNotEmpty || citySelected != defaultCity;
}

class OfferViewImpl extends ChangeNotifier implements OfferView {
  final Offer offer;
  final Ref ref;
  final SaudiPassRepository saudiPassRepository;
  final void Function()? reloadOffers;

  OfferViewImpl(this.offer, this.ref, this.saudiPassRepository, [this.reloadOffers]);

  @override
  Future<void> onTap() async {
    final offerFavorites = ref.read(offerFavoritesProvider(offerId).notifier);

    final keepAliveOfferFavorites = offerFavorites.ref.keepAlive();

    offerFavorites.syncState(isFavorite: isHeartRedAndFilled);

    ref.read(currentSelectedOfferProvider.notifier).state = offer;
    await ref.read(appRouterProvider).push(OfferRoute(offerId: offer.id));

    _syncState(ref.read(offerFavoritesProvider(offerId)));

    keepAliveOfferFavorites.close();
  }

  void _syncState(OfferFavoritesState offerFavoritesState) {
    switch (offerFavoritesState) {
      case OfferFavoritesState.initial:
      case OfferFavoritesState.loading:
      case OfferFavoritesState.error:
        return;
      case OfferFavoritesState.added:
        isHeartRedAndFilled = true;
        break;
      case OfferFavoritesState.removed:
        isHeartRedAndFilled = false;
        break;
    }
    notifyListeners();
  }

  @override
  String get title => offer.name;

  String get imageId => offer.provider.logo;

  @override
  ({String url, Map<String, String> headers}) get logo => saudiPassRepository.getPromotionsImagesUri(imageId: imageId);

  @override
  late bool isHeartRedAndFilled = offer.favorite;

  @override
  String get subTitle => offer.description;

  @override
  DateTime get byDate => offer.publishEndDate;

  @override
  bool get isByDateRed => offer.willExpiredSoon;

  @override
  num? get amount => offer.typeDetails?.amount;

  @override
  String get branchName => offer.branchName;

  @override
  num? get ratio => offer.typeDetails?.ratio;

  @override
  OffersGroup get offersGroup => offer.offerGroup;

  @override
  String get offerId => offer.id;

  @override
  String? get distance => offer.distance;

  @override
  Future<void> onHeartTap() async {
    if (CommonProperties.isLoggedIn) {
      await toggleWithBottomSheetDialog();
    } else {
      await ref.read(authProvider.notifier).doAuth();

      if (CommonProperties.isLoggedIn) {
        await toggleWithBottomSheetDialog();
      }
    }
  }

  void toggleAndNotify() {
    isHeartRedAndFilled = !isHeartRedAndFilled;
    notifyListeners();
    reloadOffers?.call();
  }

  Future<void> toggleWithBottomSheetDialog() async {
    if (isHeartRedAndFilled) {
      await ref
          .read(appRouterProvider)
          .push(
            OfferFavoritesRemovingSheetRoute(
              onRemove: () async {
                await ref.read(offerFavoritesProvider(offerId).notifier).removeFromFavorites();
                toggleAndNotify();
              },
            ),
          );
    } else {
      await ref.read(offerFavoritesProvider(offer.id).notifier).addToFavorites();
      toggleAndNotify();
    }
  }
}
