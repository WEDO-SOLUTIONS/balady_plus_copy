import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:mapness/entry_point.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_route_provider.g.dart';

class RouteState {
  RouteState({this.currentPath, this.previousPath});
  final String? currentPath;
  final String? previousPath;
}

@Riverpod(keepAlive: true)
class CurrentRoute extends _$CurrentRoute {
  @override
  RouteState? build() => null;

  void update(String? path) {
    final previosPath = state?.currentPath;

    state = RouteState(currentPath: path, previousPath: previosPath);

    mixpanel
        ?.track('CurrentRoute', properties: {'path': '${state?.currentPath}'});
    FlutterUxcam.tagScreenName(state?.currentPath ?? 'unknown');

    Metrics.logEventAdvanced('Update', screen: CurrentRoute, props: {
      'path': '${state?.currentPath}',
      'previousPath': '$previosPath',
    });
  }
}
