import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapness/features/landing/providers/map_controls.dart';
import 'package:mapness/legacy_features/poi_card/extensions/week_day_ext.dart';
import 'package:mapness/legacy_features/poi_card/extensions/week_time_interval_ext.dart';
import 'package:mapness/features/map/providers/point_of_interest.dart';
import 'package:mapness/legacy_features/poi_card/widgets/shimmer.dart';
import 'package:mapness/legacy_features/routing_page/data/directory_object_ext.dart';
import 'package:collection/collection.dart';

class GeneralMapCardWidget extends ConsumerWidget {
  final DgisObjectIdMessage objectId;

  const GeneralMapCardWidget(
    this.objectId, {
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<DirectoryObjectMessage?> state = ref.watch(
      pointOfInterestProvider(objectId),
    );

    return state.map(
      data: (value) {
        final dataPoint = value.value!;

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x1C77758D),
                        blurRadius: 22,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Column(
                          children: [
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                          end: 16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            dataPoint.address?.buildingName ??
                                                dataPoint.title,
                                            style: GoogleFonts.inter(
                                              color: Colors.black87,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            textAlign: TextAlign.start,
                                          ),
                                          const SizedBox(
                                            height: 11,
                                          ),
                                          if (dataPoint.workStatus?.isOpen ==
                                              true)
                                            Text(
                                              "open",
                                              style: GoogleFonts.inter(
                                                color: const Color(0xFFA7C587),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          if (dataPoint.workStatus?.isOpen ==
                                              true)
                                            const SizedBox(
                                              height: 10,
                                            ),
                                          Text(
                                            dataPoint.makeAddress(),
                                            style: GoogleFonts.inter(
                                              color: Colors.black54,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              height: 1.3,
                                            ),
                                            maxLines: 2,
                                            textAlign: TextAlign.start,
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ]),
                            const SizedBox(height: 16),
                            Row(
                              children: dataPoint.openingHours?.values
                                      .where((e) => e!.values.isNotEmpty)
                                      .map(
                                        (e) => Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                e!.values[0]!.startTime.weekDay
                                                    .displayName(),
                                                style: GoogleFonts.inter(
                                                  color: Colors.black87,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                textAlign: TextAlign.start,
                                              ),
                                              ...e.values
                                                  .map((e) => [
                                                        const SizedBox(
                                                          height: 6,
                                                        ),
                                                        Text(
                                                          e!.displayStartTime(),
                                                          style:
                                                              GoogleFonts.inter(
                                                            color:
                                                                Colors.black54,
                                                            fontSize: 6,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 5,
                                                          textAlign:
                                                              TextAlign.start,
                                                          textDirection:
                                                              TextDirection.ltr,
                                                        ),
                                                        Text(
                                                          e.displayFinishTime(),
                                                          style:
                                                              GoogleFonts.inter(
                                                            color:
                                                                Colors.black54,
                                                            fontSize: 6,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 5,
                                                          textAlign:
                                                              TextAlign.start,
                                                          textDirection:
                                                              TextDirection.ltr,
                                                        ),
                                                      ])
                                                  .toList()
                                                  .flattened,
                                            ],
                                          ),
                                        ),
                                      )
                                      .toList() ??
                                  [],
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: GestureDetector(
                          onTap: () {
                            ref
                                .watch(mapControlsProvider.notifier)
                                .update(MapControlsStateIdle());
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                              color: Colors.white,
                            ),
                            padding: const EdgeInsets.all(8.0),
                            child: SvgPicture.asset(
                              "assets/icons/svg/ic_search_close.svg",
                              semanticsLabel: 'MinApps Screen',
                              package: "mapness",
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      error: (_) => const Column(
        children: [
          Spacer(),
          ShimmerEffectWidget(
            height: 120,
          ),
        ],
      ),
      loading: (_) => const Column(
        children: [
          Spacer(),
          ShimmerEffectWidget(
            height: 120,
          ),
        ],
      ),
    );
  }
}
