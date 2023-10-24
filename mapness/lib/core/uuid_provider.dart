import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'uuid_provider.g.dart';

@riverpod
class UuidProvider extends _$UuidProvider {
  @override
  String build() {
    return const Uuid().v4();
  }
}
