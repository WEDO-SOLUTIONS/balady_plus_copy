import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:mapness/shared/providers/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'vendor_config.g.dart';

@riverpod
class VendorConfig extends _$VendorConfig {
  @override
  Future<Map<String, dynamic>> build() async {
    final box = await ref.watch(hiveProvider('envType').future);
    final envType = box.get('envType');

    final vendorName = switch (envType) {
      'dev' => 'urbi-pre-prod-vendor-config.jsonx',
      'stg' => 'momrah-staging-vendor-config.jsonx',
      'pre' => 'momrah-prod-vendor-config.jsonx',
      'prod' => 'momrah-prod-vendor-config.jsonx',
      'urbiPre' => 'urbi-pre-prod-vendor-config.jsonx',
      _ => 'urbi-pre-prod-vendor-config.jsonx',
    };

    final contents = await rootBundle.loadString('assets/maps/configs/$vendorName');
    final vendorData = json.decode(contents);
    final vendorOverrides = vendorData[0]['overrides'] as Map<String, dynamic>;

    return vendorOverrides;
  }
}
