import 'package:balady_uikit/balady_uikit.dart' show RadiusBorder, Spacing;
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/weather/weather_type_ext.dart';
import 'package:mapness/features/weather/provider/weather_map_controller.dart';
import 'package:mapness/shared/ui/map_controls/map_controls_column.dart';
import 'package:mapness/widgets/landing/compass_control.dart';
import 'package:mapness/widgets/landing/follow_control.dart';
import 'package:mapness/widgets/weather/weather_state_icon.dart';

/// Map controls above the weather sheet.
///
/// Independent of the sheet position: the sheet fades them out via its outside opacity and gives them the space
/// left above it, where [MapControlsColumn] drops what no longer fits instead of overflowing.
class WeatherControls extends StatelessWidget {
  const WeatherControls({super.key});

  @override
  Widget build(BuildContext context) => const SafeArea(
    bottom: false,
    child: Padding(
      padding: EdgeInsets.fromLTRB(Spacing.$3x, Spacing.$3x, Spacing.$3x, Spacing.$4x),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MapControlsColumn(
            children: [MapControlsItem(priority: 50, slot: MapControlsSlot.bottom, child: Legend())],
          ),
          Spacer(),
          MapControlsColumn(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              MapControlsItem(priority: 80, child: WeatherStateIcon()),
              MapControlsItem(priority: 70, slot: MapControlsSlot.bottom, child: CompassControl()),
              MapControlsItem(priority: 100, slot: MapControlsSlot.bottom, child: FollowControl()),
            ],
          ),
        ],
      ),
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
    final style = context.textStyle.caption.copyWith(color: context.colors.foregroundDefault);
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          width: 30,
          height: 22,
          decoration: BoxDecoration(
            color: context.colors.backgroundSurface1,
            borderRadius: const BorderRadius.only(
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
            child: Column(children: measures.map((e) => Text(e, style: style)).toList()),
          ),
        ),
      ],
    );
  }
}
