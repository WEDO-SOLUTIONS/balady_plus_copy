import 'package:flutter/material.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter_svg/svg.dart';

import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/constants/ux_cam_events.dart';
import '../../domain/entities/search_calendar/search_calendar_item.dart';
import 'calendar_image_widget.dart';

class OldCalendarCard extends StatelessWidget {
  final SearchCalendarItem item;
  final double? width;
  final EdgeInsets? padding;
  const OldCalendarCard(
      {super.key, required this.item, this.width, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: padding ?? EdgeInsets.only(top: 16, left: 16, right: 16),
      height: 230,
      width: width ?? MediaQuery.of(context).size.width - 32,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
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
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(17),
                color: Colors.white.withOpacity(0.8),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 4,
                    offset: Offset(0, 4),
                    spreadRadius: 0,
                  )
                ]),
          ),
          Container(
            padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          name: item.startDate?.month
                                  .toString()
                                  .padLeft(2, "0") ??
                              "",
                          size: 20,
                        ),
                        SaudiDay(
                          name: '  / ',
                          size: 20,
                        ),
                        SaudiDay(
                          name:
                              item.startDate?.day.toString().padLeft(2, "0") ??
                                  "",
                          size: 28,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    SaudiDay(
                      name: (item.name ?? ""),
                      height: 1.1,
                      size: 20,
                    ),
                  ],
                ),
                SaudiContainer(
                  btnText: "saudi_calendar_add".tr(),
                  remainingText: "remaining".tr(),
                  timer: item.remainingDays(),
                  addToCalendar: () {
                    CommonFunctions.sendUXCamEvent(
                        UXCamEvents.KingdomCalendar_List_AddToCalender_Event);

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
        ],
      ),
    );
  }
}

class SaudiDay extends StatelessWidget {
  final String name;
  final double size;
  final double? height;
  const SaudiDay(
      {super.key, required this.name, required this.size, this.height});

  @override
  Widget build(BuildContext context) {
    return CustomTextWidget(
      name,
      fontColor: const Color(0xFF145E75),
      fontSize: size,
      maxLines: 2,
      height: height,
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
      height: 71,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Color(0x8cffffff),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
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
          Container(
            height: 40,
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
