import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:provider/provider.dart';

@RoutePage()
class FlipsContinuePage extends StatefulWidget {
  const FlipsContinuePage({super.key});

  @override
  State<FlipsContinuePage> createState() => _FlipsContinuePageState();
}

class _FlipsContinuePageState extends State<FlipsContinuePage> {
  final _flipsDuration = const Duration(milliseconds: 1000);
  final _popDuration = const Duration(milliseconds: 400);

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(_flipsDuration, () {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      });

      Future.delayed(_popDuration, () {
        context.router.pop();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isLight = context.read<ThemeController>().currentTheme == BaladyAppThemes.lightDGA;

    return Material(
      child: ColoredBox(
        color: context.colors.backgroundSurface4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: isLight
                  ? Assets.images.illustrationFlipContinueLight.image()
                  : Assets.images.illustrationFlipContinueDark.image(),
            ),
            Spacing.$4x.heightBox,
            Text(
              context.l10n.theScreenFlipsContinue,
              style: context.textStyles.h3SemiBold.copyWith(color: context.colors.foregroundDefault),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
