import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/features/share_eta/models/eta_stream_payload.dart';
import 'package:mapness/features/share_eta/models/ws_config.dart';
import 'package:mapness/features/share_eta/providers/eta_service_provider.dart';
import 'package:mapness/features/share_eta/providers/eta_websocket_provider.dart';
import 'package:mapness/features/share_eta/providers/websocket_status_provider.dart';
import 'package:mapness/features/share_eta/ui/pulse_indicator.dart';
import 'package:mapness/features/share_eta/ui/share_eta_btn_action.dart';

class ShareEtaBtn extends HookConsumerWidget {
  final int durationMinutes;
  final String? destination;

  const ShareEtaBtn({required this.durationMinutes, this.destination, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streamService = ref.watch(etaServiceProvider);
    final streamNotifier = ref.read(etaServiceProvider.notifier);
    final wsProvider = ref.read(etaWebsocketProvider.notifier);
    final webSocketStatus = ref.watch(websocketStatusProvider);

    final bool isPulseactive = webSocketStatus.status;

    ref.listen(etaServiceProvider, (prev, current) {
      if (current.hasValue && current.value != null && !isPulseactive) {
        if (current.value?.streamToken == null || current.value?.streamId == null) {
          return;
        }

        final streamData = current.value!;
        final streamToken = streamData.streamToken!;
        final streamId = streamData.streamId!;

        streamNotifier.shareStream();

        wsProvider.start(
          token: streamToken,
          streamId: streamId,
          subscriptionType: SubscriptionType.share,
        );
      } else if (current.hasError) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          ToastMessageFactory.toastWithoutAction(text: 'Error', context: context),
        );
      }
    });

    final bool isEtaStreamLoading = streamService.maybeWhen(
      loading: () => true,
      orElse: () => false,
    );

    return ContentRow(
      onTap: () {
        if (isPulseactive && isEtaStreamLoading) {
          return;
        }
        streamNotifier.startEtaStream(
          EtaStreamPayload(
            durationMinutes: durationMinutes,
            type: EtaStreamType.eta.name,
          ),
        );
      },
      options: ContentRowOptions(
        padding: const EdgeInsets.symmetric(
          vertical: Spacing.$3x,
          horizontal: Spacing.$4x,
        ),
        titleBuilder: (context) => Row(
          children: [
            Text(
              'Share ETA',
              style: context.textStyleV3.bodyLargeRegular.copyWith(
                color: context.colorsV2.foregroundDefault,
              ),
            ),
            if (isPulseactive)
              const Padding(
                padding: EdgeInsetsDirectional.only(end: Spacing.$1_5x),
                child: PulseIndicator(),
              )
          ],
        ),
        customActionWidget: ShareEtaBtnAction(
          type: isEtaStreamLoading
              ? ShareEtaBtnActionType.loading
              : isPulseactive
                  ? ShareEtaBtnActionType.active
                  : ShareEtaBtnActionType.stoped,
        ),
      ),
    );
  }
}
