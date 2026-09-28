import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/typography/text_theme_styles_v3.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/features/balady_analytics/balady_analytics.dart';
import 'package:mapness/features/path_nav/add_stop_prompt.dart';
import 'package:mapness/features/routing/providers/current_route.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/pages/path_nav/nav_add_stop_sheet_page.dart';
import 'package:mapness/shared/providers/map/point_of_interest.dart';
import 'package:provider/provider.dart' as provider;

class _RecordingSink implements BaladyAnalyticsSink {
  final events = <BaladyAnalyticsEvent>[];

  @override
  void track(BaladyAnalyticsEvent event) => events.add(event);

  @override
  void identify(String? userId, Map<String, dynamic> traits) {}
}

const _objectId = 70000001;
const _tapPoint = LatLng(latitude: 24.71, longitude: 46.67);
const _sheetRouteName = 'NavAddStopSheetRoute';

AddStopPrompt _prompt({bool limitReached = false, bool poiInRoute = false}) => AddStopPrompt(
  navType: RouteSearchOptionsMessage.car,
  tripSource: NavigationTripSource.carplay,
  stopsCount: limitReached ? maxIntermediateStops : 1,
  limitReached: limitReached,
  poiInRoute: poiInRoute,
  routeKnown: true,
);

class _TestRouter extends RootStackRouter {
  _TestRouter(this.prompt);

  final AddStopPrompt prompt;
  Object? sheetResult = 'not closed';

  late final _host = PageInfo(
    'HostRoute',
    builder: (_) => Builder(
      builder: (context) => Center(
        child: TextButton(
          onPressed: () async => sheetResult = await context.router.push<Object?>(const PageRouteInfo(_sheetRouteName)),
          child: const Text('open'),
        ),
      ),
    ),
  );

  late final _sheet = PageInfo(
    _sheetRouteName,
    builder: (_) => NavAddStopSheetPage(objectId: _objectId, tapPoint: _tapPoint, prompt: prompt),
  );

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: _host, initial: true),
    CustomRoute(
      page: _sheet,
      customRouteBuilder: <T>(context, child, page) => ModalBottomSheetRoute<T>(
        settings: page,
        builder: (_) => child,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
      ),
    ),
  ];
}

void main() {
  final sink = _RecordingSink();

  setUpAll(() => BaladyAnalytics.instance.configure(mode: BaladyAnalyticsMode.dual, sink: sink));
  setUp(sink.events.clear);

  List<String?> results() => sink.events
      .where((e) => e.name == 'add_stop_prompt_result')
      .map((e) => e.properties['result'] as String?)
      .toList();

  Future<_TestRouter> openSheet(
    WidgetTester tester,
    AddStopPrompt prompt, {
    Locale locale = const Locale('en'),
    Future<DirectoryObjectMessage?>? poiLookup,
  }) async {
    final router = _TestRouter(prompt);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          pointOfInterestProvider(
            const DgisObjectId(objectId: _objectId, entranceId: 0),
            _tapPoint,
            BaladyAppThemes.light,
          ).overrideWith((ref) => poiLookup ?? Future.value()),
        ],
        child: provider.ChangeNotifierProvider(
          create: (_) => ThemeController(),
          child: MaterialApp.router(
            routerConfig: router.config(),
            theme: ThemeData(extensions: [ThemeTextStylesV3.golos()]),
            locale: locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('open'));
    // Let the route and the sheet slide in; the Cancel timer keeps pumpAndSettle busy.
    for (var i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    return router;
  }

  testWidgets('Cancel closes the sheet with nothing and reports cancel', (tester) async {
    final router = await openSheet(tester, _prompt());
    expect(find.text('Point on map'), findsOneWidget);
    expect(find.text('Add stop'), findsOneWidget);

    await tester.tap(find.text('Cancel').first);
    await tester.pumpAndSettle();

    expect(router.sheetResult, isNull);
    expect(find.text('Add stop'), findsNothing);
    expect(results(), ['cancel']);
  });

  testWidgets('the sheet closes by itself after five seconds', (tester) async {
    final router = await openSheet(tester, _prompt());

    await tester.pump(NavAddStopSheetPage.timeout);
    await tester.pumpAndSettle();

    expect(router.sheetResult, isNull);
    expect(results(), ['timeout']);
  });

  testWidgets('"Add stop" returns the tapped place as a route point', (tester) async {
    final router = await openSheet(tester, _prompt());

    await tester.tap(find.text('Add stop'));
    await tester.pumpAndSettle();

    final stop = router.sheetResult! as RouteParamsPointWithLabel;
    expect(
      stop.value,
      RouteParamsPoint(latitude: _tapPoint.latitude, longitude: _tapPoint.longitude, objectId: _objectId),
    );
    expect(results(), ['add_stop']);
  });

  testWidgets('at the stop limit "Add stop" is disabled and the limit is explained', (tester) async {
    final router = await openSheet(tester, _prompt(limitReached: true));
    expect(find.text(lookupAppLocalizations(const Locale('en')).addStopLimitReachedMessage), findsOneWidget);

    await tester.tap(find.text('Add stop'));
    await tester.pump();
    expect(results(), isEmpty);

    await tester.pump(NavAddStopSheetPage.timeout);
    await tester.pumpAndSettle();
    expect(router.sheetResult, isNull);
    expect(results(), ['timeout']);
  });

  testWidgets('a place already on the route gets only Cancel', (tester) async {
    await openSheet(tester, _prompt(poiInRoute: true));

    expect(find.text('Add stop'), findsNothing);
    expect(find.text('Cancel'), findsWidgets);
  });

  testWidgets('shows the Arabic texts', (tester) async {
    await openSheet(tester, _prompt(limitReached: true), locale: const Locale('ar'));
    final ar = lookupAppLocalizations(const Locale('ar'));

    expect(find.text(ar.addStop), findsOneWidget);
    expect(find.text(ar.addStopLimitReachedMessage), findsOneWidget);
    await tester.pump(NavAddStopSheetPage.timeout);
    await tester.pumpAndSettle();
  });

  testWidgets('"Add stop" works before the POI lookup ends, which gives up after 3 s', (tester) async {
    final lookup = Completer<DirectoryObjectMessage?>();
    final router = await openSheet(tester, _prompt(), poiLookup: lookup.future);
    expect(find.text('Point on map'), findsNothing);

    await tester.pump(NavAddStopSheetPage.lookupTimeout);
    expect(find.text('Point on map'), findsOneWidget);

    await tester.tap(find.text('Add stop'));
    await tester.pumpAndSettle();
    final stop = router.sheetResult! as RouteParamsPointWithLabel;
    expect(stop.value?.objectId, _objectId);
    expect(results(), ['add_stop']);
  });

  testWidgets('a swipe down closes the sheet with exactly one dismissed', (tester) async {
    final router = await openSheet(tester, _prompt());

    await tester.fling(find.text('Point on map'), const Offset(0, 400), 2000);
    await tester.pumpAndSettle();

    expect(find.text('Add stop'), findsNothing);
    expect(router.sheetResult, isNull);
    expect(results(), ['dismissed']);
  });

  testWidgets('closing the sheet from outside reports exactly one dismissed', (tester) async {
    final router = await openSheet(tester, _prompt());

    await router.maybePop();
    await tester.pumpAndSettle();

    expect(find.text('Add stop'), findsNothing);
    expect(results(), ['dismissed']);
  });
}
