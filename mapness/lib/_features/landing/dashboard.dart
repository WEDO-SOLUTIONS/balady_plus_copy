import 'dart:io';

import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart' hide ScrollPosition, SearchBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import 'package:mapness/features/stories/data/story_service.dart';
import 'package:mapness/features/stories/stories.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';

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
  final Function(bool) onScroll;

  @override
  ConsumerState<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> {
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
                topRight: Radius.circular(16),
                topLeft: Radius.circular(16),
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
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
                      delegate: DashboardHeaderDelegate(
                        draggableScrollableController: widget.scrollableController,
                      ),
                      pinned: true,
                    ),
                    SliverList.list(
                      children: [
                        Container(
                          color: context.colorsV2.backgroundSurface4,
                          padding: const EdgeInsets.only(
                            top: 16,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const JoyParksCard(),
                              const SizedBox(height: 12),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  children: [
                                    Expanded(child: WeatherCard()),
                                    SizedBox(width: 12),
                                    Expanded(child: QiblaCard()),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 32),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: PlacesForCart(
                                        title: context.l10n.placesForShopping,
                                        svgAsset: 'assets/images_svg/shopping.svg',
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: PlacesForCart(
                                        title: context.l10n.placesForEatingOut,
                                        svgAsset: 'assets/images_svg/restourant.svg',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 32),
                              const PlacePreview(),
                              const SizedBox(height: 32),
                              const SnapAndSendCard(),
                              const SizedBox(height: 32),
                              const ComplianceCard(),
                              const SizedBox(height: 32),
                              const PrayerCard(),
                              const SizedBox(height: 32),
                              CalendarSliderCard(
                                colorScheme: ref.read(colorSchemeProvider),
                                onShowAll: () => Metrics.logEventAdvanced(
                                  MetricsConstants.exploreKeys.kingdomCalendarViewAll,
                                  action: MetricAction.tap.name,
                                  group: MetricsConstants.exploreTag,
                                ),
                              ),
                              const SizedBox(
                                height: 32,
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
