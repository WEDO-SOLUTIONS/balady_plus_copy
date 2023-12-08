import 'package:balady_plus/app/features/home_page/presentation/widgets/home_bottom_sheet/event_home_card.dart';
import 'package:balady_plus/app/core/utils/routes.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/home_page/presentation/widgets/home_bottom_sheet/calendar_home_item_widget.dart';
import 'package:balady_plus/app/features/home_page/home_exports.dart' as team42;
import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart' hide SearchBar, ScrollPosition;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/user_state.dart';
import 'package:mapness/_features/landing/providers/map_controls.dart';
import 'package:mapness/_features/landing/providers/search_by_rubrics.dart';
import 'package:mapness/_features/landing/widgets/challenge_card.dart';
import 'package:mapness/_features/landing/widgets/dashboard_header.dart';
import 'package:mapness/_features/landing/widgets/g2b_card.dart';
import 'package:mapness/_features/landing/widgets/login_card.dart';
import 'package:mapness/_features/landing/widgets/poi_card.dart';
import 'package:mapness/_features/landing/widgets/service_card.dart';
import 'package:mapness/_features/stories/stories_widget.dart';
import 'package:mapness/features/iwish/providers/iwish_markers.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

import 'providers/interesting_places.dart';

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

    ref.read(interestingPlacesProvider.notifier).startListen();
  }

  @override
  void dispose() {
    _draggableScrollableController.dispose();
    super.dispose();
  }

  Widget _buildInterestingPlacesCards() {
    return Consumer(
      builder: (context, ref, child) {
        final places = ref.watch(interestingPlacesProvider);

        return Visibility(
          visible: places.isNotEmpty,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  right: 16.0,
                ),
                child: Text(
                  context.l10n.placesToVisit,
                  style: Theme.of(context).extension<ThemeTextStyles>()!.textL,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 200,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  itemCount: places.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final place = places[index];

                    return PoiCard(
                      objectId: DgisObjectIdMessage(
                        objectId: int.tryParse(place.id) ?? 0,
                        entranceId: 0,
                      ),
                      title: place.titleOrFallback(locale: context.l10n),
                      subtitle: '',
                      image: place.preview.image.url,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEvents() {
    return const EventHomeCard();
  }

  Widget _buildJobServicesCards() {
    void navigateToCompliance() {
      final builder = Routes.routes()[RouteName.createCompliancePage]!;

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return Stack(
              children: [
                const Positioned.fill(
                  child: ColoredBox(
                    color: AppColor.white3,
                  ),
                ),
                builder(context)
              ],
            );
          },
        ),
      );
    }

    return Builder(
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              G2BCard(
                color: const Color(0xff306D6C),
                title: "Appeals",
                subtitle: "في نوفمبر",
                onTap: () {
                  // TODO(@42): Navigate to Appeals screen
                },
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  Expanded(
                    child: G2BCard(
                      color: const Color(0xFF4CA5B4),
                      title: "Book Appointment",
                      subtitle: "في نوفمبر",
                      onTap: () {
                        // TODO(@42): Navigate to Book Appointment screen
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: G2BCard(
                      color: const Color(0xff90BA58),
                      title: "Compliance Certificate",
                      subtitle: "في نوفمبر",
                      onTap: navigateToCompliance,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCalendar() {
    return const CalendarHomeItemWidget(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
      ),
    );
  }

  Widget _buildPrayer() {
    return const team42.PrayerHomeCard();
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userStateProvider);
    ref.listen(searchByRubricsQueryProvider, (previous, next) {
      if (next != null) {
        _draggableScrollableController.animateTo(
          _headerExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.linear,
        );
      }
    });

    return DraggableScrollableSheet(
      controller: _draggableScrollableController,
      initialChildSize: widget.isCollapsed ? _headerExtent : .75,
      minChildSize: _headerExtent,
      maxChildSize: .9,
      snap: true,
      snapSizes: [_headerExtent, .75, .9],
      builder: (BuildContext context, ScrollController scrollController) {
        return Directionality(
          textDirection: TextDirection.rtl,
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
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                          const StoriesWidget(),
                          _buildInterestingPlacesCards(),
                          const SizedBox(
                            height: 24,
                          ),
                          _buildEvents(),
                          _buildPrayer(),
                          const SizedBox(
                            height: 24,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            child: ChallengeCard(),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Text(
                              context.l10n.registerForOpportunities,
                              style: Theme.of(context)
                                  .extension<ThemeTextStyles>()!
                                  .textL,
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            child: LoginCard(),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Text(
                              context.l10n.loginToAccess,
                              style: Theme.of(context)
                                  .extension<ThemeTextStyles>()!
                                  .textL,
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: ServiceCard(
                                    title: context.l10n.iwish,
                                    image: 'assets/images/iwish.png',
                                    subtitle: context.l10n.inNovember,
                                    onTap: () async {
                                      const curve = Curves.linear;
                                      const duration =
                                          Duration(milliseconds: 250 ~/ 3);
                                      await scrollController.animateTo(
                                        0,
                                        duration: duration,
                                        curve: curve,
                                      );

                                      await _draggableScrollableController
                                          .animateTo(
                                        0,
                                        duration: duration,
                                        curve: Curves.linear,
                                      );
                                      ref
                                          .read(iwishMarkersProvider.notifier)
                                          .focusMarkersOnMap();
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: ServiceCard(
                                    title: context.l10n.snap_and_send,
                                    image: 'assets/images/snap_and_send.png',
                                    subtitle: context.l10n.inNovember,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          _buildCalendar(),
                          if (userState == UserState.business) ...[
                            const SizedBox(
                              height: 24,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: Text(
                                context.l10n.interestingForYou,
                                style: Theme.of(context)
                                    .extension<ThemeTextStyles>()!
                                    .textL,
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            // Card for 42
                            _buildJobServicesCards(),
                            // ],
                            const SizedBox(
                              height: 16,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
