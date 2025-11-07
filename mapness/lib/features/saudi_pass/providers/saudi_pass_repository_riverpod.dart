import 'package:mapness/features/saudi_pass/providers/saudi_pass_dio_riverpod.dart';
import 'package:mapness/features/saudi_pass/repo/saudi_pass_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'saudi_pass_repository_riverpod.g.dart';

final saudiPassRepositoryProvider = _saudiPassRepositoryRiverpodProvider;

@riverpod
class _SaudiPassRepositoryRiverpod extends _$SaudiPassRepositoryRiverpod {
  @override
  Future<SaudiPassRepository> build() async {
    final dio = await ref.watch(saudiPassDioProvider.future);

    return SaudiPassRepository(dio);
  }
}
