import 'dart:async';

import 'package:balady_plus/app/core/utils/balady_route_observer.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/shared/ui/loading/loading_overlay.dart';
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

  /// Waits out the cold-start auth-session-restore window (`AuthenticationBloc` still
  /// `AuthenticationUnknownState`) before we trust `CommonProperties.isLoggedIn`, showing a
  /// progress overlay instead of racing straight to the login screen. Bounded by
  /// `waitForAuthSessionReady`'s own timeout, so this can't hang forever.
  Future<void> _waitForSessionReady(BuildContext context) async {
    try {
      await LoadingOverlay.of(context).makeCall(CommonProperties.waitForAuthSessionReady);
    } catch (_) {
      // No LoadingOverlay ancestor mounted yet — proceed with best-effort state.
    }
  }

  Future<void> authOrOpen(
    BuildContext context, {
    FutureOr<void> Function()? callback,
  }) async {
    if (!state) {
      if (context.mounted) {
        await _waitForSessionReady(context);
        state = CommonProperties.isLoggedIn;
      }
    }

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

      await _waitForSessionReady(context);
      state = CommonProperties.isLoggedIn;
    }

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
          unawaited(runCallback());
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
