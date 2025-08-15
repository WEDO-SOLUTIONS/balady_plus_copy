import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/features/share_eta/entities/share_eta_time_type.dart';
import 'package:mapness/features/share_eta/providers/eta_stream_storage.dart';
import 'package:mapness/features/share_eta/providers/eta_timer_indicator.dart';
import 'package:mapness/features/share_eta/providers/share_eta_provider.dart';
import 'package:mapness/features/share_eta/providers/websocker_error_handler_porvider.dart';
import 'package:mapness/features/share_eta/ui/eta_share_control_sheet/eta_inprogress_sheet.dart';
import 'package:mapness/features/share_eta/ui/eta_share_control_sheet/eta_sharing_time_sheet.dart';
import 'package:mapness/features/share_eta/ui/pulse_indicator.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/utils/logger/logger.dart';

class EtaTimerControl extends ConsumerWidget {
  const EtaTimerControl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timer = ref.watch(etaTimerIndicatorProvider);
    final (code, _) = ref.watch(websocketErrorHandlerProvider);

    final diffInHours = timer ~/ 60;
    final diffInMinutes = timer % 60;

    final estimatedTimeString = diffInHours > 0
        ? context.l10n.timerHrMin(diffInHours.toString(), diffInMinutes.toString())
        : context.l10n.timerMin(diffInMinutes.toString());

    ref.listen(etaTimerIndicatorProvider, (prev, current) {
      if (current == 0) {
        _stopShare(ref);
      }
    });

    return MapButton(
      onTap: () => _continueShared(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.$2x),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            PulseIndicator(
              color: code == null ? null : context.colors.errorDefault,
            ),
            const SizedBox(width: 8),
            Text(
              estimatedTimeString,
              textDirection: ref.watch(uiDirectionProvider),
              style: context.textStyles.captionLargeMedium.copyWith(color: context.colors.foregroundDefault),
            ),
          ],
        ),
      ),
    );
  }

  void _continueShared(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (context) => Consumer(builder: (_, ref, __) {
        final timerTime = ref.read(etaTimerIndicatorProvider);

        final hourLeft = timerTime ~/ 60;
        final leftMinutes = timerTime % 60;

        final left = hourLeft > 0
            ? context.l10n.hrMinLeft(hourLeft.toString(), leftMinutes.toString())
            : context.l10n.minLeft(leftMinutes.toString());
        return EtaInprogressSheet(
          onShareMorePressed: () async {
            await _showEtaTimeSheet(context);
            Navigator.pop(context);
          },
          onStopSharePressed: () async {
            await _stopShare(ref);
            Navigator.pop(context);
          },
          timeLeft: left,
        );
      }),
    );
  }

  Future<void> _showEtaTimeSheet(BuildContext context) => showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: true,
        builder: (context) => Consumer(
          builder: (context, ref, _) => EtaSharingTimeSheet(
            onConfirmTap: (v) async {
              await _stopShare(ref);
              await ref.read(shareEtaProvider.notifier).startSharingLiveLocation(v.durationInMinutes);
              Navigator.pop(context);
            },
          ),
        ),
      );

  Future<void> _stopShare(WidgetRef ref) async {
    final etaStore = EtaStreamStorage();

    try {
      await ref.read(shareEtaProvider.notifier).stopSharing();
    } catch (e) {
      logger.log(e.toString(), logLevel: MapnessLogLevel.critical);
    } finally {
      etaStore.clear();
    }
  }
}
