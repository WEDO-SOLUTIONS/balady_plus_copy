import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapness/_features/poi_card/domain/model/opening_hours_model.dart';
import 'package:mapness/_features/poi_card/widgets/card_content.dart';
import 'package:mapness/_features/poi_card/widgets/expandable_widget.dart';
import 'package:mapness/_features/poi_card/widgets/style.dart';

class OpeningHours extends StatefulWidget {
  final OpeningHoursModel? model;

  const OpeningHours(this.model, {super.key});

  @override
  State<OpeningHours> createState() => _OpeningHoursState();
}

class _OpeningHoursState extends State<OpeningHours> {
  List<Widget>? openingHoursWidgets;
  late String title;
  bool is24x7 = false;

  @override
  void initState() {
    if (widget.model?.isOpen24x7 == true) {
      is24x7 = true;
    } else {
      final displayOpenHours = widget.model?.openingHours;
      openingHoursWidgets = convertWeekTimeInterval(displayOpenHours);
      title = widget.model?.todayOpeningInfo ?? '';
    }

    super.initState();
  }

  List<Widget>? convertWeekTimeInterval(List<OpenHours>? openingHours) {
    return openingHours?.map((e) {
      final weekDay = e.weekDay;
      final openHours = e.openHours;

      const textStyle = TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
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
            child: Text(
              openHours,
              style: textStyle,
            ),
          ),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isWeekend = widget.model?.getTodayOpeningInfo()?.isWeekend ?? false;

    return CardContent(
      child: is24x7
          ? Row(
              children: [
                timeIcon(colorIconPositive),
                const SizedBox(
                  width: 12,
                ),
                Text(
                  "24/7",
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    height: 1.4,
                    color: const Color(0xFF1E2A36),
                  ),
                )
              ],
            )
          : ExpandableWidget(
              title: Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  height: 1.4,
                  color: const Color(0xFF1E2A36),
                ),
              ),
              icon: timeIcon(isWeekend ? colorIconError : colorIconPositive),
              content: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (ctx, i) => openingHoursWidgets?[i],
                separatorBuilder: (ctx, index) => const Divider(),
                itemCount: openingHoursWidgets?.length ?? 0,
              ),
            ),
    );
  }
}
