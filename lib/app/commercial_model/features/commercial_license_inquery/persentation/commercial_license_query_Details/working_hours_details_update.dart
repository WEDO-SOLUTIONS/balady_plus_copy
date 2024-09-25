import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/facility_qr/data/qr_details_response.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../features/_shared_feature_/presentation/components/texts/label_icon_component.dart';
import '../../../../../features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../../features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

class WorkingHourDetailsUpdate extends StatefulWidget {
  bool openNow;
  String todayWorkingHours = "";
  WorkTimes workingHours;
  String customerServiceNumber = "";
  WorkingHourDetailsUpdate(
      {required this.openNow,
      required this.todayWorkingHours,
      required this.workingHours,
      required this.customerServiceNumber});

  @override
  _WorkingHourDetailsUpdateState createState() =>
      _WorkingHourDetailsUpdateState();
}

class _WorkingHourDetailsUpdateState extends State<WorkingHourDetailsUpdate> {
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
          Visibility(visible: showDays == false, child: getHeaderWidget()),
          Visibility(
              visible: showDays,
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      showDays = !showDays;
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              color: AppColor.primary300Light,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.keyboard_arrow_up,
                              color: AppColor.white,
                            ),
                          ),
                        ],
                      ),
                      widget.customerServiceNumber.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomTextWidget(
                                      "step7label1".tr(),
                                      textStyle:
                                          AppStyle.eventsDetailsTitleStyle,
                                    ),
                                  ],
                                ),
                                CustomTextWidget(
                                  widget.customerServiceNumber,
                                  textStyle: AppStyle.complianceSubtitle,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Divider(
                                  height: 2,
                                  color: AppColor.blackModern200Light,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                              ],
                            )
                          : Container(),
                      CustomTextWidget(
                        "step11title7".tr(),
                        textStyle: AppStyle.eventsDetailsTitleStyle,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.workingHours.workingTimes?.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (ctx, index) {
                            String closedOr24Hours = "";
                            bool closeDay = widget.workingHours
                                    .workingTimes?[index].openShiftOption ==
                                "CLOSED";
                            bool hours24 = widget.workingHours
                                    .workingTimes?[index].openShiftOption ==
                                "OPEN_24HOUR";
                            if (closeDay) {
                              closedOr24Hours = ("close_status").tr();
                            } else if (hours24) {
                              closedOr24Hours = ("qr_facility_opened_24").tr();
                            }

                            return Container(
                              height: 50,
                              margin: const EdgeInsets.only(top: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: AppColor.mystic,
                              ),
                              child: Center(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10.0, left: 10),
                                          child: CustomTextWidget(
                                            widget
                                                    .workingHours
                                                    .workingTimes?[index]
                                                    .dayName ??
                                                "",
                                            fontColor:
                                                AppColor.blackModern600Light,
                                            fontWeight: AppFontWeight.bold,
                                            fontSize: 13,
                                            textAlign: TextAlign.start,
                                          ),
                                        )),
                                    !(widget.workingHours.workingTimes?[index]
                                                .dayHasTwoShifts() ??
                                            true)
                                        ? Expanded(
                                            flex: 1,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, right: 10),
                                              child: CustomTextWidget(
                                                closedOr24Hours.isNotEmpty
                                                    ? closedOr24Hours
                                                    : CommonFunctions
                                                        .getFormattedTimeforQR(
                                                            widget
                                                                .workingHours
                                                                .workingTimes?[
                                                                    index]
                                                                .firstFromTime,
                                                            widget
                                                                .workingHours
                                                                .workingTimes?[
                                                                    index]
                                                                .firstToTime),
                                                fontColor: AppColor
                                                    .blackModern600Light,
                                                fontSize: 13,
                                                fontWeight:
                                                    AppFontWeight.medium,
                                                textAlign: TextAlign.end,
                                              ),
                                            ),
                                          )
                                        : Expanded(
                                            flex: 1,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, right: 10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  CustomTextWidget(
                                                    closedOr24Hours.isNotEmpty
                                                        ? closedOr24Hours
                                                        : CommonFunctions.getFormattedTimeforQR(
                                                            widget
                                                                .workingHours
                                                                .workingTimes?[
                                                                    index]
                                                                .firstFromTime,
                                                            widget
                                                                .workingHours
                                                                .workingTimes?[
                                                                    index]
                                                                .firstToTime),
                                                    fontColor: AppColor
                                                        .blackModern600Light,
                                                    fontSize: 13,
                                                    fontWeight:
                                                        AppFontWeight.medium,
                                                    textAlign: TextAlign.end,
                                                  ),
                                                  const CustomVerticalSpace(
                                                    height: 5,
                                                  ),
                                                  CustomTextWidget(
                                                    closedOr24Hours.isNotEmpty
                                                        ? closedOr24Hours
                                                        : CommonFunctions.getFormattedTimeforQR(
                                                            widget
                                                                .workingHours
                                                                .workingTimes?[
                                                                    index]
                                                                .secondFromTime,
                                                            widget
                                                                .workingHours
                                                                .workingTimes?[
                                                                    index]
                                                                .secondToTime),
                                                    fontColor: AppColor
                                                        .blackModern600Light,
                                                    fontSize: 13,
                                                    fontWeight:
                                                        AppFontWeight.medium,
                                                    textAlign: TextAlign.end,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }

  Widget getHeaderWidget() {
    return Column(
      children: [
        LabelIconComponent(
          text: ('working_hours').tr(),
          icon: IconPath.qrClockIcon,
        ),
        CustomVerticalSpace(height: 10),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Row(
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
                              : ("close_status").tr(),
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
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    showDays = !showDays;
                  });
                },
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColor.primary300Light,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColor.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
