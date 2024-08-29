import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mapness/features/share_eta/models/eta_info_model.dart';
import 'package:mapness/features/share_eta/providers/eta_geo_subscriber.dart';
import 'package:mapness/features/share_eta/ui/eta_arrival_card/eta_route_line.dart';
import 'package:mapness/features/share_eta/ui/eta_control/user_pin_control.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class EtaArrivalCard extends ConsumerWidget {
  const EtaArrivalCard({super.key});

  static const minSheetHeight = 176.0;
  static const imgSize = 32.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (streamData, metaInfo) = ref.watch(etaGeoSubscriberProvider);

    return Container(
      constraints: const BoxConstraints(
        minHeight: minSheetHeight,
      ),
      padding: const EdgeInsets.all(Spacing.$4x),
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
            matchTextDirection: true,
            image: AssetImage(
              'assets/images/eta_sheet_background.png',
              package: PackageConfig.packageName,
            ),
            fit: BoxFit.fill),
      ),
      margin: const EdgeInsets.symmetric(
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
                  context.l10n.arrivingInTime(_getArrivalTime(context, streamData)),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.textStyleV3.h3Medium.copyWith(
                    color: context.colorsV2.staticWhite,
                  ),
                ),
                const SizedBox(height: Spacing.$1_5x),
                Opacity(
                  opacity: 0.5,
                  child: Text(
                    '${context.l10n.kmAway(_getDistance(context, streamData))} • ${context.l10n.lastUpdatedAtTime(_getUpdatedAt(context, streamData))}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.textStyleV3.captionLargeRegular.copyWith(
                      color: context.colorsV2.staticWhite,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Spacing.$3x),
          EtaRouteLine(
            progress: _getProgress(streamData),
            image: ClipOval(
              child: ColoredBox(
                color: context.colorsV2.staticWhite,
                child: Center(
                  child: SizedBox(
                    width: imgSize,
                    height: imgSize,
                    child: UserPinControl(user: metaInfo?.payload?.user),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: Spacing.$4x),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              buttonColorScheme: ButtonColorScheme.onColor,
              primaryLabel: context.l10n.back,
              textColor: context.colorsV2.foregroundDefault,
              onTap: () => _cancelEta(context, ref),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _cancelEta(BuildContext context, WidgetRef ref) async {
    await ref.read(etaGeoSubscriberProvider.notifier).stopStreaming();
    context.pop();
  }

  double _getProgress(EtaInfoModel<dynamic>? streamData) {
    if (streamData == null) {
      // we don't have enough data to calculate the progress
      return 0.5;
    }
    final data = streamData as EtaInfoModel<EtaInfoPayload?>;
    final distance = data.payload?.eta?.distance;
    final arrivalAt = data.payload?.eta?.arrivalAt;
    final speed = data.payload?.speed ?? 60.0; // default speed is 60 km/h

    if (distance == null || arrivalAt == null) {
      // we don't have enough data to calculate the progress
      return 0.5;
    }

    final arrivalTime = DateTime.tryParse(arrivalAt);

    if (arrivalTime == null) {
      // we don't have enough data to calculate the progress
      return 0.5;
    }

    final currentTime = DateTime.now().toUtc();

    // Calculate the remaining time in hours
    final remainingTime = arrivalTime.difference(currentTime);
    final remainingHours = remainingTime.inSeconds / 3600.0;

    // Calculate the traveled distance
    final traveledDistance = distance - (speed * remainingHours);

    // Get process in percentage
    final percentCompleted = traveledDistance / distance;

    return percentCompleted.clamp(0.0, 1.0);
  }

  String _getArrivalTime(BuildContext context, EtaInfoModel<dynamic>? streamData) {
    if (streamData == null) {
      return context.l10n.timerMin('--');
    }
    final data = streamData as EtaInfoModel<EtaInfoPayload?>;
    final arrivalAt = data.payload?.eta?.arrivalAt;
    if (arrivalAt == null) {
      return context.l10n.timerMin('--');
    }
    final arrivalTime = DateTime.tryParse(arrivalAt);
    if (arrivalTime == null) {
      return context.l10n.timerMin('--');
    }
    final currentTime = DateTime.now().toUtc();
    final remainingTime = arrivalTime.difference(currentTime);
    final remainingHours = remainingTime.inHours;
    final remainingMinutes = remainingTime.inMinutes.remainder(60);

    return remainingHours > 0
        ? context.l10n.timerHrMin(remainingHours.toString(), remainingMinutes.toString())
        : context.l10n.timerMin(remainingMinutes.toString());
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
    final updatedAtTime = DateTime.tryParse(updatedAt);
    if (updatedAtTime == null) {
      return '--';
    }
    final dateFormatter = DateFormat('HH:mm');

    return dateFormatter.format(updatedAtTime);
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

    return distanceInKm.toStringAsFixed(1);
  }
}
