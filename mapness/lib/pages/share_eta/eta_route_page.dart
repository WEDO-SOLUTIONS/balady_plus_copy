import 'package:balady_uikit/balady_uikit.dart' show Spacing;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/landing/widgets/zoom_control.dart';
import 'package:mapness/app/routes/routes.dart';
import 'package:mapness/features/share_eta/providers/eta_geo_subscriber.dart';
import 'package:mapness/features/share_eta/providers/websocker_error_handler_porvider.dart';
import 'package:mapness/features/share_eta/ui/eta_arrival_card/eta_arrival_card.dart';
import 'package:mapness/features/share_eta/ui/eta_share_expired.dart';

class EtaRoutePage extends ConsumerWidget {
  const EtaRoutePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref
      ..watch(etaGeoSubscriberProvider)
      ..listen(websocketErrorHandlerProvider, (_, current) {
        final (code, reason) = current;

        if (code == 1000 && reason == 'expired') {
          context.pop();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showEtaExpired(rootNavigatorKey.currentContext!);
          });
        }
      });

    return const Material(
      color: Colors.transparent,
      type: MaterialType.transparency,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Spacer(),
          Padding(
            padding: EdgeInsets.all(Spacing.$4x),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ZoomControl(),
              ],
            ),
          ),
          Spacer(),
          Align(
            alignment: Alignment.bottomCenter,
            child: EtaArrivalCard(),
          ),
        ],
      ),
    );
  }

  void _showEtaExpired(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (_) => EtaShareExpired.eta(context),
    );
  }
}
