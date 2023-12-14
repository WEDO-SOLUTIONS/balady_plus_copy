import 'package:flutter/material.dart' hide SearchBar, ScrollPosition;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/weather/provider/forecast_weather_provider.dart';
import 'package:mapness/_features/weather/provider/weather_map_controls.dart';
import 'package:mapness/_features/weather/widgets/weather_card_header.dart';
import 'package:mapness/_features/weather/widgets/weather_day_card.dart';

class WeatherDashboard extends ConsumerStatefulWidget {
  const WeatherDashboard({
    super.key,
    required this.biggestHeight,
    required this.biggestWidth,
  });

  final double biggestHeight;
  final double biggestWidth;

  @override
  ConsumerState<WeatherDashboard> createState() => _WeatherDashboardState();
}

class _WeatherDashboardState extends ConsumerState<WeatherDashboard> {
  late final DraggableScrollableController _draggableScrollableController;

  double get _headerExtent => weatherHeaderSize / widget.biggestHeight;

  @override
  void initState() {
    super.initState();

    _draggableScrollableController = DraggableScrollableController()
      ..addListener(() {
        Future.delayed(Duration.zero, () {
          var size = _draggableScrollableController.size;
          var sizeFixed = double.parse(size.toStringAsFixed(2));
          var headerExtentFixed =
              double.parse(_headerExtent.toStringAsFixed(2));
          final mapControls = ref.read(weatherMapControlsProvider.notifier);

          if (sizeFixed > headerExtentFixed) {
            mapControls.update(
              controlsVisible: false,
            );
          } else if (sizeFixed == headerExtentFixed) {
            var extent = widget.biggestHeight * sizeFixed;
            mapControls.update(
              extent: extent,
              controlsVisible: true,
            );
          } else if (sizeFixed < headerExtentFixed && sizeFixed != .1) {
            mapControls.update(controlsVisible: false);
          } else if (sizeFixed == .1) {
            var extent = widget.biggestHeight * sizeFixed;
            mapControls.update(
              controlsVisible: true,
              extent: extent,
            );
          }
        });
      });
  }

  @override
  void dispose() {
    _draggableScrollableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final weatherData = ref.watch(forecastWeatherProvider);

    return DraggableScrollableSheet(
      controller: _draggableScrollableController,
      initialChildSize: _headerExtent,
      minChildSize: .1,
      maxChildSize: 1,
      snap: true,
      snapSizes: [.1, _headerExtent, 1],
      builder: (BuildContext context, ScrollController scrollController) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            // padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              // color: Color(0xffF4F4F5),
              // color: Color(0xffF4F4F5),

              borderRadius: BorderRadius.only(
                topRight: Radius.circular(16.0),
                topLeft: Radius.circular(16.0),
              ),
            ),
            child: CustomScrollView(
              controller: scrollController,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              physics: const ClampingScrollPhysics(),
              slivers: [
                SliverPersistentHeader(
                  delegate: WeatherCardHeaderDelegate(
                    draggableScrollableController:
                        _draggableScrollableController,
                  ),
                  pinned: true,
                ),
                SliverList.separated(

                  itemCount: weatherData?.forecast?.forecastday?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) =>
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: WeatherDayCard(
                    forecastDay: weatherData?.forecast?.forecastday?[index],
                    isExpanded: false,
                    onExpansionChanged: (b) {},
                  ),
                      ),
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(
                    height: 12,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
