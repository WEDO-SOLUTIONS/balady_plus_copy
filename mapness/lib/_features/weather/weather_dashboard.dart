import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart' hide ScrollPosition, SearchBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/weather/provider/forecast_weather_provider.dart';
import 'package:mapness/_features/weather/widgets/weather_card_header.dart';
import 'package:mapness/_features/weather/widgets/weather_day_card.dart';

class WeatherDashboard extends ConsumerStatefulWidget {
  final double biggestHeight;
  final double biggestWidth;
  final StatefulBottomSheetController<ThreeStateBottomSheet> bottomSheetController;

  const WeatherDashboard({
    required this.biggestHeight,
    required this.biggestWidth,
    required this.bottomSheetController,
    super.key,
  });

  @override
  ConsumerState<WeatherDashboard> createState() => _WeatherDashboardState();
}

class _WeatherDashboardState extends ConsumerState<WeatherDashboard> {

  @override
  Widget build(BuildContext context) {
    final weatherData = ref.watch(forecastWeatherProvider);

    return StatefulBottomSheet(
      scrollController: widget.bottomSheetController,
      sliverBeforeContent: SliverPersistentHeader(
        delegate: WeatherCardHeaderDelegate(
          bottomSheetController: widget.bottomSheetController,
        ),
        pinned: true,
      ),
      content: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListView.separated(
              padding: EdgeInsets.zero,
              primary: false,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: weatherData?.forecast?.forecastday?.length ?? 0,
              itemBuilder: (context, index) =>
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
                    child: WeatherDayCard(
                      forecastDay: weatherData?.forecast?.forecastday?[index],
                      isExpanded: false,
                      onExpansionChanged: (b) {},
                    ),
                  ),
              separatorBuilder: (context, index) => Spacing.$3x.heightBox,
            ),
            Spacing.$4x.heightBox,
          ],
        ),
      ],

    );
  }
}
