import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapness/features/landing/providers/dashboard_controls.dart';
import 'package:mapness/features/landing/providers/map_controls.dart';
import 'package:mapness/features/landing/widgets/dashboard_header.dart';
import 'package:mapness/features/landing/widgets/favorites.dart';
import 'package:mapness/features/landing/widgets/search_bar.dart';
import 'package:mapness/features/landing/widgets/search_groups.dart';
import 'package:mapness/features/landing/widgets/search_results.dart';
import 'package:mapness/features/landing/widgets/suggest_list.dart';
import 'package:mapness/features/stories/stories_widget.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({
    super.key,
    required this.dashboardKey,
  });

  final GlobalKey<DashboardState> dashboardKey;

  @override
  ConsumerState<Dashboard> createState() => DashboardState();
}

class DashboardState extends ConsumerState<Dashboard> {
  late final DraggableScrollableController _draggableScrollableController;

  @override
  void initState() {
    _draggableScrollableController = DraggableScrollableController()
      ..addListener(() {
        if (_draggableScrollableController.size > .1) {
          ref.watch(mapControlsProvider.notifier).update(
                MapControlsState.dashboard,
              );
        } else {
          ref.watch(mapControlsProvider.notifier).update(
                MapControlsState.idle,
              );
          FocusManager.instance.primaryFocus?.unfocus();
        }
      });
    super.initState();
  }

  void expand() {
    _draggableScrollableController.animateTo(
      .9,
      duration: const Duration(milliseconds: 250),
      curve: Curves.linear,
    );
  }

  void collapse({double to = .1}) {
    _draggableScrollableController.animateTo(
      to,
      duration: const Duration(milliseconds: 250),
      curve: Curves.linear,
    );
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(dashboardControlsProvider);

    return DraggableScrollableSheet(
      controller: _draggableScrollableController,
      initialChildSize: .1,
      minChildSize: .1,
      maxChildSize: .9,
      builder: (BuildContext context, ScrollController scrollController) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            decoration: BoxDecoration(
              color: dashboardState == DashboardControlsState.results
                  ? const Color(0xFFF1F4F8)
                  : Colors.white,
              borderRadius: const BorderRadius.only(
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
                    dashboardKey: widget.dashboardKey,
                    dashboardState: dashboardState,
                  ),
                  pinned: true,
                ),
                SliverList.list(
                  children: [
                    if (dashboardState == DashboardControlsState.searching)
                      const SearchGroups(),
                    if (dashboardState == DashboardControlsState.suggests)
                      const SuggestList(),
                    if (dashboardState == DashboardControlsState.results)
                      const SearchResults(),
                    if (dashboardState == DashboardControlsState.idle)
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
                              height: 16,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 16.0,
                              ),
                              child: Text(
                                'مثيرة للاهتمام بالنسبة لك',
                                style: GoogleFonts.notoSansArabic(
                                  textStyle: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            SizedBox(
                              height: 150,
                              child: ListView.builder(
                                  reverse: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 10,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        left: 8.0,
                                        right: index == 9 ? 8 : 0,
                                      ),
                                      child: Container(
                                        height: 150,
                                        width: 335,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFDDE4EE),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 20,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Spacer(),
                                            Text(
                                              'الأحداث',
                                              style: GoogleFonts.notoSansArabic(
                                                textStyle: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              'في نوفمبر',
                                              style: GoogleFonts.notoSansArabic(
                                                textStyle: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.normal,
                                                  color: Color(0xFF7D9CBD),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: Text(
                                'مثيرة للاهتمام بالنسبة لك',
                                style: GoogleFonts.notoSansArabic(
                                  textStyle: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 16.0,
                                right: 16.0,
                                bottom: 38,
                              ),
                              child: Container(
                                height: 200,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFDDE4EE),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 20,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Column(
                                      children: [
                                        const Spacer(),
                                        Text(
                                          'الأحداث',
                                          style: GoogleFonts.notoSansArabic(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          'في نوفمبر',
                                          style: GoogleFonts.notoSansArabic(
                                            textStyle: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                              color: Color(0xFF7D9CBD),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Container(
                                      height: 38,
                                      width: 114,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                        color: Color(0xFF7D9CBD),
                                      ),
                                      padding: const EdgeInsets.all(10.0),
                                      child: const Center(
                                        child: Text("Login"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(
                      height: 16,
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
