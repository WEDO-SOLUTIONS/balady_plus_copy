import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/app/routes/iwish.dart';
import 'package:mapness/app/routes/routing.dart';
import 'package:mapness/app/routes/signin.dart';
import 'package:mapness/features/iwish/providers/iwish_address.dart';
import 'package:mapness/features/iwish/providers/iwish_distance.dart';
import 'package:mapness/features/iwish/providers/iwish_entity.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/features/routing/ui/brief_route_widgets.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/buttons/labeled_elevated_button.dart';
import 'package:mapness/shared/ui/sheets/error_sheet.dart';
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
        final address = ref.read(iwishAddressProvider(entity));

        // TODO: replace with actions when will be required
        void callback() {}

        return Align(
          alignment: Alignment.bottomCenter,
          child: Material(
            type: MaterialType.transparency,
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                IwishPhotosRow(photos: entity.photos),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IwishInfo(
                        iwish: entity,
                        distance: distance,
                        address: address,
                        onClose: () => context.pop(),
                      ),
                      const SizedBox(height: 16),
                      LabeledElevatedButton(
                        enabled: !entity.feedbackSent,
                        onPressed: () async {
                          if (!await _isAuth(ref)) {
                            await const SignInRoute().push(context);
                          }
                          if (await _isAuth(ref)) {
                            IwishFeedbackRoute(iwishId: iwishId)
                                .replace(context);
                          }
                        },
                        label: entity.feedbackSent
                            ? context.l10n.wishesSent
                            : context.l10n.sendFeedback,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 41,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            BriefRouteButton(
                              finishPoint: RouteSearchPointMessage(
                                coordinates: GeoPointMessage(
                                  latitude: entity.location.latitude,
                                  longitude: entity.location.longitude,
                                ),
                                objectId: DgisObjectIdMessage(
                                  objectId: 0,
                                  entranceId: 0,
                                ),
                              ),
                              onTap: () {
                                RoutingRoutesRoute(
                                  finishLabel: entity.title,
                                  finishLatitude: entity.location.latitude,
                                  finishLongitude: entity.location.longitude,
                                  startLabel: context.l10n.myLocation,
                                  startLatitude: null,
                                  startLongitude: null,
                                ).pushReplacement(context);
                              },
                              routeType: RouteSearchOptionsMessage.car,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool> _isAuth(WidgetRef ref) async {
    final sso = await ref.read(authProvider.future);
    return sso != null;
  }
}
