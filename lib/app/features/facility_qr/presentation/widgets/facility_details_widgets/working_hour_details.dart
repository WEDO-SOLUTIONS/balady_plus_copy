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
}
