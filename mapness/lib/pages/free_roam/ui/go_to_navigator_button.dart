import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/free_roam/free_roam_start_state.dart';
import 'package:mapness/features/free_roam/free_roam_starter.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class GoToNavigatorButton extends ConsumerStatefulWidget {
  const GoToNavigatorButton({super.key});

  @override
  ConsumerState<GoToNavigatorButton> createState() => _GoToNavigatorButtonState();
}

class _GoToNavigatorButtonState extends ConsumerState<GoToNavigatorButton> with TickerProviderStateMixin {
  double progress = 0.0;

  void startAnimation(FreeRoamStartState? prev, FreeRoamStartState next) {
    print('Speed: ${next.controller}');
    if (next.canStart && next.controller == null) {
      ref.read(freeRoamStarterProvider.notifier).startAnimation(this);
      final controller = ref.read(freeRoamStarterProvider).controller;

      controller?.addListener(update);
    }
  }

  @override
  void dispose() {
    ref.read(freeRoamStarterProvider).controller?.removeListener(update);
    super.dispose();
  }

  void update() {
    setState(() {
      progress = ref.read(freeRoamStarterProvider).controller?.value ?? 0.0;
    });
    print('Speed: progress $progress');
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<FreeRoamStartState>(freeRoamStarterProvider, startAnimation);
    return LayoutBuilder(
        builder: (context, constrains) => Stack(
              children: [
                AppButton(
                  onTap: () {},
                  primaryLabel: context.l10n.goToNavigator,
                  buttonColorScheme: ButtonColorScheme.primary,
                ),
                SizedBox(
                  width: constrains.maxWidth * progress,
                  height: 56,
                  child: const ColoredBox(color: Colors.black),
                ),
              ],
            ));
  }
}
