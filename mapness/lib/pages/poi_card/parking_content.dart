import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/parking_spot/parking_manage.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/extensions/date_time_ext.dart';

class ParkingContent extends ConsumerWidget {
  const ParkingContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parkingManage = ref.read(parkingManageProvider).value;
    final dateParking = parkingManage?.dateTime ?? DateTime.now();

    return SliverFillRemaining(
      hasScrollBody: false,
      child: Column(
        children: [
          if (parkingManage?.comment.isNotEmpty == true)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Spacing.$4x),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(RadiusBorder.xl),
                color: context.colors.backgroundSurface1,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.comment,
                    style: context.textStyles.bodyLargeSemiBold.copyWith(color: context.colors.foregroundDefault),
                  ),
                  Spacing.$1x.heightBox,
                  if (parkingManage != null)
                    Text(
                      parkingManage.comment,
                      style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundSoft),
                    ),
                ],
              ),
            ),
          if (parkingManage?.comment.isNotEmpty == true) Spacing.$4x.heightBox,
          Container(
            padding: const EdgeInsets.all(Spacing.$4x),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(RadiusBorder.xl),
              color: context.colors.backgroundSurface1,
            ),
            child: Row(
              children: [
                Icon(
                  GeneralIcons.timeQuarter,
                  color: context.colors.accentDefault,
                ),
                Spacing.$3x.widthBox,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.youLeftYouCar(dateParking.hoursAndMinutes().$1, dateParking.hoursAndMinutes().$2),
                      style: context.textStyles.bodyLargeRegular.copyWith(color: context.colors.foregroundDefault),
                    ),
                    Spacing.$1x.heightBox,
                    Text(
                      context.l10n.parkingTime,
                      style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundSoft),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          Text(
            context.l10n.dataStoredFor,
            style: context.textStyles.captionMediumRegular.copyWith(color: context.colors.foregroundSoft),
          ),
          Spacing.$4x.heightBox,
        ],
      ),
    );
  }
}
