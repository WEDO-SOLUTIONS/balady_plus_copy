import 'dart:async';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:sheetify/sheetify.dart';
import 'package:shimmer/shimmer.dart';

class CityscapeLogo extends StatefulWidget {
  final VoidCallback? onTap;

  const CityscapeLogo({
    super.key,
    this.onTap,
  });

  @override
  State<CityscapeLogo> createState() => _CityscapeLogoState();
}

class _CityscapeLogoState extends State<CityscapeLogo> with SingleTickerProviderStateMixin {
  final _durationFlag = const Duration(seconds: 20);
  bool _showShimmer = false;
  Timer? _timer;

  late final AnimationController scaleController = AnimationController(
    vsync: this,
    duration: Durations.medium1,
  );

  @override
  void initState() {
    _timer = Timer.periodic(_durationFlag, (_) {
      setState(() => _showShimmer = true);

      Future.delayed(Durations.extralong4, () {
        if (mounted) {
          setState(() => _showShimmer = false);
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cityscapeLogo = Transform.translate(
      offset: const Offset(0, 25),
      child: Assets.images.cityscapeGlobal.image(width: 90),
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
          child: Padding(
            padding: const EdgeInsets.only(left: Spacing.$6x, bottom: Spacing.$1_5x),
            child: ScaleTransition(
              scale: Tween<double>(begin: .9, end: 1.0).animate(scaleController),
              child: Stack(
                children: [
                  cityscapeLogo,
                  if (_showShimmer)
                    Opacity(
                      opacity: 0.6,
                      child: Shimmer(
                        period: Durations.extralong4,
                        gradient: const LinearGradient(
                          colors: [
                            Color(0x00C5FFD6),
                            Color(0x00C5FFD6),
                            Color(0xffC5FFD6),
                            Color(0x00C5FFD6),
                            Color(0x00C5FFD6),
                          ],
                          stops: [0.0, 0.4, 0.5, 0.6, 1.0],
                        ),
                        child: cityscapeLogo,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
