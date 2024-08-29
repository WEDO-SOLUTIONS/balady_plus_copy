import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/features/share_eta/providers/eta_service_provider.dart';
import 'package:mapness/features/share_eta/providers/eta_stream_storage.dart';
import 'package:mapness/features/share_eta/providers/eta_websocket_status_provider.dart';
import 'package:mapness/features/share_eta/providers/share_eta_provider.dart';
import 'package:mapness/features/share_eta/providers/websocker_error_handler_porvider.dart';
import 'package:mapness/features/share_eta/ui/pulse_indicator.dart';
import 'package:mapness/features/share_eta/ui/share_eta_btn_action.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class ShareEtaBtn extends HookConsumerWidget {
  final int durationMinutes;
  final String? destination;

  const ShareEtaBtn({required this.durationMinutes, this.destination, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streamService = ref.watch(etaServiceProvider);

    final webSocketStatus = ref.watch(etaWebsocketStatusProvider);
    final (connectionCode, _) = ref.watch(websocketErrorHandlerProvider);

    final bool isPulseactive = webSocketStatus;

    ref.listen(etaServiceProvider, (prev, current) async {
      if (current.hasValue && current.value != null && !isPulseactive && !current.isLoading) {
        final streamId = current.value!.streamId;
        final streamToken = current.value!.streamToken;
        final finishAt = current.value!.finishesAt;
        final xStreamData = current.value!.xStreamData;

        if (streamId == null || streamToken == null || finishAt == null || xStreamData == null) {
          return;
        }

        EtaStreamStorage()
          ..setStreamId(streamId)
          ..setToken(streamToken)
          ..setXStreamData(xStreamData);

        await ref.read(shareEtaProvider.notifier).startWebsocketStream(streamId, streamToken, xStreamData);
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
        if (isPulseactive || isEtaStreamLoading) {
          return;
        }
        ref.read(shareEtaProvider.notifier).startSharingEta();
      },
      options: ContentRowOptions(
        padding: const EdgeInsets.symmetric(
          vertical: Spacing.$3x,
          horizontal: Spacing.$4x,
        ),
        titleBuilder: (context) => Row(
          children: [
            Text(
              isPulseactive || isEtaStreamLoading ? context.l10n.routeIsSharing : context.l10n.shareTripProgress,
              style: context.textStyleV3.bodyLargeRegular.copyWith(
                color: context.colorsV2.foregroundDefault,
              ),
            ),
            if (isPulseactive)
              Padding(
                padding: const EdgeInsetsDirectional.only(end: Spacing.$1_5x),
                child: PulseIndicator(
                  color: connectionCode != null ? context.colorsV2.errorDefault : null,
                ),
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
