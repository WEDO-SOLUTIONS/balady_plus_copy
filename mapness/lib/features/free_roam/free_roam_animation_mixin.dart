import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/free_roam/free_roam_start_state.dart';
import 'package:mapness/features/balady_analytics/events/navigation_events.dart';
import 'package:mapness/features/free_roam/free_roam_starter.dart';

mixin FreeRoamAnimationMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  double animationProgress = 0.0;

  late AnimationController autostartAnimationController;

  void initializeFreeRoam(TickerProvider vsync, {Duration? duration}) {
    autostartAnimationController = AnimationController(vsync: vsync, duration: duration ?? const Duration(seconds: 10));
    autostartAnimationController.addListener(_update);

    final freeRoamState = ref.read(freeRoamStarterProvider);
    if (freeRoamState.canStart &&
        freeRoamState.status is! AnimatingStatus &&
        !autostartAnimationController.isAnimating) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(freeRoamStarterProvider.notifier).startAnimation();
      });
    }
  }

  void listerForStart() {
    ref.listen<FreeRoamStartState>(freeRoamStarterProvider, _startAnimation);
  }

  void disposeAnimationController() {
    autostartAnimationController
      ..removeListener(_update)
      ..dispose();
  }

  void _startAnimation(FreeRoamStartState? prev, FreeRoamStartState next) {
    if (next.canStart && next.status is! AnimatingStatus && !autostartAnimationController.isAnimating) {
      autostartAnimationController.forward();
      ref.read(freeRoamStarterProvider.notifier).startAnimation();
    } else if (next.canStart && next.status is PausedStatus && autostartAnimationController.isAnimating) {
      autostartAnimationController.stop(canceled: false);
    } else if (!next.canStart && next.status is CompletedStatus && autostartAnimationController.isAnimating ||
        autostartAnimationController.value > 0) {
      autostartAnimationController.reset();
    }
  }

  void _update() {
    if (autostartAnimationController.status == AnimationStatus.completed) {
      BaladyNavigationEvents.trackFreeRoamStarted(BaladyFreeRoamSource.autostart);
      context.router.push(const FreeRoamRoute());
      ref.read(freeRoamStarterProvider.notifier).setShown();
      return;
    }

    if (mounted) {
      setState(() {
        animationProgress = autostartAnimationController.value;
      });
    }
  }
}
