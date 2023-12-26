import 'package:balady_plus/app/features/_shared_feature_/balady_features/balady_exports.dart';
import 'package:flutter/material.dart' hide SearchBar, ScrollPosition;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/_features/landing/providers/map_controls.dart';
import 'package:mapness/_features/landing/providers/search_by_rubrics.dart';
import 'package:mapness/_features/landing/widgets/compliance_card.dart';
import 'package:mapness/_features/landing/widgets/dashboard_header.dart';
import 'package:mapness/_features/landing/widgets/dashboard_profile.dart';
import 'package:mapness/_features/landing/widgets/events_home_card_wrapper.dart';
// import 'package:mapness/_features/landing/widgets/jobs_around_card.dart';
import 'package:mapness/_features/landing/widgets/snap_and_send_card.dart';
import 'package:mapness/_features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/_features/stories/stories.dart';
import 'package:mapness/_features/stories/stories_widget.dart';

import 'widgets/interesting_places_cards.dart';
import 'widgets/shopping_malls_cards.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({
    super.key,
    required this.biggestHeight,
    required this.biggestWidth,
  });

  final double biggestHeight;
  final double biggestWidth;

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
    ref.listen(layersControlsProvider, (previous, next) {
      if (next.layersVisible) {
        _draggableScrollableController.animateTo(
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
          Stories.hide();
          return false;
        }
        return true;
      },
      child: DraggableScrollableSheet(
        controller: _draggableScrollableController,
        initialChildSize: .75,
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
                              const InterestingPlacesCardsList(),
                              const SizedBox(
                                height: 20,
                              ),
                              const SnapAndSendCard(),
                              const ComplianceCard(),
                              const ShoppingMallsCardsList(),
                              const SizedBox(
                                height: 20,
                              ),
                              EventsHomeCardWrapper(
                                key: ValueKey(
                                    'events_home_card_wrapper_${direction.name}'),
                              ),
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
      ),
    );
  }
}
