import 'dart:convert';

import 'package:mapness/shared/constants/constants.dart';
import 'package:mapness/shared/providers/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'vendor_config.g.dart';

@riverpod
class VendorConfig extends _$VendorConfig {
  @override
  Future<Map<String, dynamic>> build() async {
    final box = await ref.watch(hiveProvider(MapnessConstants.envConfigBoxKey).future);
    final vendorConfigString = box.get(MapnessConstants.vendorConfigKey);
    final vendorData = json.decode(vendorConfigString) as List<dynamic>;
    final vendorOverrides = (vendorData.first as Map<String, dynamic>)['overrides'] as Map<String, dynamic>;
    return vendorOverrides;
  }
}
