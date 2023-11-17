import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_state.g.dart';

enum UserState { guest, personal, business }

@riverpod
class _UserState extends _$UserState {
  @override
  UserState build() => UserState.guest;

  void update(UserState value) => state = value;
}

final userStateProvider = _userStateProvider;
