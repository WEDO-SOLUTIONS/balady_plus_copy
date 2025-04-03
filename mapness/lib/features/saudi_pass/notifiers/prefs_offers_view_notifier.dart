part of 'offers_screen_view_notifier.dart';

class PrefsOffersViewNotifier extends ChangeNotifier implements PrefsOffersView {
  PrefsOffersViewNotifier(this.saudiPassRepository, this.stackRouter, this.preferences);

  final SaudiPassRepository saudiPassRepository;
  final StackRouter stackRouter;
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
    );

    OfferView createOfferCardView(Offer offer) => OfferViewImpl(offer, stackRouter, saudiPassRepository);

    return MappedAsyncIterable(
      decorated: FlatChunkedAsyncIterable(CachedAsyncIterable(chunked), chunked.chunkSize),
      transformation: createOfferCardView,
    );
  }

  @override
  String get cityTitle => preferences.cities.first.name;

  @override
  int get types => preferences.recommendedTypes.length;

  @override
  int get categories => preferences.categories.length;
}
