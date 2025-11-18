import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:sheetify/sheetify.dart';

class WRCLogo extends StatefulWidget {
  final VoidCallback? onTap;

  const WRCLogo({
    super.key,
    this.onTap,
  });

  @override
  State<WRCLogo> createState() => _WRCLogoState();
}

class _WRCLogoState extends State<WRCLogo> with SingleTickerProviderStateMixin {
  late final AnimationController scaleController = AnimationController(
    vsync: this,
    duration: Durations.medium1,
  );

  @override
  Widget build(BuildContext context) {
    final cityscapeLogo = Transform.translate(
      offset: const Offset(Spacing.$6x, -(Spacing.$4x + Spacing.$0_5x)),
      // image size are empirically chosen
      child: Assets.images.wrcDashboard.image(width: 109, height: 90),
    );

    return MultiStateSheetBuilder<ThreeStateSheet>(
      defaultState: ThreeStateSheet.hidden,
      builder: (context, state, interpolation, child) {
        final delta = state == ThreeStateSheet.hidden ? clampDouble(interpolation * 3, 0, 1) : 1.0;
        return IgnorePointer(
          ignoring: state == ThreeStateSheet.hidden,
          child: Align(
            heightFactor: delta,
            alignment: Alignment.topCenter,
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: () {
          widget.onTap?.call();
          scaleController
            ..value = 0
            ..animateTo(1, curve: Curves.easeOut);
        },
        onTapDown: (_) => scaleController
          ..value = 0
          ..animateTo(.4, curve: Curves.easeOut),
        onLongPressEnd: (details) {
          scaleController.animateTo(1, curve: Curves.easeOut);
          widget.onTap?.call();
        },
        child: Align(
          alignment: Alignment.bottomLeft,
          child: ScaleTransition(
            scale: Tween<double>(begin: .9, end: 1.0).animate(scaleController),
            child: cityscapeLogo,
          ),
        ),
      ),
    );
  }
}
