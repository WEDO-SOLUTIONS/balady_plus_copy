import 'package:balady_uikit/balady_uikit.dart' as uikit;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/landing/search_in_rect.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/ui/search_scope.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/features/balady_analytics/metrics.dart';
import 'package:mapness/widgets/landing/compass_control.dart';
import 'package:mapness/widgets/landing/complience_building_legend.dart';
import 'package:mapness/widgets/landing/follow_control.dart';
import 'package:mapness/widgets/landing/layers_control.dart';
import 'package:mapness/widgets/landing/traffic_control.dart';
import 'package:mapness/widgets/map_dimensions_control/dimension_contrtol.dart';
import 'package:mapness/widgets/weather/weather_control.dart';
import 'package:sheetify/sheetify.dart';

class NaviSearchSheetControls extends ConsumerStatefulWidget {
  final MultiStateSheetController scrollController;

  const NaviSearchSheetControls(
    this.scrollController, {
    super.key,
  });

  @override
  ConsumerState<NaviSearchSheetControls> createState() => _NaviSearchSheetControlsState();
}

class _NaviSearchSheetControlsState extends ConsumerState<NaviSearchSheetControls> {
  late ValueNotifier<double> _interpolationNotifier;
  late final ValueNotifier<bool> _visibleSearchArea = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _interpolationNotifier = ValueNotifier(widget.scrollController.interpolation);
    widget.scrollController.addListener(update);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(update);
    _interpolationNotifier.dispose();
    super.dispose();
  }

  void update() {
    _interpolationNotifier.value = widget.scrollController.interpolation;
  }

  void _searchInArea() {
    Metrics.logEventAdvanced(
      MetricsConstants.searchKeys.searchInThisArea,
      group: MetricsConstants.searchTag,
      action: MetricAction.tap.toString(),
    );

    ref.read(searchInRectProvider(SearchScopeEnum.navi.value).notifier).update();
    ref.read(searchProvider(SearchScopeEnum.navi.value).notifier).searchInThisArea(SearchScopeEnum.navi.value);
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(
      searchInRectProvider(SearchScopeEnum.navi.value).select((value) {
        if (_visibleSearchArea.value != value.isButtonVisible) {
          _visibleSearchArea.value = value.isButtonVisible;
        }
      }),
    );

    return ValueListenableBuilder<double>(
      valueListenable: _interpolationNotifier,
      builder: (context, interpolation, __) => SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Directionality(
              textDirection: TextDirection.ltr,
              child: Expanded(
                child: OverflowBox(
                  child: Padding(
                    padding: const EdgeInsets.all(
                      uikit.Spacing.$3x,
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [WeatherControl()],
                              ),
                              const Spacer(),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const LayersControl(),
                                    const SizedBox(height: uikit.Spacing.$2x),
                                    const TrafficControl(),
                                    const SizedBox(height: uikit.Spacing.$2x),
                                    const DimensionControl(),
                                    const Spacer(),
                                    const CompassControl(),
                                    const SizedBox(height: uikit.Spacing.$2x),
                                    ComplianceBuildingLegend(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: uikit.Spacing.$2x),
                        Row(
                          children: [
                            ValueListenableBuilder(
                              valueListenable: _visibleSearchArea,
                              builder: (context, value, child) => uikit.AppButton(
                                buttonColorScheme: uikit.ButtonColorScheme.accentSecondary,
                                primaryLabel: context.l10n.searchInThisArea,
                                onTap: _searchInArea,
                                innerPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              ),
                            ),
                            const Spacer(),
                            const FollowControl(),
                          ],
                        ),
                      ],
                    ),
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
