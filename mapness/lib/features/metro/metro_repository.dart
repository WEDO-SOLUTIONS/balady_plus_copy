import 'package:mapness/features/metro/metro_datasourece.dart';
import 'package:mapness/shared/providers/base_dio.dart';
import 'package:mapness/shared/providers/vendor_config.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'metro_repository.g.dart';

@riverpod
class MetroRepository extends _$MetroRepository {
  @override
  Future<MetroDatasourece> build() async {
    final dio = ref.watch(baseDioProvider);
    final vendorConfig = await ref.watch(vendorConfigProvider.future);
    return MetroDatasourece(dio, vendorConfig);
  }
}
