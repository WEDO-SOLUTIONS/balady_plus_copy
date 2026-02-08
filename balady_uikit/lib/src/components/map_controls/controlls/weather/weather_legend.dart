part of 'package:balady_uikit/src/components/map_controls/map_controls.dart';

class WeatherLegend extends StatelessWidget {
  final String measureUnit;
  final List<String> measures;

  const WeatherLegend({
    required this.measureUnit,
    required this.measures,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = context.textStyles.captionMediumSemiBold.copyWith(
      color: context.colors.foregroundDefault,
    );

    return LayoutBuilder(
      builder: (context, constraints) => SizedBox(
        height: constraints.maxHeight,
        width: 30,
        child: Column(
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
              child: Text(
                measureUnit,
                style: textStyle,
              ),
            ),
            Expanded(
              child: Container(
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
                  padding: const EdgeInsets.only(bottom: Spacing.$1x, top: Spacing.$1x),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: measures.map((e) => Text(e, style: textStyle)).toList(),
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
