import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/facility_qr/data/qr_details_response.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../_shared_feature_/shared_feature_exports.dart'
    show LabelIconComponent, CustomTextWidget, CustomVerticalSpace;

class WorkingHourDetails extends StatefulWidget {
  bool openNow;
  String todayWorkingHours = "";
  WorkTimes workingHours;

  WorkingHourDetails(
      {required this.openNow,
      required this.todayWorkingHours,
      required this.workingHours});

  @override
  _WorkingHourDetailsState createState() => _WorkingHourDetailsState();
}

class _WorkingHourDetailsState extends State<WorkingHourDetails> {
  bool showDays = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          boxShadow: [],
          borderRadius: BorderRadius.circular(16),
          color: AppColor.white),
      child: Column(
        children: [
          LabelIconComponent(
            text: ('working_hours').tr(),
            icon: IconPath.qrClockIcon,
          ),
          CustomVerticalSpace(height: 10),
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            showDays = !showDays;
                          });
                        },
                        child: CustomTextWidget(
                          widget.openNow
                              ? ("lbl_open_now").tr()
                              : ("closed").tr(),
                          fontColor: widget.openNow
                              ? AppColor.greenishYellow800
                              : AppColor.red,
                          fontWeight: AppFontWeight.medium,
                          fontSize: 16,
                        )),
                    Visibility(
                        visible: !showDays,
                        child: CustomTextWidget(
                          widget.todayWorkingHours,
                          fontColor: AppColor.black500,
                          fontWeight: AppFontWeight.medium,
                          fontSize: 16,
                        )),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      showDays = !showDays;
                    });
                  },
                  child: Image.asset(
                    !showDays
                        ? IconPath.qrArrowDownIcon
                        : IconPath.qrArrowUpIcon,
                    height: 16,
                    width: 16,
                  ),
                ),
              ],
            ),
          ),
          Visibility(
              visible: showDays,
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.workingHours.workingTimes?.length,
                    physics: const ScrollPhysics(),
                    itemBuilder: (ctx, index) {
                      String closedOr24Hours = "";
                      bool closeDay = widget.workingHours.workingTimes?[index]
                              .openShiftOption ==
                          "CLOSED";
                      bool hours24 = widget.workingHours.workingTimes?[index]
                              .openShiftOption ==
                          "OPEN_24HOUR";
                      if (closeDay) {
                        closedOr24Hours = ("qr_facility_Closed").tr();
                      } else if (hours24) {
                        closedOr24Hours = ("qr_facility_opened_24").tr();
                      }

                      return Container(
                        margin: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                flex: 3,
                                child: CustomTextWidget(
                                  widget.workingHours.workingTimes?[index]
                                          .dayName ??
                                      "",
                                  fontColor: AppColor.black500,
                                  fontWeight: widget.workingHours
                                              .workingTimes?[index].isToday ??
                                          false
                                      ? AppFontWeight.bold
                                      : AppFontWeight.medium,
                                  fontSize: 16,
                                  textAlign: TextAlign.start,
                                )),
                            !(widget.workingHours.workingTimes?[index]
                                        .dayHasTwoShifts() ??
                                    true)
                                ? Expanded(
                                    flex: 8,
                                    child: CustomTextWidget(
                                      closedOr24Hours.isNotEmpty
                                          ? closedOr24Hours
                                          : CommonFunctions
                                              .getFormattedTimeforQR(
                                                  widget
                                                      .workingHours
                                                      .workingTimes?[index]
                                                      .firstFromTime,
                                                  widget
                                                      .workingHours
                                                      .workingTimes?[index]
                                                      .firstToTime),
                                      fontColor: AppColor.black500,
                                      fontSize: 16,
                                      fontWeight: widget
                                                  .workingHours
                                                  .workingTimes?[index]
                                                  .isToday ??
                                              false
                                          ? AppFontWeight.bold
                                          : AppFontWeight.medium,
                                      textAlign: TextAlign.start,
                                    ),
                                  )
                                : Expanded(
                                    flex: 8,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomTextWidget(
                                          closedOr24Hours.isNotEmpty
                                              ? closedOr24Hours
                                              : CommonFunctions
                                                  .getFormattedTimeforQR(
                                                      widget
                                                          .workingHours
                                                          .workingTimes?[index]
                                                          .firstFromTime,
                                                      widget
                                                          .workingHours
                                                          .workingTimes?[index]
                                                          .firstToTime),
                                          fontColor: AppColor.black500,
                                          fontSize: 16,
                                          fontWeight: widget
                                                      .workingHours
                                                      .workingTimes?[index]
                                                      .isToday ??
                                                  false
                                              ? AppFontWeight.bold
                                              : AppFontWeight.medium,
                                          textAlign: TextAlign.start,
                                        ),
                                        const CustomVerticalSpace(
                                          height: 5,
                                        ),
                                        CustomTextWidget(
                                          closedOr24Hours.isNotEmpty
                                              ? closedOr24Hours
                                              : CommonFunctions
                                                  .getFormattedTimeforQR(
                                                      widget
                                                          .workingHours
                                                          .workingTimes?[index]
                                                          .secondFromTime,
                                                      widget
                                                          .workingHours
                                                          .workingTimes?[index]
                                                          .secondToTime),
                                          fontColor: AppColor.black500,
                                          fontSize: 16,
                                          fontWeight: widget
                                                      .workingHours
                                                      .workingTimes?[index]
                                                      .isToday ??
                                                  false
                                              ? AppFontWeight.bold
                                              : AppFontWeight.medium,
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                  )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ))
        ],
      ),
    );
  }

/* String getFormattedTime(String timeFrom, String timeTo) {
    if (timeFrom != null && timeTo != null) {
      int hoursFrom = int.tryParse(timeFrom.split(":")[0]) != null
          ? int.parse(timeFrom.split(":")[0])
          : null;
      int hoursTo = int.tryParse(timeTo.split(":")[0]) != null
          ? int.parse(timeTo.split(":")[0])
          : null;

      int minuteFrom = int.tryParse(timeFrom.split(":")[1]) != null
          ? int.parse(timeFrom.split(":")[1])
          : null;
      int minuteTo = int.tryParse(timeTo.split(":")[1]) != null
          ? int.parse(timeTo.split(":")[1])
          : null;
      String minuteFromStr = minuteFrom < 10 ? "0$minuteFrom" : "$minuteFrom";
      String minuteToStr = minuteTo < 10 ? "0$minuteTo" : "$minuteTo";
      TimeOfDay fromTime =
          TimeOfDay(hour: hoursFrom, minute: minuteFrom); // 3:00 PM
      TimeOfDay toTime = TimeOfDay(hour: hoursTo, minute: minuteTo); // 5:00 AM

      int hoursFromAS12 = hoursFrom;
      int hoursToAS12 = hoursTo;

      if (hoursFrom == 0) hoursFromAS12 += 12;

      if (hoursTo == 0) hoursToAS12 += 12;

      if (hoursFrom >= 13 && hoursFrom <= 23)
        hoursFromAS12 = hoursFromAS12 - 12;

      if (hoursTo >= 13 && hoursTo <= 23) hoursToAS12 = hoursToAS12 - 12;

      String time = "";

      if (fromTime.period == DayPeriod.am && toTime.period == DayPeriod.am) {
        time = "$hoursFromAS12:$minuteFromStr - $hoursToAS12:$minuteToStr ص";
        return time;
      } else if (fromTime.period == DayPeriod.pm &&
          toTime.period == DayPeriod.pm) {
        time = "$hoursFromAS12:$minuteFromStr - $hoursToAS12:$minuteToStr م";
        return time;
      } else {
        String from = "";
        String to = "";
        if (fromTime.period == DayPeriod.pm)
          from = "$hoursFromAS12:$minuteFromStr م";

        if (fromTime.period == DayPeriod.am)
          from = "$hoursFromAS12:$minuteFromStr ص";

        if (toTime.period == DayPeriod.pm) to = "$hoursToAS12:$minuteToStr م";

        if (toTime.period == DayPeriod.am) to = "$hoursToAS12:$minuteToStr ص";

        print(from);
        print(to);
        print(hoursToAS12);
        return "$from - $to";
      }
    }
    return "";
  }

*/ /*String getTodayWorkingHours(){

if (widget.workingHours.getToday().openShiftOption == describeEnum(ShiftOption.CLOSED) ||
widget.workingHours.getToday().openShiftOption == describeEnum(ShiftOption.OPEN_24HOUR)
 ){
   return "";
 }

return getFormattedTime(widget.workingHours.getToday().firstFromTime, widget.workingHours.getToday().firstToTime) + " . ";

}*/ /*

  String getTodayWorkingHours() {
    if (widget.workingHours.getToday() != null) {
      if (widget.workingHours.getToday().openShiftOption ==
          describeEnum(ShiftOption.OPEN_24HOUR)) {
        return "";
      }

      int firstFromHour =
          widget.workingHours.getToday().firstFromTime != null &&
                  int.tryParse(widget.workingHours
                          .getToday()
                          .firstFromTime
                          .split(":")[0]) !=
                      null
              ? int.parse(
                  widget.workingHours.getToday().firstFromTime.split(":")[0])
              : null;
      int firstFromMinute =
          widget.workingHours.getToday().firstFromTime != null &&
                  int.tryParse(widget.workingHours
                          .getToday()
                          .firstFromTime
                          .split(":")[1]) !=
                      null
              ? int.parse(
                  widget.workingHours.getToday().firstFromTime.split(":")[1])
              : null;
      int firstToHour = widget.workingHours.getToday().firstToTime != null &&
              int.tryParse(widget.workingHours
                      .getToday()
                      .firstToTime
                      .split(":")[0]) !=
                  null
          ? int.parse(widget.workingHours.getToday().firstToTime.split(":")[0])
          : null;
      int firstToMinute = widget.workingHours.getToday().firstToTime != null &&
              int.tryParse(widget.workingHours
                      .getToday()
                      .firstToTime
                      .split(":")[1]) !=
                  null
          ? int.parse(widget.workingHours.getToday().firstToTime.split(":")[1])
          : null;

      int secondFromHour =
          widget.workingHours.getToday().secondFromTime != null &&
                  int.tryParse(widget.workingHours
                          .getToday()
                          .secondFromTime
                          .split(":")[0]) !=
                      null
              ? int.parse(
                  widget.workingHours.getToday().secondFromTime.split(":")[0])
              : null;
      int secondFromMinute =
          widget.workingHours.getToday().secondFromTime != null &&
                  int.tryParse(widget.workingHours
                          .getToday()
                          .secondFromTime
                          .split(":")[1]) !=
                      null
              ? int.parse(
                  widget.workingHours.getToday().secondFromTime.split(":")[1])
              : null;
      int secondToHour = widget.workingHours.getToday().secondToTime != null &&
              int.tryParse(widget.workingHours
                      .getToday()
                      .secondToTime
                      .split(":")[0]) !=
                  null
          ? int.parse(widget.workingHours.getToday().secondToTime.split(":")[0])
          : null;
      int secondToMinute = widget.workingHours.getToday().secondToTime !=
                  null &&
              int.tryParse(widget.workingHours
                      .getToday()
                      .secondToTime
                      .split(":")[1]) !=
                  null
          ? int.parse(widget.workingHours.getToday().secondToTime.split(":")[1])
          : null;

      if (widget.openNow &&
          widget.workingHours.getToday().openShiftOption ==
              describeEnum(ShiftOption.SHIFTED)) {
        if (firstFromHour != null &&
            firstFromMinute != null &&
            firstToHour != null &&
            firstToMinute != null) {
          DateTime date = DateTime.now();
          final startTime = DateTime(
              date.year, date.month, date.day, firstFromHour, firstFromMinute);
          final endTime = DateTime(
              date.year, date.month, date.day, firstToHour, firstToMinute);
          final currentTime = DateTime.now();
          if (currentTime.isAfter(startTime) && currentTime.isBefore(endTime)) {
            return " . يغلق " +
                convert24TimeTo12WithPeriod(
                    widget.workingHours.getToday().firstToTime);
          }
        }
        if (secondFromHour != null &&
            secondFromMinute != null &&
            secondToHour != null &&
            secondToMinute != null) {
          DateTime date = DateTime.now();

          final startTime = DateTime(date.year, date.month, date.day,
              secondFromHour, secondFromMinute);
          final endTime = DateTime(
              date.year, date.month, date.day, secondToHour, secondToMinute);
          final currentTime = DateTime.now();
          if (currentTime.isAfter(startTime) && currentTime.isBefore(endTime)) {
            return " . يغلق " +
                convert24TimeTo12WithPeriod(
                    widget.workingHours.getToday().secondToTime);
          }
        }
      } else if (!widget.openNow &&
          widget.workingHours.getToday().openShiftOption ==
              describeEnum(ShiftOption.SHIFTED)) {
        if (firstFromHour != null && firstFromMinute != null) {
          DateTime date = DateTime.now();
          final startTime = DateTime(
              date.year, date.month, date.day, firstFromHour, firstFromMinute);
          final currentTime = DateTime.now();
          if (currentTime.isBefore(startTime)) {
            return " . يفتح " +
                convert24TimeTo12WithPeriod(
                    widget.workingHours.getToday().firstFromTime);
          }
        }

        if (secondFromHour != null && secondFromMinute != null) {
          DateTime date = DateTime.now();
          final startTime = DateTime(date.year, date.month, date.day,
              secondFromHour, secondFromMinute);
          final currentTime = DateTime.now();
          if (currentTime.isBefore(startTime)) {
            return " . يفتح " +
                convert24TimeTo12WithPeriod(
                    widget.workingHours.getToday().secondFromTime);
          }
        }
      }
      if (!widget.openNow) {
        String strWhenClosed = "";
        int nextDayWeekDay =
            widget.workingHours.getToday().weekDay == DateTime.sunday
                ? DateTime.monday
                : widget.workingHours.getToday().weekDay + 1;

        for (int i = 0; i < widget.workingHours.workingTimes.length; i++) {
          int nextDay = widget.workingHours.workingTimes
              .indexWhere((element) => element.weekDay == nextDayWeekDay);

          if (nextDay != -1) {
            QrWorkingTimesDto day = widget.workingHours.workingTimes[nextDay];
            if (day.openShiftOption == describeEnum(ShiftOption.OPEN_24HOUR)) {
              if (i == 0)
                strWhenClosed = " . يفتح غداً ";
              else
                strWhenClosed = " . يفتح ${day.dayName}";
              return strWhenClosed;
            } else if (day.openShiftOption ==
                describeEnum(ShiftOption.SHIFTED)) {
              strWhenClosed =
                  " . يفتح ${day.dayName} ${convert24TimeTo12WithPeriod(day.firstFromTime)}";
              return strWhenClosed;
            } else if (day.openShiftOption ==
                describeEnum(ShiftOption.CLOSED)) {
              nextDayWeekDay = nextDayWeekDay == DateTime.sunday
                  ? DateTime.monday
                  : nextDay + 1;
            }
          }
        }

        return strWhenClosed;
      }

      return " . " +
          getFormattedTime(widget.workingHours.getToday().firstFromTime,
              widget.workingHours.getToday().firstToTime);
    }
    return "";
  }

  String convert24TimeTo12WithPeriod(String time) {
    if (time != null) {
      int hoursFrom = int.tryParse(time.split(":")[0]) != null
          ? int.parse(time.split(":")[0])
          : null;
      int minuteFrom = int.tryParse(time.split(":")[1]) != null
          ? int.parse(time.split(":")[1])
          : null;

      TimeOfDay fromTime =
          TimeOfDay(hour: hoursFrom, minute: minuteFrom); // 3:00 PM

      int hoursFromAS12 = hoursFrom;

      if (hoursFrom == 0) hoursFromAS12 += 12;

      String minuteStr = minuteFrom < 10 ? "0$minuteFrom" : "$minuteFrom";

      if (hoursFrom >= 13 && hoursFrom <= 23)
        hoursFromAS12 = hoursFromAS12 - 12;

      if (fromTime.period == DayPeriod.pm) return "$hoursFromAS12:$minuteStr م";

      if (fromTime.period == DayPeriod.am)
        return "$hoursFromAS12:${minuteStr} ص";
    }
    return "";
  }
*/
}
