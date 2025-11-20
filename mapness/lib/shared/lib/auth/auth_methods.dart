import 'dart:async';

import 'package:balady_plus/app/core/utils/balady_route_observer.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_methods.g.dart';

@riverpod
class AuthMethods extends _$AuthMethods {
  static StreamSubscription<EntryPointState>? _authSubscription;

  Timer? _loginScreenPoppedSubscription;
  void _initializeLoginScreenPoppedSubscription() {
    _loginScreenPoppedSubscription?.cancel();
    _loginScreenPoppedSubscription = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (BaladyRouteObserver.loginScreenPopped) {
        _authSubscription?.cancel();
        _authSubscription = null;
        _loginScreenPoppedSubscription?.cancel();
        _loginScreenPoppedSubscription = null;
      }
    });
  }

  @override
  bool build() => CommonProperties.isLoggedIn;

  Future<void> authOrOpen(
    BuildContext context, {
    VoidCallback? callback,
  }) async {
    if (!state) {
      if (context.mounted) {
        await ref.read(authProvider.notifier).doAuth();
        state = CommonProperties.isLoggedIn;
      }
    }

    if (state) {
      callback?.call();
    }
  }

  Future<void> authAndOpen(
    BuildContext context, {
    VoidCallback? callback,
  }) async {
    await _authSubscription?.cancel();
    _loginScreenPoppedSubscription?.cancel();
    if (!state) {
      if (context.mounted) {
        Metrics.logEventAdvanced(
          MetricsConstants.loginKeys.signIn,
          group: MetricsConstants.loginTag,
          action: MetricAction.tap.toString(),
        );

        await ref.read(authProvider.notifier).doAuth();
        if (!context.mounted) {
          return;
        }
      }

      _authSubscription = CommonProperties.userStateStream.listen((event) {
        if (event.userInfo != null) {
          callback?.call();
          state = CommonProperties.isLoggedIn;
          _authSubscription?.cancel();
        }
      });
      _initializeLoginScreenPoppedSubscription();
    } else {
      callback?.call();
    }
  }
}
