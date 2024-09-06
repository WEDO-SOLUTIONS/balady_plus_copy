import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/features/share_eta/models/eta_stream_payload.dart';
import 'package:mapness/features/share_eta/models/ws_config.dart';
import 'package:mapness/features/share_eta/providers/eta_websocket_status_provider.dart';
import 'package:mapness/features/share_eta/providers/share_eta_provider.dart';
import 'package:mapness/features/share_eta/providers/websocket_type_provider.dart';
import 'package:mapness/features/share_eta/ui/eta_control/eta_timer_control.dart';
import 'package:mapness/features/share_eta/ui/eta_control/eta_user_control.dart';

class EtaSharingControl extends ConsumerWidget {
  const EtaSharingControl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final webSocketStatus = ref.watch(etaWebsocketStatusProvider);
    final webSocketType = ref.watch(websocketTypeProvider);
    final shareEtaType = ref.watch(shareEtaProvider);

    return AnimatedSwitcher(
      key: const Key('eta_sharing_control'),
      duration: const Duration(milliseconds: 250),
      child: webSocketStatus
          ? webSocketType == SubscriptionType.share && shareEtaType == EtaStreamType.geo
              ? const EtaTimerControl()
              : const EtaUserControl()
          : const SizedBox.shrink(),
    );
  }
}
