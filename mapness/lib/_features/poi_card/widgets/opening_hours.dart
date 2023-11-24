import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapness/_features/poi_card/domain/model/opening_hours_model.dart';
import 'package:mapness/_features/poi_card/widgets/card_content.dart';
import 'package:mapness/_features/poi_card/widgets/expandable_widget.dart';
import 'package:mapness/_features/poi_card/widgets/style.dart';
import 'package:mapness/shared/config/package_fonts.dart';

class OpeningHours extends StatefulWidget {
  final OpeningHoursModel? model;

  const OpeningHours(this.model, {super.key});

  @override
  State<OpeningHours> createState() => _OpeningHoursState();
}

class _OpeningHoursState extends State<OpeningHours> {
  List<Widget>? openingHoursWidgets;

  bool is24x7 = false;
  bool isOpenSameTime = false;

  @override
  void initState() {
    if (widget.model?.isOpen24x7 == true) {
      is24x7 = true;
    } else if (widget.model?.isDailySameOpenHours == true) {
      isOpenSameTime = true;
    } else {
      final displayOpenHours = widget.model?.openingHours;
      openingHoursWidgets = convertWeekTimeInterval(displayOpenHours);
      // title = widget.model?.todayOpeningInfo ?? '';
    }

    super.initState();
  }

  List<Widget>? convertWeekTimeInterval(List<OpenHours>? openingHours) {
    return openingHours?.map((e) {
      final weekDay = e.weekDay;

      final textStyle = GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: colorPrimary,
      );
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
                    'Weekend',
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
    final isWeekend = widget.model?.getTodayOpeningInfo()?.isWeekend ?? false;
    final todayOpeningInfo = widget.model?.getTodayOpeningInfo();

    var fontStyle = PackageFonts.frutigerArabic(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: colorPrimary,
    );
    return is24x7 || isOpenSameTime
        ? CardContent(
            child: _buildTitle(),
          )
        : ExpandableWidget(
            title: Row(
              children: [
                Text("Today", style: fontStyle),
                Text(' ', style: fontStyle),
                Text(todayOpeningInfo!.openHour!, style: fontStyle),
                Text(' - ', style: fontStyle),
                Text(todayOpeningInfo.closeHour!, style: fontStyle),
              ],
            ),
            icon: timeIcon(isWeekend ? colorIconError : colorIconPositive),
            content: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (ctx, i) => openingHoursWidgets?[i],
              separatorBuilder: (ctx, index) => const Divider(),
              itemCount: openingHoursWidgets?.length ?? 0,
            ),
          );
  }

  Widget _buildTitle() {
    final style = PackageFonts.frutigerArabic(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: colorPrimary,
    );

    final openHours = widget.model?.openingHours?.first;

    return Row(
      children: [
        timeIcon(colorIconPositive),
        const SizedBox(width: 12),
        if (is24x7) Text("24/7", style: style),
        if (isOpenSameTime) ...[
          Text("Daily", style: style),
          Text(' ', style: style),
          Text(openHours!.openHour!, style: style),
          Text(' - ', style: style),
          Text(openHours.closeHour!, style: style),
        ]
      ],
    );
  }
}
