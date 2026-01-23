import 'package:mapness/entities/iwish/models/iwish_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'iwish_car_eta.g.dart';

@riverpod
class _IwishCarEta extends _$IwishCarEta {
  @override
  String build(IwishEntity iwish) => '17 min';
}

final iwishCarEtaProvider = _iwishCarEtaProvider;
