import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/events/presentation/bloc/events_bloc.dart';
import 'package:balady_plus/app/features/events/presentation/bloc/events_event.dart';
import 'package:balady_plus/app/features/events/presentation/bloc/events_state.dart';
import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart' hide SearchBar, ScrollPosition;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/user_state.dart';
import 'package:mapness/_features/landing/providers/map_controls.dart';
import 'package:mapness/_features/landing/providers/search_by_rubrics.dart';
import 'package:mapness/_features/landing/widgets/challenge_card.dart';
import 'package:mapness/_features/landing/widgets/dashboard_header.dart';
import 'package:mapness/_features/landing/widgets/event_card.dart';
import 'package:mapness/_features/landing/widgets/g2b_card.dart';
import 'package:mapness/_features/landing/widgets/login_card.dart';
import 'package:mapness/_features/landing/widgets/poi_card.dart';
import 'package:mapness/_features/landing/widgets/prayer_card.dart';
import 'package:mapness/_features/landing/widgets/service_card.dart';
import 'package:mapness/_features/stories/stories_widget.dart';
import 'package:mapness/features/iwish/providers/iwish_markers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  late final PageController _pageController;

  double get _headerExtent => 75 / widget.biggestHeight;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: (widget.biggestWidth - 32) / widget.biggestWidth,
    );
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

  Widget _buildEvents(BuildContext context) {
    return BlocProvider(
      create: (context) => EventsBloc()..add(const GetSearchEvent()),
      child: BlocBuilder<EventsBloc, EventsState>(
        builder: (context, state) {
          final events = state.searchItems;

          return SizedBox(
            height: 200,
            child: PageView.builder(
              scrollDirection: Axis.horizontal,
              controller: _pageController,
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                final start = event.startDate;
                final startTimeString =
                    start != null ? '${start.hour}:${start.minute}' : '';
                final startDateString = start != null ? '${start.day}' : '';

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: EventCard(
                    title: event.eventName ?? 'Some error occured',
                    subtitle: '$startTimeString أكتوبر $startDateString',
                    image: event.logoImage ??
                        "https://mediaim.expedia.com/destination/9/89ee9cad281d840fba77bc3f253475f8.jpg",
                    imageUrl: event.logoImage ??
                        "https://mediaim.expedia.com/destination/9/89ee9cad281d840fba77bc3f253475f8.jpg",
                    id: state.searchItems[index].id ?? "",
                  ),
                );
              },
            ),
          );
        },
      ),
    );
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
                          Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Text(
                              context.l10n.events,
                              style: Theme.of(context)
                                  .extension<ThemeTextStyles>()!
                                  .textL,
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          _buildEvents(context),
                          const SizedBox(
                            height: 24,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Text(
                              context.l10n.events,
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
                            child: PrayerCard(),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Text(
                              context.l10n.prayerTime,
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
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: G2BCard(
                                color: const Color(0xFFE3393D),
                                title: "Appeals",
                                subtitle: "في نوفمبر",
                                onTap: () {
                                  // TODO(@42): Navigate to Appeals screen
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
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
                              height: 16,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: G2BCard(
                                color: const Color(0xFF1BA136),
                                title: "Compliance Certificate",
                                subtitle: "في نوفمبر",
                                onTap: () {
                                  // TODO(@42): Navigate to Compliance Certificate screen
                                },
                              ),
                            ),
                          ],
                          const SizedBox(
                            height: 16,
                          ),
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
