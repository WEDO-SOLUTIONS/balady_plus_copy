import 'package:balady_uikit/balady_uikit.dart'
    show RadiusBorder, Spacing, StatefulBottomSheetController, ThreeStateBottomSheet;
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/weather/weather_type_ext.dart';
import 'package:mapness/features/weather/provider/weather_map_controller.dart';
import 'package:mapness/widgets/landing/compass_control.dart';
import 'package:mapness/widgets/landing/follow_control.dart';
import 'package:mapness/widgets/landing/zoom_control.dart';
import 'package:mapness/widgets/weather/weather_card_header.dart';
import 'package:mapness/widgets/weather/weather_state_icon.dart';

class WeatherControls extends ConsumerWidget {
  final StatefulBottomSheetController<ThreeStateBottomSheet> bottomSheetController;

  const WeatherControls({
    required this.bottomSheetController,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.$3x,
                  vertical: Spacing.$3x,
                ).copyWith(bottom: Spacing.$4x),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        const Legend(),
                        SizedBox(height: weatherHeaderSize),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const WeatherStateIcon(),
                        const Spacer(),
                        const ZoomControl(),
                        const Spacer(),
                        const CompassControl(),
                        Spacing.$2x.heightBox,
                        const FollowControl(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}

class Legend extends ConsumerWidget {
  const Legend({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherMapState = ref.watch(weatherMapControllerProvider());

    final measures = weatherMapState.type.measures();
    final measureUnit = weatherMapState.type.measureUnit();
    final style = context.textStyle.caption.copyWith(color: context.color.textAndIconsBasePrimary);
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          width: 30,
          height: 22,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(RadiusBorder.m),
              topRight: Radius.circular(RadiusBorder.m),
            ),
          ),
          child: Text(measureUnit, style: style),
        ),
        Container(
          width: 30,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(RadiusBorder.m),
              bottomRight: Radius.circular(RadiusBorder.m),
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xffAA354D),
                Color(0xffF546CD),
                Color(0xffF54681),
                Color(0xffF54832),
                Color(0xffFD7233),
                Color(0xffF9A432),
                Color(0xffFED43D),
                Color(0xffFFF832),
                Color(0xffA9F91D),
                Color(0xff94D959),
                Color(0xff34D36D),
                Color(0xff33F196),
                Color(0xff99E6F9),
                Color(0xff6AC1F8),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: Spacing.$1x),
            child: Column(
              children: measures.map((e) => Text(e, style: style)).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
