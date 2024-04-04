import 'package:flutter/material.dart' hide ScrollPosition, SearchBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/weather/provider/forecast_weather_provider.dart';
import 'package:mapness/_features/weather/provider/weather_map_controls.dart';
import 'package:mapness/_features/weather/widgets/weather_card_header.dart';
import 'package:mapness/_features/weather/widgets/weather_day_card.dart';

class WeatherDashboard extends ConsumerStatefulWidget {
  const WeatherDashboard({
    required this.biggestHeight, required this.biggestWidth, super.key,
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
          final size = _draggableScrollableController.size;
          final sizeFixed = double.parse(size.toStringAsFixed(2));
          final headerExtentFixed =
              double.parse(_headerExtent.toStringAsFixed(2));
          final mapControls = ref.read(weatherMapControlsProvider.notifier);

          if (sizeFixed > headerExtentFixed) {
            mapControls.update(
              controlsVisible: false,
            );
          } else if (sizeFixed == headerExtentFixed) {
            final extent = widget.biggestHeight * sizeFixed;
            mapControls.update(
              extent: extent,
              controlsVisible: true,
            );
          } else if (sizeFixed < headerExtentFixed && sizeFixed != .1) {
            mapControls.update(controlsVisible: false);
          } else if (sizeFixed == .1) {
            final extent = widget.biggestHeight * sizeFixed;
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
      snap: true,
      snapSizes: [.1, _headerExtent, 1],
      builder: (context, scrollController) => Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            // padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              // color: context.color.surfaceBasePrimary,
              // color: context.color.surfaceBasePrimary,

              borderRadius: BorderRadius.only(
                topRight: Radius.circular(16),
                topLeft: Radius.circular(16),
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
                  itemBuilder: (context, index) =>
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: WeatherDayCard(
                    forecastDay: weatherData?.forecast?.forecastday?[index],
                    isExpanded: false,
                    onExpansionChanged: (b) {},
                  ),
                      ),
                  separatorBuilder: (context, index) =>
                      const SizedBox(
                    height: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
