import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_route_provider.g.dart';

@riverpod
class CurrentRoute extends _$CurrentRoute {
  @override
  String? build() => null;

  void update(String? path) => state = path;
}
