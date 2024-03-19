import 'package:balady_plus/app/core/dependency_injection/dependency_injection_exports.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'token_provider.g.dart';

@riverpod
class Token extends _$Token {
  Future<void> refreshToken() async {
    try {
      final refreshToken = sl<EntryPointCubit>().state.token?.refreshToken;
      if (refreshToken != null) {
        await sl<EntryPointCubit>().refreshToken(refreshToken);
        ref.invalidateSelf();
      }
    } catch (_) {}
  }

  @override
  Future<String> build() async {
    final subscription = sl<EntryPointCubit>().stream.listen((state) {
      _setToken(CommonProperties.token);
    });
    ref.onDispose(subscription.cancel);
    await sl<EntryPointCubit>().checkifTokenExpired();
    return Future.value(CommonProperties.token);
  }

  void _setToken(String token) {
    state = AsyncData(token);
  }
}
