import 'package:dgis_map/library.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'routes_update_tab.g.dart';

@riverpod
class RoutesUpdateTab extends _$RoutesUpdateTab {
  RouteSearchOptionsMessage get update => state;

  @override
  RouteSearchOptionsMessage build() => RouteSearchOptionsMessage.car;

  set update(RouteSearchOptionsMessage tab) {
    state = tab;
  }
}
