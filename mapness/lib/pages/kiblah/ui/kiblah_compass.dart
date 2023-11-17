import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/config/package_fonts.dart';
import 'package:mapness/shared/ui/gradient_stroke.dart';

class KiblahCompass extends StatefulWidget {
  const KiblahCompass({super.key});

  @override
  State<KiblahCompass> createState() => _KiblahCompassState();
}

class _KiblahCompassState extends State<KiblahCompass>
    with SingleTickerProviderStateMixin {
  late Animation<double> _angle;
  late AnimationController _controller;

  double _radians(double angle) => angle / 180 * pi - pi / 2;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 5,
      ),
    )..repeat(
        reverse: true,
      );
    final Animation<double> curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticInOut,
    );
    _angle = Tween<double>(
      begin: 0,
      end: 120,
    ).animate(curve);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
              child: CustomPaint(
                painter: GradientStroke(
                  gradient: const LinearGradient(
                    begin: Alignment(1.1, 0.06),
                    end: Alignment(-0.12, 1),
                    colors: [
                      Color(0xFF4CA5B4),
                      Color(0xFFC1EBF2),
                      Color(0xFF4CA5B4),
                    ],
                    stops: [0, 0.48, 1],
                  ),
                  strokeWidth: 2,
                  borderRadius: 1000,
                ),
                size: Size.infinite,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(67),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2A36).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(1000),
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
              child: AnimatedBuilder(
                animation: _angle,
                builder: (context, child) {
                  return Align(
                    alignment: Alignment(
                      cos(_radians(240 + _angle.value)),
                      sin(_radians(240 + _angle.value)),
                    ),
                    child: child!,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CA5B4),
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
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(7),
              child: AnimatedBuilder(
                animation: _angle,
                builder: (context, child) {
                  return Align(
                    alignment: Alignment(
                      cos(_radians(_angle.value)),
                      sin(_radians(_angle.value)),
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
              child: AnimatedBuilder(
                animation: _angle,
                builder: (context, child) {
                  return Align(
                    alignment: Alignment(
                      cos(_radians(90 + _angle.value)),
                      sin(_radians(90 + _angle.value)),
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
              child: AnimatedBuilder(
                animation: _angle,
                builder: (context, child) {
                  return Align(
                    alignment: Alignment(
                      cos(_radians(180 + _angle.value)),
                      sin(_radians(180 + _angle.value)),
                    ),
                    child: child!,
                  );
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
              child: AnimatedBuilder(
                animation: _angle,
                builder: (context, child) {
                  return Align(
                    alignment: Alignment(
                      cos(_radians(270 + _angle.value)),
                      sin(_radians(270 + _angle.value)),
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
