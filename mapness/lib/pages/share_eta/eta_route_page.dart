import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart' show Spacing;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/features/map_tap_handler/map_tap_handler_provider.dart';
import 'package:mapness/features/share_eta/helpers/constants.dart';
import 'package:mapness/features/share_eta/helpers/utils.dart';
import 'package:mapness/features/share_eta/providers/eta_geo_subscriber.dart';
import 'package:mapness/features/share_eta/providers/eta_websocket_status_provider.dart';
import 'package:mapness/features/share_eta/providers/websocker_error_handler_porvider.dart';
import 'package:mapness/features/share_eta/ui/eta_arrival_card/eta_arrival_card.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/map/camera_padding.dart';
import 'package:mapness/shared/providers/media_query.dart';
import 'package:mapness/shared/ui/toast/toast_overlay.dart';
import 'package:mapness/widgets/landing/zoom_control.dart';

@RoutePage()
class EtaRoutePage extends ConsumerStatefulWidget {
  static const latKey = 'lat';
  static const lonKey = 'lon';

  final double? latitude;
  final double? longitude;
  const EtaRoutePage({
    super.key,
    @PathParam(latKey) this.latitude,
    @PathParam(lonKey) this.longitude,
  });

  @override
  ConsumerState<EtaRoutePage> createState() => _EtaRoutePageState();
}

class _EtaRoutePageState extends ConsumerState<EtaRoutePage> {
  Timer? _etaExpiredTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cameraPaddingProvider.notifier).resetPadding();
      // Prevents the user from interacting with the map
      if (ref.read(mediaQueryInfoProvider)?.orientation == Orientation.landscape) {
        ref.read(mapTapHandlerProvider.notifier).disableTapOnMap = true;
      }
    });
  }

  @override
  void deactivate() {
    ref.read(mapTapHandlerProvider.notifier).disableTapOnMap = false;
    super.deactivate();
  }

  @override
  void dispose() {
    _etaExpiredTimer?.cancel();
    _etaExpiredTimer = null;
    ToastOverlay.of(rootNavigatorKey.currentContext!).hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref
      ..watch(etaGeoSubscriberProvider)
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

        if (code != EtaErrorStatusCodes.noDataInStream && _etaExpiredTimer != null) {
          _etaExpiredTimer?.cancel();
          _etaExpiredTimer = null;
          ToastOverlay.of(rootNavigatorKey.currentContext!).hide();
        }

        if (code == EtaErrorStatusCodes.endConnection &&
            [WebsocketReason.expired, WebsocketReason.manual].contains(reasonData)) {
          context.router.pop();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showEtaExpired(rootNavigatorKey.currentContext!);
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
            if (context.mounted) {
              context.router.pop();
            }

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

    final direction = Directionality.of(context);

    return Material(
      color: Colors.transparent,
      type: MaterialType.transparency,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Spacer(),
            const Padding(
              padding: EdgeInsets.all(Spacing.$4x),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ZoomControl(),
                ],
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Directionality(textDirection: direction, child: const EtaArrivalCard()),
            ),
          ],
        ),
      ),
    );
  }

  void _showEtaExpired(BuildContext context) {
    EtaUtils.showEtaExpired(context);
  }

  void _showBroadcastExpired(BuildContext context) {
    EtaUtils.showBroadcastExpired(context);
  }
}
