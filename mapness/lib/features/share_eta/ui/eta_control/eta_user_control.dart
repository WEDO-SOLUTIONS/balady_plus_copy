import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/features/share_eta/providers/eta_geo_subscriber.dart';
import 'package:mapness/features/share_eta/ui/eta_control/user_pin_control.dart';
import 'package:mapness/features/share_eta/ui/eta_share_control_sheet/eta_watching_sheet.dart';

class EtaUserControl extends ConsumerWidget {
  const EtaUserControl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (_, metaInfo) = ref.read(etaGeoSubscriberProvider);

    return MapButton(
      onTap: () async {
        _showStopWatchingSheet(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.$2x),
        child: UserPinControl(user: metaInfo?.payload?.user),
      ),
    );
  }

  void _showStopWatchingSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (context) => Consumer(
        builder: (context, ref, _) => EtaWatchingSheet(
          onStopWatchingPressed: () {
            ref.read(etaGeoSubscriberProvider.notifier).stopStreaming();
            context.pop();
          },
        ),
      ),
    );
  }
}
