import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapness/_features/poi_card/domain/model/poi_bottom_sheet_config.dart';

class PoiBackground extends StatelessWidget {
  final ValueListenable<double> bottomSheetAspectRatio;
  const PoiBackground({required this.bottomSheetAspectRatio, super.key});

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
        valueListenable: bottomSheetAspectRatio,
        builder: (_, aspectRatio, __) {
          var opacity = aspectRatio;
          if (aspectRatio <= PoiBottomSheetConfig.lowerAspectRatio) {
            opacity = 0.0;
          }
          if (aspectRatio > PoiBottomSheetConfig.middleAspectRatio &&
              aspectRatio <= PoiBottomSheetConfig.middleAspectRatio + PoiBottomSheetConfig.fadeAspectRatioDelta) {
            opacity = (1 - aspectRatio - PoiBottomSheetConfig.fadeAspectRatioDelta) /
                PoiBottomSheetConfig.fadeAspectRatioDelta *
                PoiBottomSheetConfig.middleAspectRatio;
          }
          if (aspectRatio > PoiBottomSheetConfig.middleAspectRatio + PoiBottomSheetConfig.fadeAspectRatioDelta) {
            opacity = 0.0;
          }

          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: opacity > 0.5 ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: IgnorePointer(
                child: ColoredBox(
                  color: Color.fromRGBO(20, 20, 20, opacity),
                ),
              ),
            ),
          );
        },
      );
}
