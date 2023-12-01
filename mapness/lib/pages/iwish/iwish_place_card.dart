import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/app/routes/iwish.dart';
import 'package:mapness/app/routes/routing.dart';
import 'package:mapness/features/iwish/providers/iwish_address.dart';
import 'package:mapness/features/iwish/providers/iwish_car_eta.dart';
import 'package:mapness/features/iwish/providers/iwish_distance.dart';
import 'package:mapness/features/iwish/providers/iwish_entity.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/buttons/labeled_elevated_button.dart';
import 'package:mapness/widgets/iwish/ui/iwish_actions.dart';
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
        final distance = ref.watch(iwishDistanceProvider(entity));
        final address = ref.watch(iwishAddressProvider(entity));
        final driveEta = ref.watch(iwishCarEtaProvider(entity));

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
                        onPressed: () => IwishFeedbackRoute(iwishId: iwishId)
                            .replace(context),
                        label: entity.feedbackSent
                            ? 'Wishes sent'
                            : 'Send feedback',
                      ),
                      const SizedBox(height: 16),
                      IwishActions(
                          driveLabel: driveEta,
                          onDrive: () {
                            RoutingRoutesRoute(
                              finishLabel: entity.title,
                              finishLatitude: entity.location.latitude,
                              finishLongitude: entity.location.longitude,
                              startLabel: 'My Location',
                              startLatitude: null,
                              startLongitude: null,
                            ).pushReplacement(context);
                          }

                          // onCall: callback,
                          // onEnter: callback,
                          // onShare: callback,
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
}
