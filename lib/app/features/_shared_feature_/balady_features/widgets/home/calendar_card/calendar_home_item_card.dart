import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mapness/shared/config/package_config.dart';

import '../../../../../calendar/domain/entities/search_calendar/search_calendar_item.dart';

class CalendarHomeItemCard extends StatelessWidget {
  final SearchCalendarItem item;
  final double? width;
  final EdgeInsets? padding;
  const CalendarHomeItemCard(
      {super.key, required this.item, this.width, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: padding ?? const EdgeInsets.only(top: 16, left: 16, right: 16),
      height: 200,
      width: width ?? MediaQuery.of(context).size.width - 32,
      padding: const EdgeInsets.only(
        left: 16,
        right: 24,
        top: 12,
        bottom: 16,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: const DecorationImage(
          image: AssetImage(
            "assets/images/calendar_card.png",
            package: PackageConfig.packageName,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SaudiDay(
                name: item.getStartDayName(),
              ),
              Row(
                children: [
                  SaudiDay(
                    name:
                        item.startDate?.month.toString().padLeft(2, "0") ?? "",
                  ),
                  const SaudiDay(
                    name: '/',
                  ),
                  SaudiDay(
                    name: item.startDate?.day.toString().padLeft(2, "0") ?? "",
                  ),
                ],
              ),
              Text(
                (item.name ?? ""),
                maxLines: 2,
                style: Theme.of(context)
                    .extension<ThemeTextStyles>()
                    ?.textS
                    .copyWith(
                      color: Colors.white,
                      height: 1.5,
                    ),
              ),
            ],
          ),
          SaudiContainer(
            btnText: "saudi_calendar_add".tr(),
            remainingText: "remaining".tr(),
            timer: item.remainingDays(),
            addToCalendar: () {
              Add2Calendar.addEvent2Cal(
                buildEvent(
                  title: item.name ?? "",
                  startDate: item.startDate!,
                  endDate: item.endDate!,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class SaudiDay extends StatelessWidget {
  final String name;
  const SaudiDay({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      maxLines: 2,
      style: Theme.of(context).extension<ThemeTextStyles>()?.accentL.copyWith(
            color: Colors.white,
            height: 1.5,
          ),
    );
  }
}

class SaudiContainer extends StatelessWidget {
  final String remainingText;
  final String timer;
  final String btnText;
  final Function addToCalendar;
  const SaudiContainer(
      {super.key,
      required this.remainingText,
      required this.timer,
      required this.btnText,
      required this.addToCalendar});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                remainingText,
                maxLines: 4,
                style: Theme.of(context)
                    .extension<ThemeTextStyles>()
                    ?.accentL
                    .copyWith(
                      color: Colors.white,
                      height: 1.5,
                    ),
              ),
            ),
            Text(
              timer,
              style: Theme.of(context)
                  .extension<ThemeTextStyles>()
                  ?.textS
                  .copyWith(
                    color: Colors.white,
                    height: 1.5,
                  ),
            ),
          ],
        ),
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => addToCalendar(),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 14,
              ),
              child: Text(
                btnText,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .extension<ThemeTextStyles>()
                    ?.accentM
                    .copyWith(
                      color: const Color(0xFF4CA5B4),
                      height: 1.5,
                    ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Event buildEvent({
  required String title,
  required DateTime startDate,
  required DateTime endDate,
}) {
  return Event(
    title: title,
    startDate: startDate,
    endDate: endDate,
    allDay: false,
  );
}
