import 'package:dgis_map/library.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/features/balady_analytics/balady_analytics.dart';
import 'package:mapness/features/balady_analytics/events/navigation_events.dart';
import 'package:mapness/features/routing/providers/current_route.dart';

class _RecordingSink implements BaladyAnalyticsSink {
  final events = <BaladyAnalyticsEvent>[];

  @override
  void track(BaladyAnalyticsEvent event) => events.add(event);

  @override
  void identify(String? userId, Map<String, dynamic> traits) {}
}

void main() {
  final sink = _RecordingSink();

  setUpAll(() => BaladyAnalytics.instance.configure(mode: BaladyAnalyticsMode.dual, sink: sink));
  setUp(sink.events.clear);

  List<BaladyAnalyticsEvent> named(String name) => sink.events.where((e) => e.name == name).toList();

  AddStopPromptTracking show({NavigationTripSource source = NavigationTripSource.phone}) =>
      BaladyNavigationEvents.trackAddStopPromptShown(
        tripSource: source,
        navType: RouteSearchOptionsMessage.car,
        stopsCount: 2,
        limitReached: false,
        poiInRoute: true,
      );

  test('add_stop_prompt_shown carries the prompt context', () {
    show(source: NavigationTripSource.androidAuto);

    final shown = named('add_stop_prompt_shown').single.properties;
    expect(shown['trip_source'], 'android_auto');
    expect(shown['transport_mode'], 'car');
    expect(shown['stops_count'], 2);
    expect(shown['limit_reached'], false);
    expect(shown['poi_in_route'], true);
  });

  test('sends exactly one add_stop_prompt_result per shown sheet', () {
    show()
      ..report(AddStopPromptResult.cancel)
      ..report(AddStopPromptResult.timeout)
      ..report(AddStopPromptResult.dismissed);

    final result = named('add_stop_prompt_result').single.properties;
    expect(result['result'], 'cancel');
    expect(result['time_to_action_ms'], isA<int>());
    expect(result['trip_source'], 'phone');
    expect(result['transport_mode'], 'car');
    expect(result['stops_count'], 2);
    expect(result['limit_reached'], false);
    expect(result.containsKey('poi_in_route'), isFalse);
  });

  test('reports every result value in snake case', () {
    final values = {
      AddStopPromptResult.addStop: 'add_stop',
      AddStopPromptResult.cancel: 'cancel',
      AddStopPromptResult.timeout: 'timeout',
      AddStopPromptResult.dismissed: 'dismissed',
    };
    for (final MapEntry(key: result, value: wire) in values.entries) {
      sink.events.clear();
      show().report(result);
      expect(named('add_stop_prompt_result').single.properties['result'], wire);
    }
  });

  test('measures the time from the sheet shown to the action', () async {
    final tracking = show();
    await Future<void>.delayed(const Duration(milliseconds: 30));
    tracking.report(AddStopPromptResult.addStop);

    expect(named('add_stop_prompt_result').single.properties['time_to_action_ms'], greaterThanOrEqualTo(30));
  });
}
