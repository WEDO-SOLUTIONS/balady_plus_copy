import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/features/share_eta/models/eta_stream_payload.dart';
import 'package:mapness/features/share_eta/providers/eta_service_provider.dart';
import 'package:mapness/features/share_eta/providers/eta_websocket_status_provider.dart';
import 'package:mapness/features/share_eta/providers/share_eta_provider.dart';
import 'package:mapness/features/share_eta/providers/websocker_error_handler_porvider.dart';
import 'package:mapness/features/share_eta/ui/pulse_indicator.dart';
import 'package:mapness/features/share_eta/ui/share_eta_btn_action.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/toast/toast_overlay.dart';
import 'package:mapness/shared/utils/logger/logger.dart';

class ShareEtaBtn extends HookConsumerWidget {
  final int durationMinutes;
  final String? destination;

  const ShareEtaBtn({required this.durationMinutes, this.destination, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streamService = ref.watch(etaServiceProvider);

    final webSocketStatus = ref.watch(etaWebsocketStatusProvider);
    final (connectionCode, _) = ref.watch(websocketErrorHandlerProvider);
    final shareEtaType = ref.watch(shareEtaProvider);

    final bool isEtaStream = shareEtaType == EtaStreamType.eta;

    final bool isPulseactive = webSocketStatus && isEtaStream;

    ref.listen(etaServiceProvider, (prev, current) async {
      if (current.hasError && !current.isLoading && current.value == null) {
        ToastOverlay.of(context).showNoInternet(
          onRetry: () {
            ref.read(shareEtaProvider.notifier).startSharingEta();
          },
        );
      }
    });

    final bool isEtaStreamLoading = streamService.maybeWhen(loading: () => true, orElse: () => false);

    return ContentRow(
      onTap: () async {
        if (isPulseactive || isEtaStreamLoading) {
          return;
        }
        try {
          await _stopSharingPrevious(ref);
        } catch (e) {
          logger.log(e.toString(), logLevel: MapnessLogLevel.critical);
        } finally {
          await ref.read(shareEtaProvider.notifier).startSharingEta();
        }
      },
      options: ContentRowOptions(
        wrapperColor: context.colors.backgroundSurface1,
        wrapperEnabled: true,
        titleBuilder: (context) => Row(
          children: [
            Text(
              isPulseactive || isEtaStreamLoading ? context.l10n.routeIsSharing : context.l10n.shareTripProgress,
              style: context.textStyles.bodyLargeRegular.copyWith(color: context.colors.foregroundDefault),
            ),
            if (isPulseactive)
              Padding(
                padding: const EdgeInsetsDirectional.only(start: Spacing.$1_5x),
                child: PulseIndicator(color: connectionCode != null ? context.colors.errorDefault : null),
              ),
          ],
        ),
        customActionWidget: Padding(
          padding: const EdgeInsetsDirectional.only(end: Spacing.$4x),
          child: ShareEtaBtnAction(
            type: isEtaStreamLoading
                ? ShareEtaBtnActionType.loading
                : isPulseactive
                ? ShareEtaBtnActionType.active
                : ShareEtaBtnActionType.stoped,
          ),
        ),
      ),
    );
  }

  Future<void> _stopSharingPrevious(WidgetRef ref) async {
    await ref.read(shareEtaProvider.notifier).stopSharing();
  }
}
