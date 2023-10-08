import 'package:flutter/material.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';

import 'package:localize_and_translate/localize_and_translate.dart';

import '../../domain/entities/search_calendar/search_calendar_item.dart';
import 'calendar_image_widget.dart';

class OldCalendarCard extends StatelessWidget {
  final SearchCalendarItem item;
  const OldCalendarCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16, left: 16, right: 16),
      height: 201,
      width: MediaQuery.of(context).size.width - 32,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 4,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ],
        image: calendarImage(item.logoURL, ImagePath.calendarBackground),
      ),
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 16),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SaudiDay(
                  name: item.getStartDayName(),
                  size: 14,
                ),
                SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    SaudiDay(
                      name: item.startDate?.month.toString() ?? "",
                      size: 20,
                    ),
                    SaudiDay(
                      name: '  / ',
                      size: 20,
                    ),
                    SaudiDay(
                      name:
                          item.startDate?.day.toString().padLeft(2, "0") ?? "",
                      size: 28,
                    ),
                  ],
                ),
                SizedBox(
                  height: 4,
                ),
                SaudiDay(
                  name: item.name ?? "",
                  size: 20,
                ),
              ],
            ),
            SizedBox(
              height: 32,
            ),
            SaudiContainer(
              btnText: "saudi_calendar_add".tr(),
              remainingText: item.remainingDays() ?? "",
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
      ),
    );
  }
}

class SaudiDay extends StatelessWidget {
  final String name;
  final double size;
  const SaudiDay({super.key, required this.name, required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomTextWidget(
      name,
      fontColor: const Color(0xFF145E75),
      fontSize: size,
      fontWeight: AppFontWeight.bold,
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
    return Container(
      //width: MediaQuery.of(context).size.width,
      height: 66,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: CustomTextWidget(
                    remainingText,
                    fontColor: Color(0xFF145E75),
                    height: 1.4,
                    fontSize: 11,
                    maxLines: 4,
                    fontWeight: AppFontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                CustomTextWidget(
                  timer,
                  fontColor: Color(0xFF145E75),
                  fontSize: 24,
                  fontWeight: AppFontWeight.bold,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: ElevatedButton(
              onPressed: () => addToCalendar(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primary900Light,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: CustomTextWidget(
                btnText,
                textAlign: TextAlign.center,
                fontColor: Colors.white,
                fontSize: 11.80,
                fontWeight: AppFontWeight.bold,
              ),
            ),
          ),
        ],
      ),
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
