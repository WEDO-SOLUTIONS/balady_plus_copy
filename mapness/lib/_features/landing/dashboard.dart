import 'dart:io';

import 'package:balady_uikit/balady_uikit.dart' hide Stories;
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/icons/general_32_icons.dart';
import 'package:flutter/material.dart' hide ScrollPosition, SearchBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/common/providers/color_scheme.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/_features/landing/providers/map_controls.dart';
import 'package:mapness/_features/landing/providers/search_by_rubrics.dart';
import 'package:mapness/_features/landing/widgets/calendar_slider_card.dart';
import 'package:mapness/_features/landing/widgets/compliance_card.dart';
import 'package:mapness/_features/landing/widgets/dashboard_header.dart';
import 'package:mapness/_features/landing/widgets/joy_parks_card.dart';
import 'package:mapness/_features/landing/widgets/place_preview.dart';
import 'package:mapness/_features/landing/widgets/places_for_card.dart';
import 'package:mapness/_features/landing/widgets/prayer_card.dart';
import 'package:mapness/_features/landing/widgets/qibla_card.dart';
import 'package:mapness/_features/landing/widgets/snap_and_send_card.dart';
import 'package:mapness/_features/landing/widgets/weather_card.dart';
import 'package:mapness/_features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/app/router.dart';
import 'package:mapness/app/routes/photo_viewer.dart';
import 'package:mapness/app/routes/search.dart';
import 'package:mapness/entities/quick_filters/quick_filter.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/ui/search_scope.dart';
import 'package:mapness/features/stories/data/story_service.dart';
import 'package:mapness/features/stories/stories.dart';
import 'package:mapness/features/stories/stories_widget.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/routing/current_route_provider.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({
    required this.biggestHeight,
    required this.biggestWidth,
    required this.initWithMinSize,
    required this.onScroll,
    required this.scrollableController,
    super.key,
  });

  final DraggableScrollableController scrollableController;
  final double biggestHeight;
  final double biggestWidth;
  final bool initWithMinSize;

  // ignore: avoid_positional_boolean_parameters
  final Function(bool) onScroll;

  @override
  ConsumerState<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> with SingleTickerProviderStateMixin {
  double get _headerExtent => 75 / widget.biggestHeight;

  @override
  void initState() {
    super.initState();
    widget.scrollableController.addListener(_scrollListenHandler);
  }

  @override
  void dispose() {
    widget.scrollableController.removeListener(_scrollListenHandler);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref
      ..listen(searchByRubricsQueryProvider, (previous, next) {
        if (next != null) {
          widget.scrollableController.animateTo(
            _headerExtent,
            duration: const Duration(milliseconds: 250),
            curve: Curves.linear,
          );
        }
      })
      ..listen(layersControlsProvider, (previous, next) {
        if (next.layersVisible) {
          widget.scrollableController.animateTo(
            _headerExtent,
            duration: const Duration(milliseconds: 250),
            curve: Curves.linear,
          );
        }
      });

    final direction = ref.watch(uiDirectionProvider);

    return WillPopScope(
      onWillPop: () async {
        if (Stories.isShowing) {
          Metrics.logEventAdvanced(
            MetricsConstants.exploreKeys.storiesClose,
            action: MetricAction.tap.name,
            group: MetricsConstants.exploreTag,
          );

          //Resume the story update when viewport changed
          ref.read(storyServiceProvider.notifier).resumeUpdate();
          Stories.hide();
          return false;
        }

        // TODO(Ayat): goroute has problems with WillPopScope and push method, this is as a temporary solution.
        //  We are waiting for an update, now the latest version is 14.2.1
        final currentRoute = ref.read(currentRouteProvider);
        if (currentRoute?.currentPath == PhotoViewerRoute.path) {
          context.pop();
          return false;
        }

        return true;
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollStartNotification) {
            widget.onScroll.call(true);
          } else if (notification is ScrollEndNotification) {
            widget.onScroll.call(false);
          }
          return true;
        },
        child: DraggableScrollableSheet(
          controller: widget.scrollableController,
          initialChildSize: widget.initWithMinSize
              ? _headerExtent
              : Platform.isIOS
                  ? .3
                  : .38,
          minChildSize: _headerExtent,
          maxChildSize: .93,
          snap: true,
          snapSizes: [_headerExtent, if (Platform.isIOS) .3 else .38, .93],
          builder: (context, scrollController) => Directionality(
            textDirection: direction,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(RadiusBorder.xl),
                topLeft: Radius.circular(RadiusBorder.xl),
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(RadiusBorder.xl),
                    topLeft: Radius.circular(RadiusBorder.xl),
                  ),
                ),
                child: CustomScrollView(
                  controller: scrollController,
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  physics: const ClampingScrollPhysics(),
                  slivers: [
                    SliverPersistentHeader(
                      delegate: DashboardHeaderDelegate(
                        vsync: this,
                        draggableScrollableController: widget.scrollableController,
                      ),
                      pinned: true,
                      floating: true,
                    ),
                    SliverList.list(
                      children: [
                        Container(
                          color: context.colorsV2.backgroundSurface4,
                          padding: const EdgeInsets.only(
                            top: Spacing.$4x,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const StoriesWidget(),
                              const SizedBox(height: Spacing.$8x),
                              JoyParksCard(widget.scrollableController),
                              const SizedBox(height: Spacing.$3x),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: Spacing.$4x),
                                child: Row(
                                  textDirection: TextDirection.ltr,
                                  children: [
                                    Expanded(child: WeatherCard()),
                                    SizedBox(width: Spacing.$3x),
                                    Expanded(child: QiblaCard()),
                                  ],
                                ),
                              ),
                              const SizedBox(height: Spacing.$8x),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  textDirection: TextDirection.ltr,
                                  children: [
                                    Expanded(
                                      child: PlacesForCart(
                                        title: context.l10n.placesForShopping,
                                        icon: General32Icons.shoppingLRTL,
                                        onTap: () => _openSearch(QuickFilter.shopping),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: PlacesForCart(
                                        title: context.l10n.placesForEatingOut,
                                        icon: General32Icons.restourantLRTL,
                                        onTap: () => _openSearch(QuickFilter.eatOut),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: Spacing.$8x),
                              const PlacePreview(),
                              const SizedBox(height: Spacing.$8x),
                              const SnapAndSendCard(),
                              const SizedBox(height: Spacing.$8x),
                              const ComplianceCard(),
                              const SizedBox(height: Spacing.$8x),
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
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _openSearch(QuickFilter quickFilter) {
    ref.read(goRouterProvider).push(const SearchRoute(requestFocus: false).location);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(searchProvider(SearchScopeEnum.map.value).notifier).quickSearch(quickFilter);
    });
  }

  void _scrollListenHandler() {
    Future.delayed(Duration.zero, () {
      final size = widget.scrollableController.size;
      if (size > _headerExtent + 0.001) {
        ref.read(mapControlsProvider.notifier).update(
              MapControlsStateDashboard(),
            );
      } else {
        ref.read(mapControlsProvider.notifier).update(
              MapControlsStateIdle(),
            );
        FocusManager.instance.primaryFocus?.unfocus();
      }
    });
  }
}
