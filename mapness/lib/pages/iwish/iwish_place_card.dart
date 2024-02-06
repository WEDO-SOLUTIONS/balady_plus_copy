import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/app/routes/iwish.dart';
import 'package:mapness/app/routes/routing.dart';
import 'package:mapness/entities/iwish/models/iwish_entity.dart';
import 'package:mapness/features/iwish/providers/iwish_distance.dart';
import 'package:mapness/features/iwish/providers/iwish_entity.dart';
import 'package:mapness/features/routing/ui/brief_route_widgets.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:mapness/shared/providers/map/selected_marker.dart';
import 'package:mapness/shared/ui/buttons/labeled_elevated_button.dart';
import 'package:mapness/shared/ui/markers/markers.dart';
import 'package:mapness/shared/ui/sheets/error_sheet.dart';
import 'package:mapness/widgets/iwish/ui/iwish_about_park.dart';
import 'package:mapness/widgets/iwish/ui/iwish_info.dart';
import 'package:mapness/widgets/iwish/ui/iwish_photos_row.dart';
import 'package:mapness/widgets/iwish/ui/iwish_state_label.dart';

import '../../../shared/ui/sheets/loading_sheet.dart';
import 'map_controls.dart';

class IwishPlaceCard extends ConsumerWidget {
  final String iwishId;

  const IwishPlaceCard({required this.iwishId, Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entity = ref.watch(iwishEntityProvider(iwishId));
    final entityNotifier = ref.watch(iwishEntityProvider(iwishId).notifier);

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        const MapControls(),
        entity.when(
          error: (_, __) =>
              ErrorSheet(
                onRetry: () => entityNotifier.refresh(),
                buttonLabel: context.l10n.reload,
                onClose: () => context.pop(),
              ),
          loading: () =>
              LoadingSheet(
                text: context.l10n.loading,
              ),
          data: (entity) {
            final distance = ref.read(iwishDistanceProvider(entity));

            final metadata = entity.metadata;
            final showMetadata = entity.parkSize != ParkSize.unknown ||
                metadata.areaSize != 0 ||
                metadata.openingDate !=
                    DateTime.fromMillisecondsSinceEpoch(0) ||
                metadata.areaName != '';

            return SafeArea(
              bottom: false,
              child: DraggableScrollableSheet(
                minChildSize: 0.4,
                initialChildSize: 0.4,
                builder: (context, scrollController) =>
                    Column(
                      children: [
                        IwishPhotosRow(photos: entity.photos),
                        const SizedBox(height: 8),
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              // color: Colors.white,
                              color: Color(0xffF4F4F5),
                              borderRadius:
                              BorderRadius.vertical(top: Radius.circular(12)),
                            ),
                            child: SafeArea(
                              top: false,
                              child: ListView(
                                controller: scrollController,
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,

                                // mainAxisSize: MainAxisSize.min,
                                // crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(
                                      left: 16,
                                      right: 16,
                                      bottom: 16,
                                    ),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(12)),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                      children: [
                                        Align(
                                          alignment: Alignment.topCenter,
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                top: 8),
                                            height: 4,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                              borderRadius:
                                              BorderRadius.circular(2),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        IwishInfo(
                                          iwish: entity,
                                          distance: distance,
                                          onClose: () => context.pop(),
                                        ),
                                        const SizedBox(height: 8),
                                        IwishStateLabel(state: entity.state),
                                        const SizedBox(height: 16),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: LabeledElevatedButton(
                                                enabled: !entity.feedbackSent,
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                  vertical: 8,
                                                  horizontal: 9,
                                                ),
                                                onPressed: () async {
                                                  await CommonFunctions
                                                      .authOrOpen(
                                                      context, callback: () {
                                                    IwishFeedbackRoute(
                                                        iwishId: iwishId)
                                                        .replace(context);
                                                  });
                                                },
                                                label: entity.feedbackSent
                                                    ? context.l10n.wishesSent
                                                    : context.l10n.sendFeedback,
                                              ),
                                            ),
                                            BriefRouteButton(
                                              padding:
                                              const EdgeInsetsDirectional.only(
                                                start: 8,
                                              ),
                                              foreground: const Color(
                                                  0xFF1E2A36),
                                              background: const Color(
                                                  0x1F566B83),
                                              finishPoint: RouteSearchPointMessage(
                                                coordinates: GeoPointMessage(
                                                  latitude:
                                                  entity.location.latitude,
                                                  longitude:
                                                  entity.location.longitude,
                                                ),
                                                objectId: DgisObjectIdMessage(
                                                  objectId: 0,
                                                  entranceId: 0,
                                                ),
                                              ),
                                              onTap: () {
                                                RoutingRoutesRoute(
                                                  finishLabel: entity.title,
                                                  finishLatitude:
                                                  entity.location.latitude,
                                                  finishLongitude:
                                                  entity.location.longitude,
                                                  startLabel:
                                                  context.l10n.myLocation,
                                                  startLatitude: null,
                                                  startLongitude: null,
                                                ).pushReplacement(context);
                                              },
                                              routeType:
                                              RouteSearchOptionsMessage.car,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  if (showMetadata)
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: IwishAboutPark(
                                        metadata: entity.metadata,
                                        parkSize: entity.parkSize,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
              ),
            );
          },
        ),
      ],
    );
  }
}
