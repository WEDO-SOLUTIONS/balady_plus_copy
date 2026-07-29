import 'package:balady_uikit/balady_uikit.dart' show RadiusBorder, Spacing;
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/weather/weather_type_ext.dart';
import 'package:mapness/features/weather/provider/weather_map_controller.dart';
import 'package:mapness/shared/utils/text_utils/arabic_numerals.dart';
import 'package:mapness/widgets/landing/compass_control.dart';
import 'package:mapness/widgets/landing/follow_control.dart';
import 'package:mapness/widgets/weather/weather_state_icon.dart';
import 'package:sheetify/sheetify.dart';

class WeatherControls extends ConsumerStatefulWidget {
  final MultiStateSheetController<ThreeStateSheet> bottomSheetController;

  const WeatherControls({required this.bottomSheetController, super.key});

  @override
  ConsumerState<WeatherControls> createState() => _WeatherControlsState();
}

class _WeatherControlsState extends ConsumerState<WeatherControls> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.bottomSheetController.addListener(() {
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) => Visibility(
    visible: widget.bottomSheetController.state != ThreeStateSheet.expanded,
    child: SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Spacing.$3x,
          vertical: Spacing.$3x,
        ).copyWith(bottom: Spacing.$4x),
        child: Row(
          children: [
            const Column(children: [Spacer(), Legend()]),
            const Spacer(),
            Column(
              children: [
                const WeatherStateIcon(),
                Spacing.$2x.heightBox,
                const Spacer(),
                Spacing.$2x.heightBox,
                const CompassControl(),
                Spacing.$2x.heightBox,
                const FollowControl(),
                Spacing.$2x.heightBox,
              ],
            ),
          ],
        ),
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
          child: Text(context.digits(measureUnit), style: style),
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
            child: Column(children: measures.map((e) => Text(context.digits(e), style: style)).toList()),
          ),
        ),
      ],
    );
  }
}
