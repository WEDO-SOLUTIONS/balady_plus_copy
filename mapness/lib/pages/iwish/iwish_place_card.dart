import 'package:balady_uikit/core/colors/non_theme_colors.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/app/routes/iwish.dart';
import 'package:mapness/app/routes/routing.dart';
import 'package:mapness/entities/iwish/models/iwish_entity.dart';
import 'package:mapness/entities/routing/route_search_point.dart';
import 'package:mapness/features/iwish/providers/iwish_distance.dart';
import 'package:mapness/features/iwish/providers/iwish_entity.dart';
import 'package:mapness/features/routing/ui/brief_route_widgets.dart';
import 'package:mapness/pages/iwish/map_controls.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:mapness/shared/ui/buttons/labeled_elevated_button.dart';
import 'package:mapness/shared/ui/sheets/error_sheet.dart';
import 'package:mapness/shared/ui/sheets/loading_sheet.dart';
import 'package:mapness/widgets/iwish/ui/iwish_about_park.dart';
import 'package:mapness/widgets/iwish/ui/iwish_info.dart';
import 'package:mapness/widgets/iwish/ui/iwish_photos_row.dart';
import 'package:mapness/widgets/iwish/ui/iwish_state_label.dart';

class IwishPlaceCard extends ConsumerWidget {
  const IwishPlaceCard({required this.iwishId, super.key});

  final String iwishId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entity = ref.watch(iwishEntityProvider(iwishId));
    final entityNotifier = ref.watch(iwishEntityProvider(iwishId).notifier);

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        const MapControls(),
        entity.when(
          error: (_, __) => ErrorSheet(
            onRetry: entityNotifier.refresh,
            buttonLabel: context.l10n.tryAgain,
          ),
          loading: () => const LoadingSheet(),
          data: (entity) {
            final distance = ref.read(iwishDistanceProvider(entity));

            final metadata = entity.metadata;
            final showMetadata = entity.parkSize != ParkSize.unknown ||
                metadata.areaSize != 0 ||
                metadata.openingDate != DateTime.fromMillisecondsSinceEpoch(0) ||
                metadata.areaName != '';

            final minSheetSize = entity.photos.isEmpty ? 0.25 : 0.4;

            return SafeArea(
              bottom: false,
              child: DraggableScrollableSheet(
                initialChildSize: minSheetSize,
                minChildSize: minSheetSize,
                builder: (context, scrollController) => Column(
                  children: [
                    if (entity.photos.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: IwishPhotosRow(photos: entity.photos),
                      ),
                    Expanded(
                      child: Material(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: context.color.surfaceBasePrimary,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          ),
                          child: ListView(
                            controller: scrollController,
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
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
                                    top: Radius.circular(12),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    const Align(
                                      alignment: Alignment.topCenter,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 8),
                                        child: SheetDragger(),
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
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 8,
                                              horizontal: 9,
                                            ),
                                            onPressed: () async {
                                              await CommonFunctions.authOrOpen(
                                                context,
                                                callback: () {
                                                  IwishFeedbackRoute(
                                                    iwishId: iwishId,
                                                  ).replace(context);
                                                },
                                              );
                                            },
                                            label: entity.feedbackSent
                                                ? context.l10n.wishesSent
                                                : context.l10n.sendFeedback,
                                          ),
                                        ),
                                        BriefRouteButton(
                                          padding: const EdgeInsetsDirectional.only(start: 8),
                                          foreground: context.color.textAndIconsBasePrimary,
                                          background: NonThemeColor.color60,
                                          finishPoint: RouteSearchPoint(
                                            coordinates: GeoPointMessage(
                                              latitude: entity.location.latitude,
                                              longitude: entity.location.longitude,
                                            ),
                                            dgisObjectId: DgisObjectIdMessage(objectId: 0, entranceId: 0),
                                          ),
                                          onTap: () {
                                            RoutingRoutesRoute(
                                              finishLabel: entity.title,
                                              finishLatitude: entity.location.latitude,
                                              finishLongitude: entity.location.longitude,
                                              finishObjectId: 0,
                                              finishEntranceId: 0,
                                              finishLevelId: null,
                                              startLabel: context.l10n.myLocation,
                                              startLatitude: null,
                                              startLongitude: null,
                                              startObjectId: null,
                                              startEntranceId: null,
                                              startLevelId: null,
                                            ).pushReplacement(context);
                                          },
                                          routeType: RouteSearchOptionsMessage.car,
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
                                    horizontal: 16,
                                  ),
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
