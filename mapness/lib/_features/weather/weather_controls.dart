import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/landing/widgets/compass_control.dart';
import 'package:mapness/_features/landing/widgets/follow_control.dart';
import 'package:mapness/_features/landing/widgets/zoom_control.dart';
import 'package:mapness/_features/weather/domain/enum/weather_enum.dart';
import 'package:mapness/_features/weather/provider/weather_map_controller.dart';
import 'package:mapness/_features/weather/provider/weather_map_controls.dart';
import 'package:mapness/_features/weather/widgets/weather_state_icon.dart';

class WeatherControls extends ConsumerWidget {
  const WeatherControls({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapControls = ref.watch(weatherMapControlsProvider);

    return SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 12,
                top: 12,
                right: 12,
                bottom: 16,
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),
                      AnimatedOpacity(
                        opacity: mapControls.controlsVisible ? 1 : 0,
                        duration: const Duration(milliseconds: 150),
                        child: const Legend(),
                      ),
                      SizedBox(
                        height: mapControls.extent,
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WeatherStateIcon(),
                      Spacer(),
                      ZoomControl(),
                      Spacer(),
                      CompassControl(),
                      SizedBox(
                        height: 8,
                      ),
                      FollowControl(),
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
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Text(measureUnit, style: style),
        ),
        Container(
          width: 30,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
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
            padding: const EdgeInsets.only(bottom: 4, top: 4),
            child: Column(
              children: measures.map((e) => Text(e, style: style)).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
