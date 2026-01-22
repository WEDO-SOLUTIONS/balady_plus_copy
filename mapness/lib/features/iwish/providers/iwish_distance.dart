import 'package:mapness/entities/iwish/models/iwish_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'iwish_distance.g.dart';

@riverpod
class _IwishDistance extends _$IwishDistance {
  @override
  String build(IwishEntity entity) => '10 km';
}

final iwishDistanceProvider = _iwishDistanceProvider;
