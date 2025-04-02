import 'package:mapness/features/saudi_pass/providers/saudi_pass_repository_riverpod.dart';
import 'package:mapness/features/saudi_pass/repo/get_preferences_body.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_profile_preferences_provider.g.dart';


@riverpod
class GetProfilePreferences extends _$GetProfilePreferences {
  @override
  Future<Preferences> build() async {
    final repository = await ref.read(saudiPassRepositoryProvider.future);
    return repository.getPreferences();
  }
}
