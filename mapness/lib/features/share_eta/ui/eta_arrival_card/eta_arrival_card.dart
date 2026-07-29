import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart' as intl;
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/features/share_eta/models/eta_info_model.dart';
import 'package:mapness/features/share_eta/providers/eta_geo_subscriber.dart';
import 'package:mapness/features/share_eta/ui/eta_arrival_card/eta_route_line.dart';
import 'package:mapness/features/share_eta/ui/eta_control/user_pin_control.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/utils/text_utils/arabic_numerals.dart';

class EtaArrivalCard extends HookConsumerWidget {
  const EtaArrivalCard({super.key});

  static const minSheetHeight = 176.0;
  static const imgSize = 21.33;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (streamData, metaInfo) = ref.watch(etaGeoSubscriberProvider);

    final startDistance = useState<int?>(null);

    return Container(
      constraints: const BoxConstraints(
        minHeight: minSheetHeight,
      ),
      padding: const EdgeInsets.all(Spacing.$4x),
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          matchTextDirection: true,
          image: AssetImage(
            Assets.images.etaSheetBackground.keyName,
          ),
          fit: BoxFit.fill,
        ),
      ),
      margin:
          const EdgeInsets.symmetric(
            horizontal: Spacing.$4x,
          ).copyWith(
            bottom: Spacing.$8x,
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: Spacing.$4x),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getArrivalTime(context, streamData),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.textStyles.h3Medium.copyWith(
                    color: context.colors.staticWhite,
                  ),
                ),
                const SizedBox(height: Spacing.$1_5x),
                Opacity(
                  opacity: 0.5,
                  child: Text(
                    '${context.l10n.kmAway(_getDistance(context, streamData))} • ${context.l10n.lastUpdatedAtTime(_getUpdatedAt(context, streamData))}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.textStyles.captionLargeRegular.copyWith(
                      color: context.colors.staticWhite,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Spacing.$3x),
          Directionality(
            textDirection: TextDirection.ltr,
            child: EtaRouteLine(
              progress: _getProgress(streamData, startDistance),
              image: ClipOval(
                child: ColoredBox(
                  color: context.colors.staticWhite.withOpacity(.1),
                  child: Padding(
                    padding: const EdgeInsets.all(5.33),
                    child: Center(
                      child: CircleAvatar(
                        radius: imgSize,
                        backgroundColor: context.colors.staticWhite,
                        child: SizedBox(
                          width: imgSize,
                          height: imgSize,
                          child: UserPinControl(user: metaInfo?.payload?.user),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: Spacing.$4x),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              buttonColorScheme: ButtonColorScheme.accent,
              primaryLabel: context.l10n.back,
              textColor: context.colors.accentOnAccent,
              onTap: () => _cancelEta(context, ref),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _cancelEta(BuildContext context, WidgetRef ref) async {
    await ref.read(etaGeoSubscriberProvider.notifier).stopStreaming();
    context.router.pop();
  }

  double _getProgress(EtaInfoModel<dynamic>? streamData, ValueNotifier<int?> startDistance) {
    if (streamData == null) {
      // we don't have enough data to calculate the progress
      return 0.5;
    }

    final data = streamData as EtaInfoModel<EtaInfoPayload?>;
    final distanceLeft = data.payload?.eta?.distance;

    if (distanceLeft == null) {
      return 0.0;
    }

    startDistance.value ??= distanceLeft;

    if (startDistance.value == 0 || startDistance.value == null) {
      return 0.5;
    }

    final initialDistance = startDistance.value!;

    final progress = (initialDistance - distanceLeft) / initialDistance;

    return progress.clamp(0.0, 1.0);
  }

  String _formatArrivalTime(BuildContext context, String remaining) => context.l10n.arrivingInTime(remaining);

  String _getArrivalTime(BuildContext context, EtaInfoModel<dynamic>? streamData) {
    if (streamData == null) {
      return _formatArrivalTime(context, context.l10n.timerMin('--'));
    }
    final data = streamData as EtaInfoModel<EtaInfoPayload?>;
    final arrivalAt = data.payload?.eta?.arrivalAt;
    if (arrivalAt == null) {
      return _formatArrivalTime(context, context.l10n.timerMin('--'));
    }
    final arrivalTime = DateTime.tryParse(arrivalAt);
    if (arrivalTime == null) {
      return _formatArrivalTime(context, context.l10n.timerMin('--'));
    }
    final currentTime = DateTime.now().toUtc();
    final remainingTime = arrivalTime.difference(currentTime);

    if (remainingTime.isNegative) {
      return _formatArrivalTime(context, context.l10n.timerMin(context.l10n.number(0)));
    }

    if (remainingTime.inSeconds < 60) {
      return context.l10n.lessThenMinute;
    }

    final remainingHours = remainingTime.inHours;
    final remainingMinutes = remainingTime.inMinutes.remainder(60);

    if (remainingTime.inSeconds < 60) {
      return context.l10n.lessThenMinute;
    }

    return remainingHours > 0
        ? _formatArrivalTime(
            context,
            context.l10n.timerHrMin(context.l10n.number(remainingHours), context.l10n.number(remainingMinutes)),
          )
        : _formatArrivalTime(context, context.l10n.timerMin(context.l10n.number(remainingMinutes)));
  }

  String _getUpdatedAt(BuildContext context, EtaInfoModel<dynamic>? streamData) {
    if (streamData == null) {
      return '--';
    }
    final data = streamData as EtaInfoModel<EtaInfoPayload?>;
    final updatedAt = data.payload?.updatedAt;
    if (updatedAt == null) {
      return '--';
    }
    final updatedAtTime = DateTime.tryParse(updatedAt)?.toLocal();
    if (updatedAtTime == null) {
      return '--';
    }
    final dateFormatter = intl.DateFormat('HH:mm');

    return context.digits(dateFormatter.format(updatedAtTime));
  }

  String _getDistance(BuildContext context, EtaInfoModel<dynamic>? streamData) {
    if (streamData == null) {
      return '--';
    }
    final data = streamData as EtaInfoModel<EtaInfoPayload?>;
    final distance = data.payload?.eta?.distance; // distance in meters

    if (distance == null) {
      return '--';
    }

    final distanceInKm = distance / 1000.0;

    return context.digits(distanceInKm.toStringAsFixed(1));
  }
}
