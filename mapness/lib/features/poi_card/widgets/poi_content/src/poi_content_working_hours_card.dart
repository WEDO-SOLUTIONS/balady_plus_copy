import 'package:balady_uikit/balady_uikit.dart' hide PoiContentWorkTime, PoiContentWorkTimeDay;
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/poi_card/domain/model/poi_content/poi_content.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class PoiContentWorkingHoursCard extends StatelessWidget {
  final PoiContentWorkTimeModel? data;

  const PoiContentWorkingHoursCard({
    required this.data,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final data = this.data;
    if (data == null) {
      return const SizedBox.shrink();
    }

    final workTimeDays = data.days?.map((e) => _WorkTimeItemWidget(
          workTimeDay: e,
          showDivider: data.days?.last != e,
        ));
    if (workTimeDays == null && data.additionalInfo == null) {
      return ContentWrapper(
        color: context.color.surfaceBasePrimary,
        children: [
          ContentRowV2(
            leading: GeneralIcons.timeQuarter.icon(
              color: context.colorsV3.accentDefault,
            ),
            text: ContentRowTextOptions(
              title: data.workHours,
              subtitle: data.breakHours,
              subtitleOptions: ContentRowTextOption(
                baseColor: context.colorsV3.foregroundSoft,
              ),
            ),
          ),
        ],
      );
    }
    return ContentWrapper(
      color: context.color.surfaceBasePrimary,
      children: [
        ContentRowExpandable(
          padding: EdgeInsets.zero,
          expandIconColor: context.colorsV3.foregroundMuted,
          options: ContentRowOptions(
            title: data.workHours,
            subtitle: data.breakHours,
            subtitleStyle: context.textStyleV3.bodySmallRegular.copyWith(color: context.colorsV3.foregroundSoft),
            leadingIcon: GeneralIcons.timeQuarter.icon(
              color: context.colorsV3.accentDefault,
            ),
          ),
          content: Column(
            children: <Widget>[
              if (workTimeDays != null) ...workTimeDays,
              if (data.additionalInfo != null)
                ContentRowV2(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  leading: GeneralIcons.infoSquare.icon(
                    color: context.colorsV3.foregroundMuted,
                  ),
                  text: ContentRowTextOptions(
                    title: context.l10n.extraInformation,
                    titleOptions: const ContentRowTextOption(maxLines: 99),
                    subtitle: data.additionalInfo,
                    subtitleOptions: const ContentRowTextOption(maxLines: 99),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WorkTimeItemWidget extends StatelessWidget {
  final PoiContentWorkTimeDayModel workTimeDay;
  final bool showDivider;
  const _WorkTimeItemWidget({required this.workTimeDay, required this.showDivider});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsetsDirectional.only(
          start: Spacing.$4x + AppSizes.xxs + Spacing.$3x,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Spacing.$2x),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(6),
                  1: FlexColumnWidth(8),
                },
                children: [
                  TableRow(
                    children: [
                      Text(workTimeDay.dayTitle, style: context.textStyleV3.bodyLargeRegular),
                      Text(workTimeDay.workHours, style: context.textStyleV3.bodyLargeRegular),
                    ],
                  ),
                  if (workTimeDay.breakHours != null)
                    TableRow(children: [
                      const SizedBox(),
                      Text(
                        workTimeDay.breakHours!,
                        style: context.textStyleV3.bodySmallRegular.copyWith(color: context.colorsV3.foregroundSoft),
                      ),
                    ]),
                ],
              ),
            ),
            if (showDivider) const _Divider(),
          ],
        ),
      );
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) => Divider(
        color: context.colorsV3.borderSoft,
        height: 8,
        thickness: 1,
      );
}
