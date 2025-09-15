import 'dart:math';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/saudi_national_day/saudi_national_day.dart';
import 'package:mapness/pages/kiblah/providers/kaaba_bearing.dart';
import 'package:mapness/pages/kiblah/providers/kaaba_haptics.dart';
import 'package:mapness/pages/kiblah/ui/radar_widget.dart';
import 'package:mapness/pages/kiblah/ui/widgets/center_compass_widget.dart';
import 'package:mapness/pages/kiblah/ui/widgets/direction_text.dart';
import 'package:mapness/pages/kiblah/ui/widgets/fake_kaab_icon.dart';
import 'package:mapness/pages/kiblah/ui/widgets/kaaba_icon.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:mapness/shared/providers/compass.dart';

class KiblahCompass extends ConsumerWidget {
  const KiblahCompass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const double strokeWidth = 2.0;
    const double compassBackgroundOpacity = 0.2;
    const double radarOpacity = 0.7;

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
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: correct ? context.color.surfaceStatusPositive : context.colors.accentDefault,
                    width: strokeWidth,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Stack(
                    children: [
                      RadarWidget(
                        backgroundColor: Colors.transparent,
                        radarColor: correct
                            ? NonThemeColor.color3.withOpacity(radarOpacity)
                            : SaudiNationalDay.isNow()
                                ? context.colors.accentContainerDefault.withOpacity(0.9)
                                : context.colors.foregroundDefault.withOpacity(0.9),
                      ),
                      CenterCompassWidget(
                        backgroundColor: correct
                            ? context.staticColor.surfaceStatusPositive.withOpacity(compassBackgroundOpacity)
                            : context.colors.accentDefault.withOpacity(compassBackgroundOpacity),
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
                        cos(CommonFunctions.convertDegreesToRadiansAndShift(kaabaBearing - userBearing)),
                        sin(CommonFunctions.convertDegreesToRadiansAndShift(kaabaBearing - userBearing)),
                      ),
                      child: KaabaIcon(isCorrect: correct),
                    )
                  : const FakeKaabIcon(),
            ),
            if (isReady) ...[
              DirectionText(title: context.l10n.north, bearing: -userBearing),
              DirectionText(title: context.l10n.east, bearing: 90 - userBearing),
              DirectionText(title: context.l10n.south, bearing: 180 - userBearing),
              DirectionText(title: context.l10n.west, bearing: 270 - userBearing),
            ],
          ],
        ),
      ),
    );
  }
}
