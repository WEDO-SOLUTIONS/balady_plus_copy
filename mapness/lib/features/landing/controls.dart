import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapness/features/landing/providers/map_controls.dart';
import 'package:mapness/features/landing/widgets/compass_control.dart';
import 'package:mapness/features/landing/widgets/follow_control.dart';
import 'package:mapness/features/landing/widgets/layers_control.dart';
import 'package:mapness/features/landing/layers_sheet.dart';
import 'package:mapness/features/landing/widgets/map_control.dart';
import 'package:mapness/features/landing/widgets/traffic_control.dart';
import 'package:mapness/features/landing/widgets/zoom_control.dart';

class MapControls extends ConsumerWidget {
  const MapControls({Key? key, required this.layersState}) : super(key: key);

  final GlobalKey<LayersSheetState> layersState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controlsState = ref.watch(mapControlsProvider);

    return AnimatedSize(
      curve: Curves.decelerate,
      duration: const Duration(milliseconds: 1000),
      reverseDuration: const Duration(milliseconds: 1000),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 64,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LayersControl(layerState: layersState),
                      const SizedBox(
                        width: 8,
                      ),
                      const TrafficControl(),
                      const Spacer(),
                      MapControl(
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              const Text("53°"),
                              const SizedBox(
                                width: 8,
                              ),
                              SvgPicture.asset(
                                "assets/icons/svg/ic_control_temp.svg",
                                semanticsLabel: 'MinApps Screen',
                                package: "mapness",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .2,
                  ),
                  const ZoomControl(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .1,
                  ),
                  const CompassControl(),
                  const SizedBox(
                    height: 8,
                  ),
                  const FollowControl(),
                  const Spacer(),
                ],
              ),
            ),
          ),
          controlsState == MapControlsState.idle
              ? SizedBox(
                  height: 40,
                  child: ListView.builder(
                    reverse: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
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
                              color: Colors.white,
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
                    },
                  ),
                )
              : const SizedBox.shrink(),
          SizedBox(
            height: MediaQuery.of(context).size.height * .1,
          ),
        ],
      ),
    );
  }
}
