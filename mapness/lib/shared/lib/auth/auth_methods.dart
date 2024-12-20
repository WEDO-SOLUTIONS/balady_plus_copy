import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_methods.g.dart';

@riverpod
class AuthMethods extends _$AuthMethods {
  static StreamSubscription? _authSubscription;

  @override
  bool build() {
    ref.onDispose(() {
      _authSubscription?.cancel();
    });

    return CommonProperties.isLoggedIn;
  }

  Future<void> authOrOpen(
    BuildContext context, {
    VoidCallback? callback,
  }) async {
    await cancelAuthSubscription();
    if (!state) {
      if (context.mounted) {
        await context.router.push(const SigninRoute());
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
    if (!state) {
      if (context.mounted) {
        await context.router.push(const SigninRoute());
      }
      _authSubscription = CommonProperties.userStateStream.listen((event) {
        if (event.userInfo != null) {
          callback?.call();
          state = CommonProperties.isLoggedIn;
          cancelAuthSubscription();
        }
      });
    } else {
      callback?.call();
    }
  }

  Future<void> cancelAuthSubscription() async {
    await _authSubscription?.cancel();
  }
}
