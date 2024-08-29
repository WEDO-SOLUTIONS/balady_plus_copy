import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/app/routes/routes.dart';
import 'package:mapness/features/share_eta/entities/share_eta_time_type.dart';
import 'package:mapness/features/share_eta/providers/eta_stream_storage.dart';
import 'package:mapness/features/share_eta/providers/eta_timer_indicator.dart';
import 'package:mapness/features/share_eta/providers/share_eta_provider.dart';
import 'package:mapness/features/share_eta/ui/eta_share_control_sheet/eta_inprogress_sheet.dart';
import 'package:mapness/features/share_eta/ui/eta_share_control_sheet/eta_sharing_time_sheet.dart';
import 'package:mapness/features/share_eta/ui/pulse_indicator.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class EtaTimerControl extends ConsumerWidget {
  const EtaTimerControl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timer = ref.watch(etaTimerIndicatorProvider);

    final diffInHours = timer ~/ 60;
    final diffInMinutes = timer % 60;

    final estimatedTimeString = diffInHours > 0
        ? context.l10n.timerHrMin(diffInHours.toString(), diffInMinutes.toString())
        : context.l10n.timerMin(diffInMinutes.toString());

    return MapButton(
      onTap: () async {
        _continueShared(context, ref);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.$2x),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const PulseIndicator(),
            const SizedBox(width: 8),
            Text(
              estimatedTimeString,
              style: context.textStyleV3.captionLargeMedium.copyWith(color: context.colorsV2.foregroundDefault),
            ),
          ],
        ),
      ),
    );
  }

  void _continueShared(BuildContext context, WidgetRef ref) {
    final timerTime = ref.read(etaTimerIndicatorProvider);

    final hourLeft = timerTime ~/ 60;
    final leftMinutes = timerTime % 60;

    final left = hourLeft > 0
        ? context.l10n.hrMinLeft(hourLeft.toString(), leftMinutes.toString())
        : context.l10n.minLeft(leftMinutes.toString());

    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: rootNavigatorKey.currentContext!,
      isScrollControlled: true,
      builder: (context) => EtaInprogressSheet(
        onShareMorePressed: () async {
          context.pop();
          _showEtaTimeSheet(rootNavigatorKey.currentContext!, ref);
        },
        onStopSharePressed: () {
          context.pop();
          _stopShare(ref);
        },
        timeLeft: left,
      ),
    );
  }

  void _showEtaTimeSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (context) => EtaSharingTimeSheet(
        onConfirmTap: (v) async {
          await _stopShare(ref);
          await ref.read(shareEtaProvider.notifier).startSharing(v.durationInMinutes);
        },
      ),
    );
  }

  Future<void> _stopShare(WidgetRef ref) async {
    final etaStore = EtaStreamStorage();
    if (etaStore.state.streamToken == null || etaStore.state.xStreamData == null) {
      return;
    }
    final tokenId = etaStore.state.streamToken!;
    final streamData = etaStore.state.xStreamData!;

    await ref.read(shareEtaProvider.notifier).stopSharing(tokenId, streamData);
    etaStore.clear();
  }
}
