import 'dart:math';

import 'package:balady_uikit/colors/non_theme_colors.dart';
import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/pages/kiblah/providers/kaaba_bearing.dart';
import 'package:mapness/pages/kiblah/providers/kaaba_haptics.dart';
import 'package:mapness/pages/kiblah/ui/radar_widget.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/compass.dart';
import 'package:mapness/shared/ui/gradient_stroke.dart';

import 'package:mapness/pages/kiblah/providers/fake_compass.dart';

class KiblahCompass extends ConsumerWidget {
  const KiblahCompass({
    super.key,
  });

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
              padding: const EdgeInsets.all(37),
              child: CustomPaint(
                painter: GradientStroke(
                  gradient: LinearGradient(
                    begin: const Alignment(1.1, 0.06),
                    end: const Alignment(-0.12, 1),
                    //TODO(someone): move colors to constants
                    colors: correct
                        ? const [
                            NonThemeColor.color3,
                            NonThemeColor.color3,
                            NonThemeColor.color3,
                          ]
                        : [
                            context.color.stroke_accent,
                            NonThemeColor.color67,
                            context.color.stroke_accent,
                          ],
                    stops: const [0, 0.48, 1],
                  ),
                  strokeWidth: 2,
                  borderRadius: 1000,
                ),
                size: Size.infinite,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(67),
              child: Center(
                child: RadarWidget(
                  backgroundColor: correct
                      ? NonThemeColor.color3.withOpacity(0.2)
                      : context.color.text_and_icons_base_primary
                          .withOpacity(0.2),
                  radarColor: correct
                      ? NonThemeColor.color3.withOpacity(0.7)
                      : context.color.text_and_icons_base_primary
                          .withOpacity(0.7),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(121),
              child: Image.asset(
                'assets/images/kiblah_arrow.png',
                height: 132,
                width: 132,
                package: PackageConfig.packageName,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(22.5),
              child: isReady
                  ? Align(
                      alignment: Alignment(
                        cos(rad(kaabaBearing - userBearing)),
                        sin(rad(kaabaBearing - userBearing)),
                      ),
                      child: _KaabaIcon(
                        isCorrect: correct,
                      ),
                    )
                  : _FakeKaabIcon(),
            ),
            if (isReady) ...[
              Padding(
                padding: const EdgeInsets.all(7),
                child: Align(
                  alignment: Alignment(
                    cos(rad(-userBearing)),
                    sin(rad(-userBearing)),
                  ),
                  child: Text(
                    context.l10n.north,
                    style: Theme.of(context)
                        .extension<ThemeTextStyles>()!
                        .textXS
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(7),
                child: Align(
                  alignment: Alignment(
                    cos(rad(90 - userBearing)),
                    sin(rad(90 - userBearing)),
                  ),
                  child: Text(
                    context.l10n.east,
                    style: Theme.of(context)
                        .extension<ThemeTextStyles>()!
                        .textXS
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(7),
                child: Align(
                  alignment: Alignment(
                    cos(rad(180 - userBearing)),
                    sin(rad(180 - userBearing)),
                  ),
                  child: Text(
                    context.l10n.south,
                    style: Theme.of(context)
                        .extension<ThemeTextStyles>()!
                        .textXS
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(7),
                child: Align(
                  alignment: Alignment(
                    cos(rad(270 - userBearing)),
                    sin(rad(270 - userBearing)),
                  ),
                  child: Text(
                    context.l10n.west,
                    style: Theme.of(context)
                        .extension<ThemeTextStyles>()!
                        .textXS
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _KaabaIcon extends StatelessWidget {

  const _KaabaIcon({required this.isCorrect});
  final bool isCorrect;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: isCorrect ? NonThemeColor.color3 : context.color.stroke_accent,
          borderRadius: BorderRadius.circular(16),
        ),
        width: 32,
        height: 32,
        child: Center(
          child: SvgPicture.asset(
            'assets/icons/svg/ic_kiblah.svg',
            height: 16,
            width: 16,
            package: PackageConfig.packageName,
          ),
        ),
      );
}

class _FakeKaabIcon extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fakeUserBearing = ref.watch(fakeCompassProvider);

    return Align(
      alignment: Alignment(
        cos(KiblahCompass.rad(0 - fakeUserBearing)),
        sin(KiblahCompass.rad(0 - fakeUserBearing)),
      ),
      child: const _KaabaIcon(
        isCorrect: false,
      ),
    );
  }
}
