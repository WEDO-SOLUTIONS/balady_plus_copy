import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart' hide ScrollPosition, SearchBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/entities/weather/weather_info.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/widgets/weather/weather_card_header.dart';
import 'package:mapness/widgets/weather/weather_controls.dart';
import 'package:mapness/widgets/weather/weather_day_card.dart';
import 'package:sheetify/sheetify.dart';

/// Weather sheet over the weather map.
///
/// Snaps to three heights: the place name only, the full "today" card, and the day list. Nothing in the sheet
/// depends on its position — the header and the day list are built once and simply revealed while dragging — so a
/// drag frame only moves the sheet and fades the map controls.
class WeatherDashboard extends ConsumerStatefulWidget {
  const WeatherDashboard({required this.forecast, required this.onClose, super.key});

  final AllWeatherInfoEntity forecast;
  final VoidCallback onClose;

  @override
  ConsumerState<WeatherDashboard> createState() => _WeatherDashboardState();
}

class _WeatherDashboardState extends ConsumerState<WeatherDashboard> {
  /// [SheetDragger] is a 4px handle with 6px padding above and below.
  static const _draggerHeight = 16.0;
  static const _expandedFraction = .931;

  final _peek = WeatherSheetPeek();

  late final _controller = MultiStateSheetController<ThreeStateSheet>(
    initialState: ThreeStateSheet.open,
    behavior: MultiSnappingBehavior(
      // The collapsed height is the title row, not the whole header, so the header must not clamp the sheet.
      clipByHeader: false,
      models: [
        ComponentsSnappingModel(
          componentsDescriptions: [_CollapsedSnap(_peek), _OpenSnap(_peek)],
        ),
        FractionSnappingModel({_expandedFraction}),
      ],
    ),
    stateMapper: const ThreeStateMapper(),
  );

  /// Map controls stay fully visible up to the open state and fade out on the way to expanded.
  final _outsideOpacity = StatefulSheetDelegate.func<double, ThreeStateSheet>(
    (controller) => switch (controller.state) {
      ThreeStateSheet.hidden => 1.0,
      ThreeStateSheet.open => 1 - controller.interpolation,
      ThreeStateSheet.expanded => 0.0,
    },
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpanded() => _controller.setState(
    _controller.state == ThreeStateSheet.expanded ? ThreeStateSheet.open : ThreeStateSheet.expanded,
  );

  @override
  Widget build(BuildContext context) {
    final languageCode = ref.watch(appLanguageProvider.select((language) => language.locale.languageCode));
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    _peek.bottomInset = bottomInset;
    final days = widget.forecast.forecast?.forecastday ?? const <ForecastDay>[];

    return MultiStateSheet<ThreeStateSheet>(
      useSafeArea: false,
      scrollController: _controller,
      backgroundColor: context.colors.backgroundSurface4,
      dragger: SheetDragger(
        draggerColor: context.colors.backgroundSurface5,
        backgroundColor: context.colors.backgroundSurface4,
      ),
      outside: const WeatherControls(),
      outsideOpacityDelegate: _outsideOpacity,
      header: WeatherSheetHeader(
        forecast: widget.forecast,
        peek: _peek,
        draggerHeight: _draggerHeight,
        onClose: widget.onClose,
        onTodayTap: _toggleExpanded,
      ),
      content: [
        for (final (index, day) in days.indexed)
          Padding(
            key: ValueKey(day.date ?? index),
            padding: EdgeInsets.fromLTRB(Spacing.$4x, index == 0 ? 0 : Spacing.$3x, Spacing.$4x, 0),
            child: WeatherDayCard(forecastDay: day, languageCode: languageCode),
          ),
        SizedBox(height: Spacing.$4x + bottomInset),
      ],
    );
  }
}

/// Collapsed: dragger and place name, above the home indicator.
class _CollapsedSnap extends SnapComponent {
  const _CollapsedSnap(this.peek);

  final WeatherSheetPeek peek;

  @override
  double getSize<T>(MultiStateSheetExtent<T> extent) => peek.height + peek.bottomInset;
}

/// Open: the whole header, i.e. the full "today" card, above the home indicator.
class _OpenSnap extends SnapComponent {
  const _OpenSnap(this.peek);

  final WeatherSheetPeek peek;

  @override
  double getSize<T>(MultiStateSheetExtent<T> extent) => getComponentSize(extent, Components.header) + peek.bottomInset;
}
