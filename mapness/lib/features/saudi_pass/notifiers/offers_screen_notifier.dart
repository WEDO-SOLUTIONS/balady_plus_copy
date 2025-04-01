import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/saudi_pass/offers_group.dart';
import 'package:mapness/features/saudi_pass/async_iterable/async_iterable.dart';
import 'package:mapness/features/saudi_pass/async_iterable/cached_async_iterable.dart';
import 'package:mapness/features/saudi_pass/async_iterable/flat_chunked_async_iterable.dart';
import 'package:mapness/features/saudi_pass/async_iterable/mapped_async_iterable.dart';
import 'package:mapness/features/saudi_pass/async_iterable/offers_chunked_async_iterable.dart';
import 'package:mapness/features/saudi_pass/notifiers/category_selection_dialog_notifier.dart';
import 'package:mapness/features/saudi_pass/notifiers/city_selection_dialog_notifier.dart';
import 'package:mapness/features/saudi_pass/notifiers/offers_view_notifier.dart';
import 'package:mapness/features/saudi_pass/notifiers/recommended_type_selection_dialog_notifier.dart';
import 'package:mapness/features/saudi_pass/notifiers/settings_screen_notifier.dart';
import 'package:mapness/features/saudi_pass/notifiers/sorting_selection_dialog_notifier.dart';
import 'package:mapness/features/saudi_pass/repo/get_preferences_body.dart';
import 'package:mapness/features/saudi_pass/repo/lookups_body.dart';
import 'package:mapness/features/saudi_pass/repo/promotions_body.dart';
import 'package:mapness/features/saudi_pass/repo/saudi_pass_repository.dart';
import 'package:mapness/features/saudi_pass/views/offers_screen.dart';
import 'package:mapness/features/saudi_pass/views/selection_dialog.dart';

part 'offers_filters_view_notifier.dart';
part 'prefs_offers_view_notifier.dart';

class OffersScreenNotifier extends OffersViewNotifier implements OffersScreen {
  OffersScreenNotifier({
    required super.saudiPassRepository,
    required super.cityByLocation,
    required super.stackRouter,
    this.offersGroups = const {},
  });

  @override
  final Set<OffersGroup> offersGroups;

  @override
  late Future<PrefsOffersViewNotifier> prefsOffersViewFuture = createPrefsOffersViewNotifier();

  @override
  bool get isFavoritesOnly => false;

  @override
  bool isByPreferencesElseAll = false;

  @override
  void tapBack() => stackRouter.popForced();

  @override
  void tapByPreferences() {
    isByPreferencesElseAll = true;
    notifyListeners();
  }

  @override
  void tapAll() {
    isByPreferencesElseAll = false;
    notifyListeners();
  }

  @override
  void tapRetryPrefs() {
    prefsOffersViewFuture = createPrefsOffersViewNotifier();
    notifyListeners();
  }

  Future<PrefsOffersViewNotifier> createPrefsOffersViewNotifier() async {
    final saudiPassRepository = await this.saudiPassRepository;
    final preferences = await saudiPassRepository.getPreferences();
    return PrefsOffersViewNotifier(saudiPassRepository, stackRouter, preferences);
  }
}
