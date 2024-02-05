import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';

import 'package:mapness/_features/poi_card/domain/model/opening_hours_model.dart';
import 'package:mapness/_features/poi_card/widgets/card_content.dart';
import 'package:mapness/_features/poi_card/widgets/style.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/expandable_widget/expandable_widget.dart';

class OpeningHours extends StatefulWidget {
  final OpeningHoursModel? model;

  const OpeningHours(this.model, {super.key});

  @override
  State<OpeningHours> createState() => _OpeningHoursState();
}

class _OpeningHoursState extends State<OpeningHours> {
  List<OpenHours>? openingHours;

  bool is24x7 = false;
  bool isOpenSameTime = false;

  @override
  void initState() {
    if (widget.model?.isOpen24x7 == true) {
      is24x7 = true;
    } else if (widget.model?.isDailySameOpenHours == true) {
      isOpenSameTime = true;
    } else {
      openingHours = widget.model?.openingHours;
      // title = widget.model?.todayOpeningInfo ?? '';
    }

    super.initState();
  }

  List<Widget>? convertWeekTimeInterval(
      BuildContext context, List<OpenHours>? openingHours) {
    return openingHours?.map((e) {
      final weekDay = e.weekDay;

      final textStyle = Theme.of(context)
          .extension<ThemeTextStyles>()!
          .textM
          .copyWith(color: colorPrimary);
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              weekDay,
              style: textStyle,
            ),
          ),
          Expanded(
            flex: 1,
            child: e.isWeekend
                ? Text(
                    context.l10n.weekend,
                    style: textStyle,
                  )
                : Row(
                    children: [
                      Text(e.openHour!, style: textStyle),
                      Text('-', style: textStyle),
                      Text(e.closeHour!, style: textStyle),
                    ],
                  ),
          ),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final todayOpeningInfo = widget.model?.getTodayOpeningInfo(context.l10n);
    final isWeekend = todayOpeningInfo?.isWeekend ?? false;

    var fontStyle = Theme.of(context)
        .extension<ThemeTextStyles>()!
        .textM
        .copyWith(color: colorPrimary);
    var widgets = convertWeekTimeInterval(context, openingHours);

    return is24x7 || isOpenSameTime
        ? CardContent(child: _buildTitle())
        : ExpandableWidget(
            title: Row(
              children: [
                Text(context.l10n.today, style: fontStyle),
                if (todayOpeningInfo != null) ...[
                  Text(' ', style: fontStyle),
                  Text(todayOpeningInfo.openHour ?? '', style: fontStyle),
                  Text(' - ', style: fontStyle),
                  Text(todayOpeningInfo.closeHour ?? '', style: fontStyle),
                ],
              ],
            ),
            icon: timeIcon(isWeekend ? colorIconError : colorIconPositive),
            content: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (ctx, i) => widgets?[i],
              separatorBuilder: (ctx, index) => const Divider(),
              itemCount: openingHours?.length ?? 0,
            ),
          );
  }

  Widget _buildTitle() {
    final style = Theme.of(context)
        .extension<ThemeTextStyles>()!
        .textM
        .copyWith(color: colorPrimary);

    final openHours = widget.model?.openingHours?.first;

    print("_buildTitle $openHours");

    return Row(
      children: [
        timeIcon(colorIconPositive),
        const SizedBox(width: 12),
        if (is24x7) Text(context.l10n.twentyFourSeven, style: style),
        if (isOpenSameTime) ...[
          Text(context.l10n.daily, style: style),
          Text(' ', style: style),
          Text(openHours!.openHour!, style: style),
          Text(' - ', style: style),
          Text(openHours.closeHour!, style: style),
        ]
      ],
    );
  }
}
