import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';

class EtaRouteLine extends StatelessWidget {
  /// progress is a value between 0 and 1
  final double progress;
  final Widget image;

  static const imgSize = 32.0;

  const EtaRouteLine({required this.progress, required this.image, super.key});

  @override
  Widget build(BuildContext context) {
    final prog = progress.clamp(0.06, 1.0);
    final imgPosition = prog > 0.8 ? imgSize : (imgSize / 2);
    return LayoutBuilder(
      builder: (context, constraints) => SizedBox(
        height: imgSize,
        width: double.infinity,
        child: Stack(
          alignment: AlignmentDirectional.centerStart,
          children: [
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(RadiusBorder.full),
              ),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Container(
                  height: 8,
                  width: constraints.maxWidth * prog,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xffFFFFFF),
                        Color(0xff2AB3A9),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(RadiusBorder.full),
                  ),
                ),
              ),
            ),
            Positioned.directional(
              textDirection: Directionality.of(context),
              start: constraints.maxWidth * prog - imgPosition,
              child: SizedBox(
                height: imgSize,
                width: imgSize,
                child: image,
              ),
            )
          ],
        ),
      ),
    );
  }
}
