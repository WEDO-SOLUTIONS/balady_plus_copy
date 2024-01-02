import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:mapness/entry_point.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_route_provider.g.dart';

@riverpod
class CurrentRoute extends _$CurrentRoute {
  @override
  String? build() => null;

  void update(String? path) {
    state = path;
    mixpanel?.track('CurrentRoute', properties: {'path': '$state'});
    FlutterUxcam.tagScreenName(state ?? 'unknown');
    ref.read(urbiMetricsProvider.notifier).logEvent('CurrentRoute/update', {
      'path': '$state',
    });
  }
}
