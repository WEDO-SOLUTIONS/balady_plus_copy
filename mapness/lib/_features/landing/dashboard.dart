import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart' hide SearchBar, ScrollPosition;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/user_state.dart';
import 'package:mapness/_features/landing/providers/map_controls.dart';
import 'package:mapness/_features/landing/widgets/challenge_card.dart';
import 'package:mapness/_features/landing/widgets/dashboard_header.dart';
import 'package:mapness/_features/landing/widgets/event_card.dart';
import 'package:mapness/_features/landing/widgets/g2b_card.dart';
import 'package:mapness/_features/landing/widgets/login_card.dart';
import 'package:mapness/_features/landing/widgets/poi_card.dart';
import 'package:mapness/_features/landing/widgets/prayer_card.dart';
import 'package:mapness/_features/stories/stories_widget.dart';
import 'package:mapness/pages/iwish/ui/iwish_dashboard_widget.dart';
import 'package:mapness/shared/config/package_fonts.dart';

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
  late final PageController _pageController;

  double _headerExtent() {
    return 75 / widget.biggestHeight;
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: (widget.biggestWidth - 32) / widget.biggestWidth,
    );
    _draggableScrollableController = DraggableScrollableController()
      ..addListener(() {
        Future.delayed(Duration.zero, () {
          if (_draggableScrollableController.size > _headerExtent()) {
            ref.watch(mapControlsProvider.notifier).update(
                  MapControlsStateDashboard(),
                );
          } else {
            ref.watch(mapControlsProvider.notifier).update(
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
    final userState = ref.watch(userStateProvider);

    return DraggableScrollableSheet(
      controller: _draggableScrollableController,
      initialChildSize: _headerExtent(),
      minChildSize: _headerExtent(),
      maxChildSize: .9,
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
              // padding: EdgeInsets.zero,
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
                          const SizedBox(
                            height: 24,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 16.0,
                            ),
                            child: Text(
                              'أماكن للزيارة',
                              style: PackageFonts.frutigerArabic(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          SizedBox(
                            height: 200,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              children: [
                                PoiCard(
                                  objectId: DgisObjectIdMessage(
                                    objectId: 70000001079215988,
                                    entranceId: 0,
                                  ),
                                  title: "Boulevard\nRiyadh City",
                                  subtitle: "23 كم",
                                  image:
                                      "assets/images/poi_boulevard_riyadh_city.png",
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                PoiCard(
                                  objectId: DgisObjectIdMessage(
                                    objectId: 70030076256609771,
                                    entranceId: 0,
                                  ),
                                  title: "Kingdom\nCenter",
                                  subtitle: "5 كم",
                                  image: "assets/images/poi_kingdom_center.png",
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                PoiCard(
                                  objectId: DgisObjectIdMessage(
                                    objectId: 70030076201501940,
                                    entranceId: 0,
                                  ),
                                  title: "Faisaliya\nTower",
                                  subtitle: "5 كم",
                                  image:
                                      "assets/images/poi_faisaliya_tower.png",
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                PoiCard(
                                  objectId: DgisObjectIdMessage(
                                    objectId: 70000001079216136,
                                    entranceId: 0,
                                  ),
                                  title: "Masmak\nFortress",
                                  subtitle: "5 كم",
                                  image:
                                      "assets/images/poi_masmak_fortress.png",
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                PoiCard(
                                  objectId: DgisObjectIdMessage(
                                    objectId: 70030076419526924,
                                    entranceId: 0,
                                  ),
                                  title: "Edge of the\nworld",
                                  subtitle: "5 كم",
                                  image:
                                      "assets/images/poi_edge_of_the_world.png",
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Text(
                              'الفعاليات',
                              style: PackageFonts.frutigerArabic(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          SizedBox(
                            height: 200,
                            child: PageView(
                              scrollDirection: Axis.horizontal,
                              controller: _pageController,
                              children: const [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4),
                                  child: EventCard(
                                    title: "الأحداث",
                                    subtitle: "25 أكتوبر 21:00",
                                    image: "assets/images/event_0.png",
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4),
                                  child: EventCard(
                                    title: "سباق الخيل",
                                    subtitle: "5 أكتوبر 13:00",
                                    image: "assets/images/event_1.png",
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4),
                                  child: EventCard(
                                    title: "معرض الصحة العالمية 2023",
                                    subtitle: "29-31 أكتوبر",
                                    image: "assets/images/event_2.png",
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Text(
                              'الفعاليات',
                              style: PackageFonts.frutigerArabic(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
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
                              ' أوقات الصلاة',
                              style: PackageFonts.frutigerArabic(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
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
                              'سجل للحصول على الفرص',
                              style: PackageFonts.frutigerArabic(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
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
                              "تسجيل الدخول للوصول الى",
                              style: PackageFonts.frutigerArabic(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: IwishDashboardWidget(),
                          ),
                          if (userState == UserState.business) ...[
                            const SizedBox(
                              height: 24,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: Text(
                                "مثيرة للاهتمام بالنسبة لك",
                                style: PackageFonts.frutigerArabic(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
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
