import 'package:mapness/entities/iwish/models/iwish_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'iwish_address.g.dart';

@riverpod
class _IwishAddress extends _$IwishAddress {
  @override
  String build(IwishEntity iwish) {
    return 'mock_address';
  }
}

const iwishAddressProvider = _iwishAddressProvider;
