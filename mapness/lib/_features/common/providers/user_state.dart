import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_state.g.dart';

enum UserState { guest, personal, business }

@riverpod
class _UserState extends _$UserState {
  @override
  UserState build() => UserState.guest;

  /// The state this notifier holds.
  UserState get value => state;

  set value(UserState newValue) => state = newValue;
}

final userStateProvider = _userStateProvider;
