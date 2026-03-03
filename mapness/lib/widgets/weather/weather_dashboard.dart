import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart' hide ScrollPosition, SearchBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/features/weather/provider/forecast_weather_provider.dart';
import 'package:mapness/widgets/weather/weather_card_header.dart';
import 'package:mapness/widgets/weather/weather_controls.dart';
import 'package:mapness/widgets/weather/weather_day_card.dart';
import 'package:sheetify/sheetify.dart';

class WeatherDashboard extends ConsumerStatefulWidget {
  final MultiStateSheetController<ThreeStateSheet> bottomSheetController;

  const WeatherDashboard({required this.bottomSheetController, super.key});

  @override
  ConsumerState<WeatherDashboard> createState() => _WeatherDashboardState();
}

class _WeatherDashboardState extends ConsumerState<WeatherDashboard> {
  final cardKey = GlobalKey();

  final outsideOpacityDelegate = StatefulSheetDelegate.func<double, ThreeStateSheet>(
    (c) => c.fraction > 0.4 ? 1 - (c.fraction - 0.4) * 10 : 1.0,
  );

  void _updateHeaderHeight() {
    final renderBox = cardKey.currentContext?.findRenderObject() as RenderBox?;

    if (renderBox != null && weatherHeaderSize != renderBox.size.height) {
      setState(() {
        weatherHeaderSize = renderBox.size.height;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateHeaderHeight());
  }

  @override
  Widget build(BuildContext context) {
    final weatherData = ref.watch(forecastWeatherProvider);

    return ListenableBuilder(
      listenable: widget.bottomSheetController,
      builder: (_, _) => Stack(
        children: [
          MultiStateSheet(
            useSafeArea: false,
            scrollController: widget.bottomSheetController,
            backgroundColor: context.colors.backgroundSurface4,
            dragger: SheetDragger(draggerColor: context.colors.backgroundSurface5),
            outside: WeatherControls(bottomSheetController: widget.bottomSheetController),
            outsideOpacityDelegate: outsideOpacityDelegate,
            header: DashboardHeader(cardKey: cardKey, bottomSheetController: widget.bottomSheetController),
            content: [
              Spacing.$4x.heightBox,
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SizeTransition(sizeFactor: animation, axisAlignment: -1.0, child: child),
                ),
                child: widget.bottomSheetController.closestState != ThreeStateSheet.expanded
                    ? const SizedBox(key: ValueKey('hidden'))
                    : ListView.separated(
                        key: const ValueKey('list'),
                        padding: const EdgeInsets.only(bottom: Spacing.$4x),
                        primary: false,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: weatherData?.forecast?.forecastday?.length ?? 0,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
                          child: WeatherDayCard(
                            forecastDay: weatherData?.forecast?.forecastday?[index],
                            isExpanded: false,
                            onExpansionChanged: (b) {},
                          ),
                        ),
                        separatorBuilder: (context, index) => Spacing.$3x.heightBox,
                      ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 72,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [context.colors.backgroundSurface4.withOpacity(0.0), context.colors.backgroundSurface4],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
