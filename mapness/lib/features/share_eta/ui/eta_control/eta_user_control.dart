import 'dart:async';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/features/share_eta/helpers/constants.dart';
import 'package:mapness/features/share_eta/helpers/utils.dart';
import 'package:mapness/features/share_eta/models/eta_info_model.dart';
import 'package:mapness/features/share_eta/models/eta_route_info.dart';
import 'package:mapness/features/share_eta/providers/eta_geo_subscriber.dart';
import 'package:mapness/features/share_eta/providers/eta_websocket_status_provider.dart';
import 'package:mapness/features/share_eta/providers/websocker_error_handler_porvider.dart';
import 'package:mapness/features/share_eta/ui/eta_control/user_pin_control.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/ui/toast/toast_overlay.dart';

class EtaUserControl extends ConsumerStatefulWidget {
  const EtaUserControl({super.key});

  @override
  ConsumerState<EtaUserControl> createState() => _EtaUserControlState();
}

class _EtaUserControlState extends ConsumerState<EtaUserControl> {
  Timer? _etaExpiredTimer;

  @override
  void dispose() {
    _etaExpiredTimer?.cancel();
    _etaExpiredTimer = null;
    ToastOverlay.of(rootNavigatorKey.currentContext!).hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final (info, metaInfo) = ref.watch(etaGeoSubscriberProvider);

    ref
      ..listen(etaWebsocketStatusProvider, (_, current) {
        final connected = current;

        if (!connected && _etaExpiredTimer != null) {
          _etaExpiredTimer?.cancel();
          _etaExpiredTimer = null;
          ToastOverlay.of(rootNavigatorKey.currentContext!).hide();
        }
      })
      ..listen(websocketErrorHandlerProvider, (_, current) {
        final (code, reason) = current;

        final reasonData = reason?.toWebsocketReason();
        final (_, meta) = ref.read(etaGeoSubscriberProvider);

        final payload = meta?.payload;

        if (payload?.type != StreamType.geo) {
          return;
        }

        if (code == EtaErrorStatusCodes.endConnection &&
            [WebsocketReason.expired, WebsocketReason.manual].contains(reasonData)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showLiveLocationExpired(rootNavigatorKey.currentContext!);
          });
        } else if (code == EtaErrorStatusCodes.noDataInStream) {
          if (_etaExpiredTimer != null) {
            return;
          }
          ToastOverlay.of(rootNavigatorKey.currentContext!).show(
              title: context.l10n.restoringConnection,
              isDismissible: false,
              displayDuration: const Duration(seconds: 30));
          _etaExpiredTimer = Timer(const Duration(seconds: 30), () async {
            _etaExpiredTimer?.cancel();
            _etaExpiredTimer = null;
            await ref.read(etaGeoSubscriberProvider.notifier).stopStreaming();

            ToastOverlay.of(rootNavigatorKey.currentContext!).hide();

            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showBroadcastExpired(rootNavigatorKey.currentContext!);
            });
          });
        } else if (code == null) {
          if (_etaExpiredTimer != null) {
            _etaExpiredTimer?.cancel();
            _etaExpiredTimer = null;
            ToastOverlay.of(rootNavigatorKey.currentContext!).hide();
          }
        }
      });

    return MapButton(
      onTap: () async {
        if (info != null) {
          final payload = info.payload as EtaInfoPayload?;
          if (payload?.lat != null && payload?.lon != null) {
            final lat = payload!.lat!;
            final lon = payload.lon!;
            const zoom = 17.0;
            const tilt = 0.0;
            const bearing = 0.0;

            final cameraPositionController = ref.read(cameraPositionProvider.notifier);
            await cameraPositionController.animateTo(
              CameraPositionMessage(
                point: GeoPointMessage(latitude: lat, longitude: lon),
                zoom: zoom,
                tilt: tilt,
                bearing: bearing,
              ),
            );
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.$2x),
        child: UserPinControl(user: metaInfo?.payload?.user),
      ),
    );
  }

  void _showLiveLocationExpired(BuildContext context) {
    EtaUtils.showLiveLocationExpired(context);
  }

  void _showBroadcastExpired(BuildContext context) {
    EtaUtils.showBroadcastExpired(context);
  }
}
