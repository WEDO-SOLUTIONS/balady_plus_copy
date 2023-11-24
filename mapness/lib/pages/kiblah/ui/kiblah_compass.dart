import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/pages/kiblah/providers/kaaba_bearing.dart';
import 'package:mapness/pages/kiblah/ui/radar_widget.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/config/package_fonts.dart';
import 'package:mapness/shared/providers/compass.dart';
import 'package:mapness/shared/ui/gradient_stroke.dart';

class KiblahCompass extends StatelessWidget {
  const KiblahCompass({
    super.key,
  });

  double _rad(double degree) => pi * (degree) / 180 - 0.5 * pi;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(37),
              child: Consumer(
                builder: (context, ref, child) {
                  final kaabaBearing = ref.watch(kaabaBearingProvider);
                  final userBearing = ref.watch(compassProvider);
                  final correct =
                      (kaabaBearing.floor() - userBearing.floor()).abs() <= 5;

                  return CustomPaint(
                    painter: GradientStroke(
                      gradient: LinearGradient(
                        begin: const Alignment(1.1, 0.06),
                        end: const Alignment(-0.12, 1),
                        colors: correct
                            ? [
                                const Color(0xFF52B374),
                                const Color(0xFF52B374),
                                const Color(0xFF52B374),
                              ]
                            : [
                                const Color(0xFF4CA5B4),
                                const Color(0xFFC1EBF2),
                                const Color(0xFF4CA5B4),
                              ],
                        stops: const [0, 0.48, 1],
                      ),
                      strokeWidth: 2,
                      borderRadius: 1000,
                    ),
                    size: Size.infinite,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(67),
              child: Center(
                child: Consumer(
                  builder: (context, ref, child) {
                    final kaabaBearing = ref.watch(kaabaBearingProvider);
                    final userBearing = ref.watch(compassProvider);
                    final correct =
                        (kaabaBearing.floor() - userBearing.floor()).abs() <= 5;

                    return RadarWidget(
                      backgroundColor: correct
                          ? const Color(0xFF52B374).withOpacity(0.2)
                          : const Color(0xFF1E2A36).withOpacity(0.2),
                      radarColor: correct
                          ? const Color(0xFF52B374).withOpacity(0.7)
                          : const Color(0xFF1E2A36).withOpacity(0.7),
                    );
                  },
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
              child: Consumer(
                builder: (context, ref, child) {
                  final kaabaBearing = ref.watch(kaabaBearingProvider);
                  final userBearing = ref.watch(compassProvider);
                  final correct =
                      (kaabaBearing.floor() - userBearing.floor()).abs() <= 5;

                  return Align(
                    alignment: Alignment(
                      cos(_rad(kaabaBearing - userBearing)),
                      sin(_rad(kaabaBearing - userBearing)),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: correct
                            ? const Color(0xFF52B374)
                            : const Color(0xFF4CA5B4),
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
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(7),
              child: Consumer(
                builder: (context, ref, child) {
                  final userBearing = ref.watch(compassProvider);

                  return Align(
                    alignment: Alignment(
                      cos(_rad(-userBearing)),
                      sin(_rad(-userBearing)),
                    ),
                    child: child!,
                  );
                },
                child: Text(
                  "شمال",
                  style: PackageFonts.frutigerArabic(
                    fontSize: 12,
                    height: 1.5,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(7),
              child: Consumer(
                builder: (context, ref, child) {
                  final userBearing = ref.watch(compassProvider);

                  return Align(
                    alignment: Alignment(
                      cos(_rad(90 - userBearing)),
                      sin(_rad(90 - userBearing)),
                    ),
                    child: child!,
                  );
                },
                child: Text(
                  "شرق",
                  style: PackageFonts.frutigerArabic(
                    fontSize: 12,
                    height: 1.5,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(7),
              child: Consumer(
                builder: (context, ref, child) {
                  final userBearing = ref.watch(compassProvider);

                  return Align(
                      alignment: Alignment(
                        cos(_rad(180 - userBearing)),
                        sin(_rad(180 - userBearing)),
                      ),
                      child: child!);
                },
                child: Text(
                  "جنوب",
                  style: PackageFonts.frutigerArabic(
                    fontSize: 12,
                    height: 1.5,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(7),
              child: Consumer(
                builder: (context, ref, child) {
                  final userBearing = ref.watch(compassProvider);

                  return Align(
                    alignment: Alignment(
                      cos(_rad(270 - userBearing)),
                      sin(_rad(270 - userBearing)),
                    ),
                    child: child!,
                  );
                },
                child: Text(
                  "غرب",
                  style: PackageFonts.frutigerArabic(
                    fontSize: 12,
                    height: 1.5,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
