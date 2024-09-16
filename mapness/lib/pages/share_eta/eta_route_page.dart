import 'package:balady_uikit/balady_uikit.dart' show Spacing;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/landing/widgets/zoom_control.dart';
import 'package:mapness/app/routes/routes.dart';
import 'package:mapness/features/share_eta/helpers/utils.dart';
import 'package:mapness/features/share_eta/providers/eta_geo_subscriber.dart';
import 'package:mapness/features/share_eta/providers/websocker_error_handler_porvider.dart';
import 'package:mapness/features/share_eta/ui/eta_arrival_card/eta_arrival_card.dart';
import 'package:mapness/shared/providers/map/camera_padding.dart';

class EtaRoutePage extends ConsumerStatefulWidget {
  final double? latitude;
  final double? longitude;
  const EtaRoutePage({
    super.key,
    this.latitude,
    this.longitude,
  });

  @override
  ConsumerState<EtaRoutePage> createState() => _EtaRoutePageState();
}

class _EtaRoutePageState extends ConsumerState<EtaRoutePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cameraPaddingProvider.notifier).resetPadding();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref
      ..watch(etaGeoSubscriberProvider)
      ..listen(websocketErrorHandlerProvider, (_, current) {
        final (code, reason) = current;

        final reasonData = reason?.toWebsocketReason();

        if (code == 1000 && [WebsocketReason.expired, WebsocketReason.manual].contains(reasonData)) {
          context.pop();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showEtaExpired(rootNavigatorKey.currentContext!);
          });
        }
        if (code == 4004) {
          context.pop();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showBroadcastExpired(rootNavigatorKey.currentContext!);
          });
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
