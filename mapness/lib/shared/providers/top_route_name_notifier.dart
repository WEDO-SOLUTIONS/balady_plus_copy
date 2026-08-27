import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'top_route_name_notifier.g.dart';

/// notifies of top route name updates
@riverpod
class TopRouteName extends _$TopRouteName {
  final _controller = StreamController<String>();

  @override
  Stream<String> build() => _controller.stream;

  void setRoute(String? name) {
    if (name != null) {
      _controller.add(name);
    }
  }
}
