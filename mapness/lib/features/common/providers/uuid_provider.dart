import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

part 'uuid_provider.g.dart';

@riverpod
class UuidProvider extends _$UuidProvider {
  @override
  Future<String> build() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('uuid')) {
      return prefs.getString('uuid')!;
    }
    final uuid = const Uuid().v4();
    await prefs.setString('uuid', uuid);
    return uuid;
  }
}
