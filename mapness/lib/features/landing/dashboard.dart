import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapness/features/landing/providers/map_controls.dart';
import 'package:mapness/features/stories/stories_widget.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  ConsumerState<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> {
  late final DraggableScrollableController _draggableScrollableController;

  @override
  void initState() {
    _draggableScrollableController = DraggableScrollableController()
      ..addListener(() {
        if (_draggableScrollableController.size > .1) {
          ref.read(mapControlsProvider.notifier).update(
                MapControlsState.dashboard,
              );
        } else {
          ref.read(mapControlsProvider.notifier).update(
                MapControlsState.idle,
              );
        }
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: _draggableScrollableController,
      initialChildSize: .1,
      minChildSize: .1,
      maxChildSize: .9,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(16.0),
              topLeft: Radius.circular(16.0),
            ),
          ),
          child: ListView(
            controller: scrollController,
            padding: EdgeInsets.zero,
            physics: const ClampingScrollPhysics(),
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    Container(
                      height: 4,
                      width: 26,
                      decoration: const BoxDecoration(
                        color: Color(0xFFDDE4EE),
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                            color: Color(0xFFF1F4F8),
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(
                            "assets/icons/svg/ic_dashboard_menu.svg",
                            semanticsLabel: 'MinApps Screen',
                            package: "mapness",
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: Container(
                              height: 40,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                color: Color(0xFFF1F4F8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 8.0,
                              ),
                              child: Row(
                                children: [
                                  const Spacer(),
                                  const Text("إبحث فى الرياض"),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  SvgPicture.asset(
                                    "assets/icons/svg/ic_dashboard_search.svg",
                                    semanticsLabel: 'MinApps Screen',
                                    package: "mapness",
                                  ),
                                ],
                              )),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                          reverse: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          itemBuilder: (BuildContext context, int index) {
                            if (index == 0) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF1F4F8),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 10,
                                  ),
                                  child: SvgPicture.asset(
                                    "assets/icons/svg/ic_dashboard_fav.svg",
                                    semanticsLabel: 'MinApps Screen',
                                    package: "mapness",
                                  ),
                                ),
                              );
                            }
                            return Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Container(
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF1F4F8),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 10,
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.house),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        '12 دقيقة',
                                        style: GoogleFonts.notoSansArabic(
                                          textStyle: const TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            );
                          }),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
              Container(
                color: const Color(0xFFF1F4F8),
                padding: const EdgeInsets.only(
                  right: 16.0,
                  top: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const StoriesWidget(),
                    const SizedBox(
                      height: 16,
                    ),
                    Text('مثيرة للاهتمام بالنسبة لك',
                        style: GoogleFonts.notoSansArabic(
                          textStyle: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                        )),
                    const SizedBox(
                      height: 8,
                    ),
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                          reverse: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 8.0),
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
                                  crossAxisAlignment: CrossAxisAlignment.end,
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
                    Text(
                      'مثيرة للاهتمام بالنسبة لك',
                      style: GoogleFonts.notoSansArabic(
                        textStyle: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16.0,
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
                            const Spacer(),
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
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
