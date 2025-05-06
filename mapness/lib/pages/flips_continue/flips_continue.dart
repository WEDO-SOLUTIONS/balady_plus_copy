import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

@RoutePage()
class FlipsContinuePage extends StatefulWidget {
  const FlipsContinuePage({super.key});

  @override
  State<FlipsContinuePage> createState() => _FlipsContinuePageState();
}

class _FlipsContinuePageState extends State<FlipsContinuePage> {
  final _flipsDuration = const Duration(milliseconds: 1000);
  final _popDuration = const Duration(milliseconds: 400);
  final _pathImage = 'packages/mapness/assets/images/ic_flips_continue.png';

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
        context.router.popForced();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Material(
        child: ColoredBox(
          color: context.colorsV3.backgroundSurface4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(_pathImage),
              Spacing.$4x.heightBox,
              Text(
                context.l10n.theScreenFlipsContinue,
                style: context.textStyleV3.h3SemiBold,
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      );
}
