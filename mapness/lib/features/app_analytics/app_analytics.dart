import 'package:flutter/foundation.dart';
import 'package:mapness/features/app_analytics/app_analytics_repository.dart';
import 'package:mapness/features/app_analytics/data/app_analytics_byteplus_impl.dart';
import 'package:mapness/features/app_analytics/data/app_analytics_insider_impl.dart';
import 'package:mapness/features/app_analytics/models/datafinder_models.dart';
import 'package:mapness/features/app_feedback/device_info_provider.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_analytics.g.dart';

/// Composite analytics implementation that fans out every event to both
/// Insider and BytePlus simultaneously.
///
/// Add new analytics backends here — no callers need to change.
class _CompositeAnalytics implements AppAnalyticsApi {
  _CompositeAnalytics(this._implementations);

  final List<AppAnalyticsRepository> _implementations;

  /// Only the backends that opted into the DataFinder capability. An event in
  /// this group is sent **only** to these — backends that don't implement
  /// [DataFinderAnalyticsRepository] (e.g. Insider) never receive it.
  Iterable<DataFinderAnalyticsRepository> get _dataFinderImpls =>
      _implementations.whereType<DataFinderAnalyticsRepository>();

  @override
  void onboardingFlowStarted() {
    for (final impl in _implementations) {
      impl.onboardingFlowStarted();
    }
  }

  @override
  void onboardingFlowSkipped() {
    for (final impl in _implementations) {
      impl.onboardingFlowSkipped();
    }
  }

  @override
  void onboardingFlowCompleted() {
    for (final impl in _implementations) {
      impl.onboardingFlowCompleted();
    }
  }

  @override
  void navigationSearch({
    required String destinationCity,
    required String keyword,
    required String originCity,
    required bool isResultsFound,
    required int resultCount,
  }) {
    for (final impl in _implementations) {
      impl.navigationSearch(
        destinationCity: destinationCity,
        keyword: keyword,
        originCity: originCity,
        isResultsFound: isResultsFound,
        resultCount: resultCount,
      );
    }
  }

  @override
  void navigationStarted({
    required String originLocation,
    required String destinationLocation,
    required String destinationCity,
    required String originCity,
    required int estimateTime,
    required double estimateDistance,
  }) {
    for (final impl in _implementations) {
      impl.navigationStarted(
        originLocation: originLocation,
        destinationLocation: destinationLocation,
        destinationCity: destinationCity,
        originCity: originCity,
        estimateTime: estimateTime,
        estimateDistance: estimateDistance,
      );
    }
  }

  @override
  void userMovementDetected({
    required String destinationCity,
    required String originCity,
  }) {
    for (final impl in _implementations) {
      impl.userMovementDetected(destinationCity: destinationCity, originCity: originCity);
    }
  }

  @override
  void navigationHalfWay({
    required String origin,
    required String destination,
    required String destinationCity,
    required String originCity,
    required Duration spentTime,
    required String midPoint,
  }) {
    for (final impl in _implementations) {
      impl.navigationHalfWay(
        origin: origin,
        destination: destination,
        destinationCity: destinationCity,
        originCity: originCity,
        spentTime: spentTime,
        midPoint: midPoint,
      );
    }
  }

  @override
  void navigationCompleted({
    required String origin,
    required String destination,
    required String destinationCity,
    required String originCity,
    required Duration spentTime,
  }) {
    for (final impl in _implementations) {
      impl.navigationCompleted(
        origin: origin,
        destination: destination,
        destinationCity: destinationCity,
        originCity: originCity,
        spentTime: spentTime,
      );
    }
  }

  @override
  void setUserInfo({
    String? email,
    String? locale,
    String? deviceId,
    String? deviceOs,
    String? appVersion,
    String? userId,
    String? phone,
    String? firstName,
    String? lastName,
  }) {
    for (final impl in _implementations) {
      impl.setUserInfo(
        email: email,
        locale: locale,
        deviceId: deviceId,
        deviceOs: deviceOs,
        appVersion: appVersion,
        userId: userId,
        phone: phone,
        firstName: firstName,
        lastName: lastName,
      );
    }
  }

  @override
  void categorySelected(String category) {
    for (final impl in _implementations) {
      impl.categorySelected(category);
    }
  }

  @override
  void serviceSectionVisited() {
    for (final impl in _implementations) {
      impl.serviceSectionVisited();
    }
  }

  @override
  void quickActionSelected(String action) {
    for (final impl in _implementations) {
      impl.quickActionSelected(action);
    }
  }

  @override
  void appIconQuickActionSelected({
    required String action,
    required String outcome,
    String? reason,
  }) {
    for (final impl in _implementations) {
      impl.appIconQuickActionSelected(action: action, outcome: outcome, reason: reason);
    }
  }

  @override
  void carPlayConnected() {
    for (final impl in _implementations) {
      impl.carPlayConnected();
    }
  }

  @override
  void poiContributionUsed({required String type}) {
    for (final impl in _implementations) {
      impl.poiContributionUsed(type: type);
    }
  }

  @override
  void isNavigationUser({bool isNavUser = false}) {
    for (final impl in _implementations) {
      impl.isNavigationUser(isNavUser: isNavUser);
    }
  }

  @override
  Future<void> deviceTypeDetected() async {
    for (final impl in _implementations) {
      await impl.deviceTypeDetected();
    }
  }

  @override
  void networkConnectionType({required String type}) {
    for (final impl in _implementations) {
      impl.networkConnectionType(type: type);
    }
  }

  @override
  void transportModeSelected({required String type}) {
    for (final impl in _implementations) {
      impl.transportModeSelected(type: type);
    }
  }

  // ── DataFinder Phase-1 search events ──────────────────────────────────────

  @override
  void searchBoxClick({
    required DataFinderSourcePage eventSource,
    required bool isFirstClick,
  }) {
    for (final impl in _dataFinderImpls) {
      impl.searchBoxClick(eventSource: eventSource, isFirstClick: isFirstClick);
    }
  }

  @override
  void searchBoxInput({
    required DataFinderInputOperation operationType,
    required String inputText,
  }) {
    for (final impl in _dataFinderImpls) {
      impl.searchBoxInput(operationType: operationType, inputText: inputText);
    }
  }

  @override
  void searchButtonClick({
    required DataFinderSourcePage eventSource,
    required String searchText,
    String triggerMethod = 'Keyboard',
  }) {
    for (final impl in _dataFinderImpls) {
      impl.searchButtonClick(eventSource: eventSource, searchText: searchText, triggerMethod: triggerMethod);
    }
  }

  @override
  void quickSearchClick({
    required DataFinderSourcePage eventSource,
    required String searchText,
  }) {
    for (final impl in _dataFinderImpls) {
      impl.quickSearchClick(eventSource: eventSource, searchText: searchText);
    }
  }

  @override
  void favoriteAdd({
    required DataFinderSourcePage eventSource,
    required DataFinderFavoriteType favoriteType,
    required DataFinderPoi poi,
  }) {
    for (final impl in _dataFinderImpls) {
      impl.favoriteAdd(eventSource: eventSource, favoriteType: favoriteType, poi: poi);
    }
  }

  @override
  void suggestionExposure({
    required String requestId,
    required String sessionId,
    required String searchText,
    required DataFinderSearchParam searchParam,
    required List<DataFinderPoi> pois,
  }) {
    for (final impl in _dataFinderImpls) {
      impl.suggestionExposure(
        requestId: requestId,
        sessionId: sessionId,
        searchText: searchText,
        searchParam: searchParam,
        pois: pois,
      );
    }
  }

  @override
  void suggestionClick({
    required DataFinderSourcePage eventSource,
    required String requestId,
    required String sessionId,
    required String searchText,
    required String suggestionType,
    required DataFinderPoi poi,
  }) {
    for (final impl in _dataFinderImpls) {
      impl.suggestionClick(
        eventSource: eventSource,
        requestId: requestId,
        sessionId: sessionId,
        searchText: searchText,
        suggestionType: suggestionType,
        poi: poi,
      );
    }
  }

  @override
  void searchResultsExposure({
    required DataFinderSourcePage eventSource,
    required String requestId,
    required String sessionId,
    required String searchText,
    required DataFinderSearchType searchType,
    required DataFinderSearchParam searchParam,
    required List<DataFinderPoi> pois,
  }) {
    for (final impl in _dataFinderImpls) {
      impl.searchResultsExposure(
        eventSource: eventSource,
        requestId: requestId,
        sessionId: sessionId,
        searchText: searchText,
        searchType: searchType,
        searchParam: searchParam,
        pois: pois,
      );
    }
  }

  @override
  void searchResultsClick({
    required DataFinderSourcePage eventSource,
    required String requestId,
    required String sessionId,
    required String searchText,
    required DataFinderClickAction clickAction,
    required DataFinderPoi poi,
  }) {
    for (final impl in _dataFinderImpls) {
      impl.searchResultsClick(
        eventSource: eventSource,
        requestId: requestId,
        sessionId: sessionId,
        searchText: searchText,
        clickAction: clickAction,
        poi: poi,
      );
    }
  }
}

// Prevents auto-dispose to avoid re-initializing analytics on page changes
@Riverpod(keepAlive: true)
class AppAnalytics extends _$AppAnalytics {
  @override
  AppAnalyticsApi build() {
    // Watch the auth AsyncValue (NOT `authProvider.future`). `Auth` updates its
    // state imperatively (`state = AsyncValue.data(userInfo)`) from an
    // EntryPointCubit stream listener on login/logout; that mutation re-emits the
    // AsyncValue and rebuilds watchers of `authProvider`, but does NOT produce a
    // fresh `.future` — so watching `.future` captured the pre-login value once
    // and never refired on login (DataFinder stayed logged-out). Matching the
    // rest of the app (`ref.watch(authProvider).value`) makes this rebuild on
    // every login/logout/account switch.
    final auth = ref.watch(authProvider);
    final analytics =
        stateOrNull ??
        _CompositeAnalytics([
          AppAnalyticsInsiderImpl(),
          AppAnalyticsBytePlusImpl(),
        ]);
    final locale = ref.watch(appLanguageProvider).languageCode;
    final deviceInfo = ref.watch(deviceInfoProvider.future);
    Future(() async {
      final authValue = auth.value;
      final deviceInfoValue = await deviceInfo;

      // TEMP debug (physical-device testing of the DataFinder user identity):
      // shows what id resolves per login type. grep console for [DataFinder].
      debugPrint(
        '[DataFinder] resolve userId -> '
        'loggedIn=${authValue != null} '
        'loginType=${authValue?.loginType.name} '
        'sub=${authValue?.sub} idNo=${authValue?.idNo} '
        '=> ${authValue == null ? 'null' : (authValue.sub ?? authValue.idNo)}',
      );

      analytics.setUserInfo(
        email: authValue?.getEmail(),
        locale: locale,
        deviceId: deviceInfoValue.deviceId,
        deviceOs: deviceInfoValue.mobileOS?.name,
        appVersion: deviceInfoValue.appVersion,
        // Logged-in user id. Use `sub` — the SSO subject id — because it is the
        // ONE identifier that means the same thing across phone (OTP) and
        // national-id (SSO) login (unlike `idNo`, which is `sub` on phone but the
        // national id on SSO). `null` => not logged in (DataFinder clears the
        // user); non-null => logged in.
        //
        // Read from the *live* auth state we already `ref.watch` above — NOT from
        // `deviceInfoProvider`, which is `keepAlive` and captures its id once at
        // app start (before login) and never refreshes. Watching auth makes this
        // rebuild on every login/logout/account switch, so the correct id is sent
        // and it clears on logout.
        //
        // Fallback to `idNo` only while genuinely logged in, so a (theoretical)
        // SSO token missing the `sub` claim never makes a logged-in user look
        // logged out. On phone login `sub` is a guaranteed non-null String.
        userId: authValue == null ? null : (authValue.sub ?? authValue.idNo),
        phone: authValue?.getPhone(),
        firstName: authValue?.getFirstName(),
        lastName: authValue?.getLastName(),
      );
    });

    return analytics;
  }
}
