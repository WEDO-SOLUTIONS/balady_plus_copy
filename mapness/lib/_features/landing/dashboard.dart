import 'package:balady_plus/app/features/_shared_feature_/balady_features/balady_exports.dart';
import 'package:flutter/material.dart' hide SearchBar, ScrollPosition;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/_features/landing/providers/map_controls.dart';
import 'package:mapness/_features/landing/providers/search_by_rubrics.dart';
import 'package:mapness/_features/landing/widgets/compliance_card.dart';
import 'package:mapness/_features/landing/widgets/dashboard_header.dart';
import 'package:mapness/_features/landing/widgets/dashboard_profile.dart';
// import 'package:mapness/_features/landing/widgets/jobs_around_card.dart';
import 'package:mapness/_features/landing/widgets/snap_and_send_card.dart';
import 'package:mapness/_features/stories/stories_widget.dart';
import 'package:mapness/_generated/protocol/protocol.pb.dart' as proto;
import 'package:mapness/shared/extensions/build_context_ext.dart';

import 'providers/interesting_places.dart';
import 'widgets/places_horizontal_list.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({
    this.isCollapsed = false,
    super.key,
    required this.biggestHeight,
    required this.biggestWidth,
  });

  final double biggestHeight;
  final double biggestWidth;
  final bool isCollapsed;

  @override
  ConsumerState<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> {
  late final DraggableScrollableController _draggableScrollableController;

  double get _headerExtent => 75 / widget.biggestHeight;

  @override
  void initState() {
    super.initState();
    _draggableScrollableController = DraggableScrollableController()
      ..addListener(() {
        Future.delayed(Duration.zero, () {
          if (_draggableScrollableController.size > _headerExtent + 0.001) {
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
      });
  }

  @override
  void dispose() {
    _draggableScrollableController.dispose();
    super.dispose();
  }

  Widget _buildInterestingPlacesCards() {
    return Consumer(
      builder: (context, ref, child) {
        final places = ref.watch(interestingPlacesProvider).where((e) {
          return e.tags.contains(
            proto
                .InterestingPlaceTag.INTERESTING_PLACE_CATEGORY_IMMERSIVE_MODEL,
          );
        }).toList();

        return PlacesHorizontalList(
          title: context.l10n.placesToVisit,
          places: places,
        );
      },
    );
  }

  Widget _buildShoppingMallsCards() {
    return Consumer(
      builder: (context, ref, child) {
        final places = ref.watch(interestingPlacesProvider).where((e) {
          return e.tags.contains(
            proto.InterestingPlaceTag.INTERESTING_PLACE_CATEGORY_FLOORS,
          );
        }).toList();

        return PlacesHorizontalList(
          title: context.l10n.placesToShop,
          places: places,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(searchByRubricsQueryProvider, (previous, next) {
      if (next != null) {
        _draggableScrollableController.animateTo(
          _headerExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.linear,
        );
      }
    });

    final direction = ref.watch(uiDirectionProvider);

    return DraggableScrollableSheet(
      controller: _draggableScrollableController,
      initialChildSize: widget.isCollapsed ? _headerExtent : .75,
      minChildSize: _headerExtent,
      maxChildSize: .9,
      snap: true,
      snapSizes: [_headerExtent, .75, .9],
      builder: (BuildContext context, ScrollController scrollController) {
        return Directionality(
          textDirection: direction,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(16.0),
              topLeft: Radius.circular(16.0),
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(16.0),
                  topLeft: Radius.circular(16.0),
                ),
              ),
              child: CustomScrollView(
                controller: scrollController,
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                physics: const ClampingScrollPhysics(),
                slivers: [
                  SliverPersistentHeader(
                    delegate: DashboardHeaderDelegate(
                      draggableScrollableController:
                          _draggableScrollableController,
                    ),
                    pinned: true,
                  ),
                  SliverList.list(
                    children: [
                      Container(
                        color: const Color(0xFFF1F4F8),
                        padding: const EdgeInsets.only(
                          top: 16.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const DashboardProfile(),
                            const SizedBox(
                              height: 20,
                            ),
                            const StoriesWidget(),
                            _buildInterestingPlacesCards(),
                            const SizedBox(
                              height: 20,
                            ),
                            const SnapAndSendCard(),
                            const ComplianceCard(),
                            _buildShoppingMallsCards(),
                            const SizedBox(
                              height: 20,
                            ),
                            const EventsHomeCard(),
                            const SizedBox(
                              height: 20,
                            ),
                            // const JobsAroundCard(),
                            const SizedBox(
                              height: 20,
                            ),
                            const PrayerHomeCard(),
                            const SizedBox(
                              height: 20,
                            ),
                            const CalendarHomeCard(),
                            const SizedBox(
                              height: 20,
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
        );
      },
    );
  }
}
