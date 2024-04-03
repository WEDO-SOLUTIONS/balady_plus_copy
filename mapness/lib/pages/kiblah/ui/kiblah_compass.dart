import 'dart:math';

import 'package:balady_uikit/core/colors/non_theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/pages/kiblah/providers/kaaba_bearing.dart';
import 'package:mapness/pages/kiblah/providers/kaaba_haptics.dart';
import 'package:mapness/pages/kiblah/ui/widgets/build_direction_text.dart';
import 'package:mapness/pages/kiblah/ui/widgets/center_compass_widget.dart';
import 'package:mapness/pages/kiblah/ui/widgets/fake_kaab_icon.dart';
import 'package:mapness/pages/kiblah/ui/widgets/kaaba_icon.dart';
import 'package:mapness/pages/kiblah/ui/widgets/radar_widget.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/compass.dart';
import 'package:mapness/shared/ui/painter_stroke.dart';

class KiblahCompass extends ConsumerWidget {
  const KiblahCompass({Key? key}) : super(key: key);

  static double rad(double degree) => pi * degree / 180 - 0.5 * pi;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kaabaBearing = ref.watch(kaabaBearingProvider);
    final userBearing = ref.watch(compassProvider);
    final isKaabaDirection = ref.watch(kaabaHapticsProvider);
    final isReady = kaabaBearing != null && userBearing != null;
    final correct = isReady && isKaabaDirection;

    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(50),
              child: CustomPaint(
                painter: PainterStroke(
                    color: correct ? context.color.surfaceStatusPositive : context.color.surfaceStatusAccent,
                    strokeWidth: 2,
                    borderRadius: 1000,
                  ),
                  size: Size.infinite,
                  child: Padding(
                    padding: const EdgeInsets.all(22),
                    child: Stack(
                      children: [
                        // RadarWidget(
                        //   backgroundColor: correct
                        //       ? NonThemeColor.color3.withOpacity(0.2)
                        //       : context.color.textAndIconsBasePrimary.withOpacity(0.2),
                        //   radarColor: correct
                        //       ? NonThemeColor.color3.withOpacity(0.7)
                        //       : context.color.textAndIconsBasePrimary.withOpacity(0.7),
                        // ),
                        CenterCompassWidget(
                          backgroundColor: correct
                              ? context.color.surfaceStatusPositive.withOpacity(0.2)
                              : context.color.surfaceStatusAccent.withOpacity(0.2),
                        ),
                      ],
                    ),
                  ),
                ),
            ),
            Padding(
              padding: const EdgeInsets.all(36),
              child: isReady
                  ? Align(
                      alignment: Alignment(
                        cos(KiblahCompass.rad(kaabaBearing - userBearing)),
                        sin(KiblahCompass.rad(kaabaBearing - userBearing)),
                      ),
                      child: KaabaIcon(
                        isCorrect: correct,
                      ),
                    )
                  : const FakeKaabIcon(),
            ),
            if (isReady) ...[
              BuildDirectionText(
                  title: context.l10n.north, bearing: userBearing),
              BuildDirectionText(
                  title: context.l10n.east, bearing: userBearing - 90),
              BuildDirectionText(
                  title: context.l10n.south, bearing: userBearing - 180),
              BuildDirectionText(
                  title: context.l10n.west, bearing: userBearing - 270),
            ],
          ],
        ),
      ),
    );
  }
}
