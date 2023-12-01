import 'package:mapness/entities/iwish/models/iwish_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'iwish_address.g.dart';

@riverpod
class _IwishAddress extends _$IwishAddress {
  @override
  String build(IwishEntity iwish) {
    // final address = ref.watch(searchProvider);
    final coordinates =
        '${iwish.location.longitude}, ${iwish.location.latitude}';
    // ref.watch(searchProvider.notifier).searchByText(coordinates);

    // return address.firstOrNull?.title ?? coordinates;
    return coordinates;
  }
}

const iwishAddressProvider = _iwishAddressProvider;
