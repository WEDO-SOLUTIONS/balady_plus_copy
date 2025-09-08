import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sheetify/sheetify.dart';
import 'package:shimmer/shimmer.dart';

class NationalFlag extends StatelessWidget {
  final VoidCallback? onTap;

  static const _flagImageAssetPath = 'assets/images/saudi_national_flag.png';

  const NationalFlag({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) => MultiStateSheetBuilder<ThreeStateSheet>(
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
          onTap: onTap,
          child: Align(
            alignment: AlignmentDirectional.bottomStart,
            child: Padding(
              padding: const EdgeInsetsDirectional.only(start: Spacing.$6x, bottom: Spacing.$4x),
              child: Stack(
                children: [
                  Image.asset(
                    _flagImageAssetPath,
                    width: 97.8,
                  ),
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
                      child: Image.asset(
                        _flagImageAssetPath,
                        width: 97.8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
