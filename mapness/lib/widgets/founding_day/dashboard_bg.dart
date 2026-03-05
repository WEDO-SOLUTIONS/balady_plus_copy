import 'package:flutter/material.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';

class FoundingDayBackground extends StatelessWidget {
  const FoundingDayBackground({super.key});

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 450,
        child: Stack(
          children: [
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0x00DFC8AA),
                      Color(0xFFDFC8AA),
                      Color(0xFFDFC8AA),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    Color(0x00C4A47C),
                    Color(0xFFC4A47C),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ).createShader(bounds),
                child: Assets.images.foundationDayBgPattern.svg(fit: BoxFit.fitWidth),
              ),
            ),
          ],
        ),
      );
}
