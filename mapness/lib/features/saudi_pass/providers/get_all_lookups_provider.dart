import 'package:mapness/features/saudi_pass/providers/saudi_pass_repository_riverpod.dart';
import 'package:mapness/features/saudi_pass/repo/lookups_body.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_all_lookups_provider.g.dart';

@riverpod
class GetAllLookups extends _$GetAllLookups {
  @override
  Future<Lookups> build() async {
    final repository = await ref.read(saudiPassRepositoryProvider.future);
    final lookups = await repository.getAllLookups();
    return lookups;
  }
}
