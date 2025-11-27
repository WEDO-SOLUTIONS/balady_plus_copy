import 'package:mapness/features/saudi_pass/providers/saudi_pass_dio_riverpod_v1.dart';
import 'package:mapness/features/saudi_pass/providers/saudi_pass_dio_riverpod_v2.dart';
import 'package:mapness/features/saudi_pass/repo/saudi_pass_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'saudi_pass_repository_riverpod.g.dart';

final saudiPassRepositoryProvider = _saudiPassRepositoryRiverpodProvider;

@riverpod
class _SaudiPassRepositoryRiverpod extends _$SaudiPassRepositoryRiverpod {
  @override
  Future<SaudiPassRepository> build() async {
    final dioV1 = await ref.watch(saudiPassDioProviderV1.future);
    final dioV2 = await ref.watch(saudiPassDioProviderV2.future);

    return SaudiPassRepository(dioV1, dioV2);
  }
}
