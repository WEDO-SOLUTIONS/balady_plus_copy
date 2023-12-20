import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/app/routes/iwish.dart';
import 'package:mapness/features/iwish/providers/iwish_distance.dart';
import 'package:mapness/features/iwish/providers/iwish_entity.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:mapness/shared/ui/buttons/labeled_elevated_button.dart';
import 'package:mapness/shared/ui/sheets/error_sheet.dart';
import 'package:mapness/widgets/iwish/ui/iwish_about_park.dart';
import 'package:mapness/widgets/iwish/ui/iwish_info.dart';
import 'package:mapness/widgets/iwish/ui/iwish_photos_row.dart';

import '../../../shared/ui/sheets/loading_sheet.dart';

class IwishPlaceCard extends ConsumerWidget {
  final String iwishId;
  const IwishPlaceCard({required this.iwishId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entity = ref.watch(iwishEntityProvider(iwishId));
    final entityNotifier = ref.watch(iwishEntityProvider(iwishId).notifier);

    return entity.when(
      error: (_, __) => ErrorSheet(
        onRetry: () => entityNotifier.refresh(),
        buttonLabel: context.l10n.reload,
        onClose: () => context.pop(),
      ),
      loading: () => LoadingSheet(
        text: context.l10n.loading,
      ),
      data: (entity) {
        final distance = ref.read(iwishDistanceProvider(entity));

        return SafeArea(
          bottom: false,
          child: DraggableScrollableSheet(
            minChildSize: 0.35,
            initialChildSize: 0.35,
            builder: (context, scrollController) => Column(
              children: [
                IwishPhotosRow(photos: entity.photos),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      // color: Colors.white,
                      color: Color(0xffF4F4F5),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(12)),
                    ),
                    child: ListView(
                      controller: scrollController,
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,

                      // mainAxisSize: MainAxisSize.min,
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(12)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              IwishInfo(
                                iwish: entity,
                                distance: distance,
                                onClose: () => context.pop(),
                              ),
                              const SizedBox(height: 16),
                              LabeledElevatedButton(
                                enabled: !entity.feedbackSent,
                                onPressed: () async {
                                  CommonFunctions.authOrOpen(ref, context,
                                      callback: () {
                                    IwishFeedbackRoute(iwishId: iwishId)
                                        .replace(context);
                                  });
                                },
                                label: entity.feedbackSent
                                    ? context.l10n.wishesSent
                                    : context.l10n.sendFeedback,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // SizedBox(
                        //   height: 41,
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.start,
                        //     children: [
                        //       BriefRouteButton(
                        //         finishPoint: RouteSearchPointMessage(
                        //           coordinates: GeoPointMessage(
                        //             latitude: entity.location.latitude,
                        //             longitude: entity.location.longitude,
                        //           ),
                        //           objectId: DgisObjectIdMessage(
                        //             objectId: 0,
                        //             entranceId: 0,
                        //           ),
                        //         ),
                        //         onTap: () {
                        //           RoutingRoutesRoute(
                        //             finishLabel: entity.title,
                        //             finishLatitude: entity.location.latitude,
                        //             finishLongitude: entity.location.longitude,
                        //             startLabel: context.l10n.myLocation,
                        //             startLatitude: null,
                        //             startLongitude: null,
                        //           ).pushReplacement(context);
                        //         },
                        //         routeType: RouteSearchOptionsMessage.car,
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IwishAboutPark(metadata: entity.metadata),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
