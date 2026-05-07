part of 'offers_screen_view_notifier.dart';

class PrefsOffersViewNotifier extends ChangeNotifier implements PrefsOffersView {
  PrefsOffersViewNotifier(this.saudiPassRepository, this.point, this.resolvedCity, this.ref, this.preferences);

  final SaudiPassRepository saudiPassRepository;

  /// City resolved per BRD US-01 priority chain
  /// (`Preference City → Current Location City → Riyadh`). Computed by
  /// `byPreferenceCityResolverProvider`. Used as the fallback when the user
  /// has no preference cities configured.
  final City resolvedCity;
  final Ref ref;
  final GeoPointMessage point;
  Preferences preferences;

  @override
  bool get isSetPreferencesOrOffersVisible => preferences.isNotPopulated;

  @override
  late AsyncIterable<OfferView> asyncIterableOffers = createOffersAsyncIterable();

  @override
  void tapIconEdit() => openPreferences();

  @override
  void tapGotoPreferences() => openPreferences();

  Future<void> openPreferences() async {
    final stackRouter = ref.read(appRouterProvider);
    final futurePreferences = await stackRouter.push<Future<Preferences>>(const ProfilePreferencesRoute());
    if (futurePreferences != null) {
      final returnedPreferences = await futurePreferences;
      if (returnedPreferences != preferences) {
        preferences = returnedPreferences;
        asyncIterableOffers = createOffersAsyncIterable();
        notifyListeners();
      }
    }
  }

  AsyncIterable<OfferView> createOffersAsyncIterable() {
    final chunked = OffersChunkedAsyncIterable.byPrefs(
      saudiPassRepository: saudiPassRepository,
      preferences: preferences,
      resolvedCity: resolvedCity,
      mapPoint: point,
    );

    OfferView createOfferCardView(Offer offer) => OfferViewImpl(offer, ref, saudiPassRepository);

    return MappedAsyncIterable(
      decorated: FlatChunkedAsyncIterable(CachedAsyncIterable(chunked), chunked.chunkSize),
      transformation: createOfferCardView,
    );
  }

  @override
  String get cityTitle => (preferences.cities.firstOrNull ?? resolvedCity).name;

  @override
  int get types => preferences.recommendedTypes.length;

  @override
  int get categories => preferences.categories.length;
}
