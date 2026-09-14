import 'dart:async';

import 'package:balady_plus/app/core/utils/balady_route_observer.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/shared/utils/detach.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_methods.g.dart';

// BALADY-3730: keepAlive is required. Nothing in the app watches this
// provider — every consumer does `ref.read(...).authAndOpen(...)` — so as
// autoDispose the notifier is disposed while the user is still typing on
// the login screen. When the post-login stream event finally fires,
// `state = ...` inside runCallback throws on the dead notifier BEFORE the
// callback runs, and the tap's follow-up action is silently lost.
@Riverpod(keepAlive: true)
class AuthMethods extends _$AuthMethods {
  static StreamSubscription<EntryPointState>? _authSubscription;

  Timer? _loginScreenPoppedSubscription;
  void _initializeLoginScreenPoppedSubscription({VoidCallback? onPopped}) {
    _loginScreenPoppedSubscription?.cancel();
    _loginScreenPoppedSubscription = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (BaladyRouteObserver.loginScreenPopped) {
        _authSubscription?.cancel();
        _authSubscription = null;
        _loginScreenPoppedSubscription?.cancel();
        _loginScreenPoppedSubscription = null;
        onPopped?.call();
      }
    });
  }

  @override
  bool build() => CommonProperties.isLoggedIn;

  Future<void> authOrOpen(
    BuildContext context, {
    FutureOr<void> Function()? callback,
  }) async {
    if (!state) {
      if (context.mounted) {
        await ref.read(authProvider.notifier).doAuth();
        state = CommonProperties.isLoggedIn;
      }
    }

    if (state) {
      await callback?.call();
    }
  }

  Future<void> authAndOpen(
    BuildContext context, {
    FutureOr<void> Function()? callback,
  }) async {
    await _authSubscription?.cancel();
    _loginScreenPoppedSubscription?.cancel();
    // BALADY-3730: the popped flag is sticky from any previous login flow.
    // Without this reset the 1-second poll below sees the stale `true`,
    // cancels the userStateStream subscription while the user is still on
    // the login form, and the callback never runs.
    BaladyRouteObserver.resetLoginScreenPopped();
    if (!state) {
      if (!context.mounted) {
        return;
      }

      final completion = Completer<void>();
      var callbackStarted = false;
      Future<void> runCallback() async {
        if (callbackStarted) {
          return;
        }
        callbackStarted = true;
        try {
          // Inside try: if the notifier is disposed despite keepAlive
          // (container teardown), the state write must not prevent the
          // subscriptions below from being cleaned up.
          state = CommonProperties.isLoggedIn;
          await callback?.call();
        } finally {
          await _authSubscription?.cancel();
          _authSubscription = null;
          _loginScreenPoppedSubscription?.cancel();
          _loginScreenPoppedSubscription = null;
          if (!completion.isCompleted) {
            completion.complete();
          }
        }
      }

      await ref.read(authProvider.notifier).doAuth();
      if (!context.mounted) {
        return;
      }

      if (CommonProperties.isLoggedIn) {
        await runCallback();
        return;
      }

      _authSubscription = CommonProperties.userStateStream.listen((event) {
        if (event.userInfo != null) {
          detach(runCallback(), tag: 'authMethods.runCallback');
        }
      });
      _initializeLoginScreenPoppedSubscription(
        onPopped: () {
          if (!completion.isCompleted) {
            completion.complete();
          }
        },
      );
      await completion.future;
    } else {
      await callback?.call();
    }
  }
}
