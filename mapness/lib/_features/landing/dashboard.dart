import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart' as uikit hide Stories;
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/icons/general_32_icons.dart';
import 'package:flutter/material.dart' hide ScrollPosition, SearchBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/color_scheme.dart';
import 'package:mapness/_features/landing/map_hidden_state_controls.dart';
import 'package:mapness/_features/landing/providers/map_controls.dart';
import 'package:mapness/_features/landing/providers/search_by_rubrics.dart';
import 'package:mapness/_features/landing/widgets/calendar_slider_card.dart';
import 'package:mapness/_features/landing/widgets/dashboard_header.dart';
import 'package:mapness/_features/landing/widgets/place_preview.dart';
import 'package:mapness/_features/landing/widgets/places_for_card.dart';
import 'package:mapness/_features/landing/widgets/prayer_card.dart';
import 'package:mapness/_features/landing/widgets/qibla_card.dart';
import 'package:mapness/_features/landing/widgets/snap_and_send_card.dart';
import 'package:mapness/_features/landing/widgets/weather_card.dart';
import 'package:mapness/_features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/quick_filters/quick_filter.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/ui/search_scope.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/widgets/app_feedback/app_feedback_card.dart';
import 'package:mapness/widgets/stories/lib/stories_widget.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({
    required this.bottomSheetController,
    super.key,
  });

  final uikit.StatefulBottomSheetController<uikit.ThreeStateBottomSheet> bottomSheetController;

  @override
  ConsumerState<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    widget.bottomSheetController.addListener(_scrollListenHandler);
  }

  @override
  void dispose() {
    widget.bottomSheetController.removeListener(_scrollListenHandler);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref
      ..listen(searchByRubricsQueryProvider, (previous, next) {
        if (next != null) {
          widget.bottomSheetController.setState(uikit.ThreeStateBottomSheet.hidden);
        }
      })
      ..listen(layersControlsProvider, (previous, next) {
        if (next.layersVisible) {
          widget.bottomSheetController.setState(uikit.ThreeStateBottomSheet.hidden);
        }
      });

    return uikit.StatefulBottomSheet<uikit.ThreeStateBottomSheet>(
      animateOpening: false,
      topHeader: MapHiddenStateControls(widget.bottomSheetController),
      backgroundColor: context.colorsV2.backgroundSurface4,
      header: DashboardHeader(
        bottomSheetController: widget.bottomSheetController,
      ),
      scrollController: widget.bottomSheetController,
      sliverBeforeContent: SliverPersistentHeader(
        delegate: DashboardHeaderDelegate(vsync: this),
        pinned: true,
        floating: true,
      ),
      content: [
        Column(
          children: [
            const AppFeedbackCard(),
            const StoriesWidget(),
            const SizedBox(height: uikit.Spacing.$8x),
            // BSA-1108: See the instruction to revert here: https://github.com/urbi-ae/baladi/pull/1164
            // JoyParksCardV2(controller: widget.bottomSheetController),
            // const SizedBox(height: uikit.Spacing.$3x),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: uikit.Spacing.$4x),
              child: Row(
                textDirection: TextDirection.ltr,
                children: [
                  Expanded(child: WeatherCard()),
                  SizedBox(width: uikit.Spacing.$3x),
                  Expanded(child: QiblaCard()),
                ],
              ),
            ),
            const SizedBox(height: uikit.Spacing.$8x),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                textDirection: TextDirection.ltr,
                children: [
                  Expanded(
                    child: PlacesForCart(
                      title: context.l10n.placesForShopping,
                      icon: General32Icons.shoppingLRTL,
                      onTap: () => _openSearch(context, QuickFilter.shopping),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PlacesForCart(
                      title: context.l10n.placesForEatingOut,
                      icon: General32Icons.restourantLRTL,
                      onTap: () => _openSearch(context, QuickFilter.eatOut),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: uikit.Spacing.$8x),
            const PlacePreview(),
            const SizedBox(height: uikit.Spacing.$8x),
            const SnapAndSendCard(),
            // const SizedBox(height: uikit.Spacing.$8x),
            // const ComplianceCard(),
            const SizedBox(height: uikit.Spacing.$8x),
            const PrayerCard(),
            CalendarSliderCard(
              colorScheme: ref.read(colorSchemeProvider),
              onShowAll: () => Metrics.logEventAdvanced(
                MetricsConstants.exploreKeys.kingdomCalendarViewAll,
                action: MetricAction.tap.name,
                group: MetricsConstants.exploreTag,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _openSearch(BuildContext context, QuickFilter quickFilter) {
    context.router.push(SearchRoute(requestFocus: false));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(searchProvider(SearchScopeEnum.map.value).notifier).quickSearch(quickFilter);
    });
  }

  void _scrollListenHandler() {
    Future.delayed(Duration.zero, () {
      if (widget.bottomSheetController.state != uikit.ThreeStateBottomSheet.hidden) {
        ref.read(mapControlsProvider.notifier).update(
              MapControlsStateDashboard(),
            );
      } else {
        ref.read(mapControlsProvider.notifier).update(
              MapControlsStateIdle(),
            );
      }
    });
  }
}
