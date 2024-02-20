import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
// import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Temperature',
  type: WeatherLegend,
)
WeatherLegend temperatureLegend(BuildContext context) {
  return WeatherLegend(
    measureUnit: 'C',
    measures: [
      "1",
      "1",
      "1",
      "1",
      "1",
      "1",
      "1",
    ],
  );
}

class WeatherLegend extends StatelessWidget {
  final String measureUnit;
  final List<String> measures;

  const WeatherLegend({
    super.key,
    required this.measureUnit,
    required this.measures,
  });

  @override
  Widget build(BuildContext context) {
    // final weatherMapState = ref.watch(weatherMapControllerProvider());
    // var measures = weatherMapState.type.measures();
    // var measureUnit = weatherMapState.type.measureUnit();
    var style = Theme.of(context)
        .extension<ThemeTextStyles>()!
        .accentXS
        .copyWith(color: const Color(0xff1E2A36));
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          width: 30,
          height: 22,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.0),
              topRight: Radius.circular(8.0),
            ),
          ),
          child: Text(measureUnit, style: style),
        ),
        Container(
          width: 30,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
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
                  ])),
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
