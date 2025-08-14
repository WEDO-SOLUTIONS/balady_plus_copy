import 'package:balady_uikit/balady_uikit.dart' hide StatefulSheetDelegate;
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

  const WeatherDashboard({
    required this.bottomSheetController,
    super.key,
  });

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

    return MultiStateSheet(
      scrollController: widget.bottomSheetController,
      backgroundColor: context.colors.backgroundSurface1,
      safeAreaColor: context.colors.backgroundSurface1,
      dragger: const SheetDragger(),
      outside: WeatherControls(bottomSheetController: widget.bottomSheetController),
      outsideOpacityDelegate: outsideOpacityDelegate,
      sliver: SliverPersistentHeader(
        delegate: WeatherCardHeaderDelegate(
          cardKey: cardKey,
          bottomSheetController: widget.bottomSheetController,
        ),
        pinned: true,
      ),
      content: [
        Spacing.$4x.heightBox,
        ListView.separated(
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
      ],
    );
  }
}
