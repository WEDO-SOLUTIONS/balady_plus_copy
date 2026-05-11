import 'package:auto_route/auto_route.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/saudi_pass/offers_group.dart';
import 'package:mapness/features/saudi_pass/async_iterable/async_iterable.dart';
import 'package:mapness/features/saudi_pass/async_iterable/cached_async_iterable.dart';
import 'package:mapness/features/saudi_pass/async_iterable/flat_chunked_async_iterable.dart';
import 'package:mapness/features/saudi_pass/async_iterable/mapped_async_iterable.dart';
import 'package:mapness/features/saudi_pass/async_iterable/offers_chunked_async_iterable.dart';
import 'package:mapness/features/saudi_pass/notifiers/category_selection_dialog_view_notifier.dart';
import 'package:mapness/features/saudi_pass/notifiers/city_selection_dialog_view_notifier.dart';
import 'package:mapness/features/saudi_pass/notifiers/offers_view_notifier.dart';
import 'package:mapness/features/saudi_pass/notifiers/recommended_type_selection_dialog_view_notifier.dart';
import 'package:mapness/features/saudi_pass/notifiers/settings_screen_view_notifier.dart';
import 'package:mapness/features/saudi_pass/notifiers/sorting_selection_dialog_view_notifier.dart';
import 'package:mapness/features/saudi_pass/providers/offer_favorites_provider.dart';
import 'package:mapness/features/saudi_pass/providers/offer_details_provider.dart';
import 'package:mapness/features/saudi_pass/repo/get_preferences_body.dart';
import 'package:mapness/features/saudi_pass/repo/lookups_body.dart';
import 'package:mapness/features/saudi_pass/repo/promotions_body.dart';
import 'package:mapness/features/saudi_pass/repo/saudi_pass_repository.dart';
import 'package:mapness/features/saudi_pass/services/city_resolver/by_preference_city_resolver_provider.dart';
import 'package:mapness/features/saudi_pass/views/offers_screen_view.dart';
import 'package:mapness/features/saudi_pass/views/selection_dialog_view.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';

part 'offers_filters_view_notifier.dart';
part 'prefs_offers_view_notifier.dart';

class OffersScreenViewNotifier extends OffersViewNotifier
    implements OffersScreenView {
  OffersScreenViewNotifier({
    required super.saudiPassRepository,
    required super.ref,
    this.offersGroup,
  });

  @override
  final OffersGroup? offersGroup;

  @override
  late Future<PrefsOffersViewNotifier> prefsOffersViewFuture =
      createPrefsOffersViewNotifier();

  @override
  bool get isFavoritesOnly => false;

  @override
  bool isByPreferencesElseAll = false;

  bool _isManuallySelected = false;
  bool _hasCheckedPreferences = false;

  bool get isManuallySelected => _isManuallySelected;

  /// Initialize the tab state based on user preferences
  Future<void> initializeTabState() async {
    if (_hasCheckedPreferences || _isManuallySelected) {
      return;
    }
    if (CommonProperties.isLoggedIn) {
      try {
        final saudiPassRepository = await this.saudiPassRepository;
        final preferences = await saudiPassRepository.getPreferences();
        if (!preferences.isNotPopulated) {
          // User has preferences, set initial state to By Preferences
          isByPreferencesElseAll = true;
          notifyListeners();
        } else {
          // User is logged in but has no preferences, default to All tab
          isByPreferencesElseAll = false;
          notifyListeners();
        }
      } catch (_) {
        // If error fetching preferences, default to All tab
        isByPreferencesElseAll = false;
        notifyListeners();
      }
      _hasCheckedPreferences = true;
    }
  }

  @override
  void tapBack() => ref.read(appRouterProvider).pop();

  @override
  void tapByPreferences() {
    // Always allow switching to By Preferences tab
    // If not logged in, the UI will show login prompt
    _isManuallySelected = true;
    isByPreferencesElseAll = true;
    notifyListeners();
  }

  @override
  void tapAll() {
    _isManuallySelected = true;
    isByPreferencesElseAll = false;
    notifyListeners();
  }

  @override
  void tapRetryPrefs() {
    prefsOffersViewFuture = createPrefsOffersViewNotifier();
    notifyListeners();
  }

  @override
  Future<OffersMapContext> get activeMapContext async {
    // Resolve the snapshot from whichever tab is currently active. This is
    // the single point where the Map view inherits the list's filter
    // context per BRD US-03 BR-02.
    if (isByPreferencesElseAll) {
      final view = await prefsOffersViewFuture;
      return view.mapContext;
    }
    final view = await offersFiltersFuture;
    return view.mapContext;
  }

  Future<PrefsOffersViewNotifier> createPrefsOffersViewNotifier() async {
    final saudiPassRepository = await this.saudiPassRepository;
    final preferences = await saudiPassRepository.getPreferences();
    // BRD US-01 (BALADY-188): city resolution chain Preference → Location → Riyadh
    // is centralized in `byPreferenceCityResolverProvider`. Do not reimplement
    // the priority chain here.
    final resolution = await ref.read(byPreferenceCityResolverProvider.future);
    final controller = await ref.read(dgisControllerProvider.future);
    final cameraPosition = await controller.getCameraPosition();
    return PrefsOffersViewNotifier(
      saudiPassRepository,
      cameraPosition.point,
      resolution.city,
      ref,
      preferences,
    );
  }
}
