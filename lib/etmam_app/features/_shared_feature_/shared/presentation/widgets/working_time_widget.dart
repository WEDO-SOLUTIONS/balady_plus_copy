import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show
        CustomHorizontalSpace,
        CustomIconButtonWidget,
        CustomSvgIconWidget,
        CustomTextWidget,
        CustomVerticalSpace,
        DrawLineWidget;
import 'package:collection/collection.dart';

import 'package:balady_plus/etmam_app/features/services/services_exports.dart'
    show WorkDay;
import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppFontWeight, CommonFunctions, IconPath, trans;

class WorkingDayListWidget extends StatefulWidget {
  final List<WorkDay>? workingHours;

  const WorkingDayListWidget({Key? key, required this.workingHours})
      : super(key: key);

  @override
  State<WorkingDayListWidget> createState() => _WorkingDayListWidgetState();
}

class _WorkingDayListWidgetState extends State<WorkingDayListWidget> {
  bool showAll = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          showAll = !showAll;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CustomSvgIconWidget(
                  IconPath.workingHoursIcon,
                  iconSize: 16,
                  iconColor: AppColor.primary600,
                ),
                const CustomHorizontalSpace(width: 4),
                CustomTextWidget(
                  trans('working_time'),
                  fontColor: AppColor.black,
                  fontWeight: AppFontWeight.bold,
                  fontSize: 13,
                  textAlign: TextAlign.start,
                ),
                Spacer(),
                CustomSvgIconWidget(
                  showAll
                      ? IconPath.expansionArrowUp
                      : IconPath.expansionArrowDown,
                  iconWidth: 9.5,
                  iconHeight: 5.5,
                  iconColor: AppColor.baladyDarkGreen2,
                ),
              ],
            ),
            if (showAll) const CustomVerticalSpace(height: 8),
            if (showAll)
              Column(
                children: widget.workingHours
                        ?.mapIndexed((index, e) => WorkingTimeWidget(
                              dayName: e.day ?? "",
                              firstShiftFromTime: e.firstShift?.from ?? "",
                              firstShiftToTime: e.firstShift?.to ?? "",
                              secondShiftFromTime: e.secondShift?.from ?? "",
                              secondShiftToTime: e.secondShift?.to ?? "",
                              showAll: showAll &&
                                  index !=
                                      ((widget.workingHours?.length ?? 0) - 1),
                              isClosed: e.closed ?? false,
                              isOpen24Hours: e.fullTime ?? false,
                            ))
                        .toList() ??
                    [],
              ),
            /*MediaQuery.removePadding(
              context: context,
              removeTop: true,
              removeBottom: true,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: showAll ? widget.workingHours?.length : 0,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (ctx, index) {
                    return WorkingTimeWidget(
                      dayName: widget.workingHours?[index].day ?? "",
                      firstShiftFromTime:
                          widget.workingHours?[index].firstShift?.from ?? "",
                      firstShiftToTime:
                          widget.workingHours?[index].firstShift?.to ?? "",
                      secondShiftFromTime:
                          widget.workingHours?[index].secondShift?.from ?? "",
                      secondShiftToTime:
                          widget.workingHours?[index].secondShift?.to ?? "",
                      showAll: showAll &&
                          index != ((widget.workingHours?.length ?? 0) - 1),
                      isClosed: widget.workingHours?[index].closed ?? false,
                      isOpen24Hours:
                          widget.workingHours?[index].fullTime ?? false,
                    );
                  }),
            ),*/
            const CustomVerticalSpace(height: 24)
          ],
        ),
      ),
    );
  }
}

/*class WorkingTimeWidget extends StatelessWidget {
  final String dayName;
  final String firstShiftFromTime;
  final String firstShiftToTime;
  final String? secondShiftFromTime;
  final String? secondShiftToTime;
  final bool showAll;
  final bool isClosed;
  final bool isOpen24Hours;

  const WorkingTimeWidget(
      {Key? key,
      required this.dayName,
      required this.firstShiftFromTime,
      required this.firstShiftToTime,
      this.secondShiftFromTime,
      this.secondShiftToTime,
      this.showAll = false,
      this.isClosed = false,
      this.isOpen24Hours = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CustomTextWidget(
                  CommonFunctions.convertDayNameFromEnglishToArabic(dayName),
                  fontSize: 12,
                  fontWeight: AppFontWeight.regular,
                  fontColor: AppColor.purpleColor,
                  maxLines: 1,
                ),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextWidget(
                      getTimeText(),
                      fontSize: 12,
                      fontWeight: AppFontWeight.regular,
                      fontColor: getTimeTextColor(),
                      maxLines: 1,
                    ),
                    if (secondShiftToTime != null &&
                        secondShiftToTime!.isNotEmpty &&
                        secondShiftFromTime != null &&
                        secondShiftFromTime!.isNotEmpty &&
                        !isClosed &&
                        !isOpen24Hours) ...[
                      const CustomVerticalSpace(height: 5),
                      CustomTextWidget(
                        trans('work_time_from') +
                            " " +
                            getTime(secondShiftFromTime ?? "") +
                            " " +
                            trans('work_time_to') +
                            " " +
                            getTime(secondShiftToTime ?? ""),
                        fontSize: 12,
                        fontWeight: AppFontWeight.regular,
                        fontColor: AppColor.bottomNavigationShadow,
                        maxLines: 1,
                      )
                    ]
                  ],
                ),
              ),
            ],
          ),
          if (showAll)
            const DrawLineWidget(
              verticalMargin: 8,
            )
        ],
      ),
    );
  }

  String getTime(String time) {
    return CommonFunctions.getFormattedTime(time);
  }

  String getTimeText() {
    if (isClosed) {
      return trans('closed');
    } else if (isOpen24Hours) {
      return trans('open_24_hours');
    } else if (firstShiftFromTime.isNotEmpty || firstShiftToTime.isNotEmpty) {
      return trans('work_time_from') +
          " " +
          getTime(firstShiftFromTime) +
          " " +
          trans('work_time_to') +
          " " +
          getTime(firstShiftToTime);
    } else {
      return "-";
    }
  }

  Color getTimeTextColor() {
    if (isClosed) {
      return AppColor.redForCancel;
    } else if (isOpen24Hours) {
      return AppColor.approvedOrderTextColor;
    } else {
      return AppColor.bottomNavigationShadow;
    }
  }
}*/

class WorkingTimeWidget extends StatelessWidget {
  final String dayName;
  final String firstShiftFromTime;
  final String firstShiftToTime;
  final String? secondShiftFromTime;
  final String? secondShiftToTime;
  final bool showAll;
  final bool isClosed;
  final bool isOpen24Hours;

  const WorkingTimeWidget(
      {Key? key,
      required this.dayName,
      required this.firstShiftFromTime,
      required this.firstShiftToTime,
      this.secondShiftFromTime,
      this.secondShiftToTime,
      this.showAll = false,
      this.isClosed = false,
      this.isOpen24Hours = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CustomTextWidget(
                  CommonFunctions.convertDayNameFromEnglishToArabic(dayName),
                  fontSize: 16,
                  fontWeight: AppFontWeight.medium,
                  fontColor: AppColor.black500,
                  maxLines: 1,
                ),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextWidget(
                      getTimeText(),
                      fontSize: 16,
                      fontWeight: AppFontWeight.regular,
                      fontColor: getTimeTextColor(),
                      maxLines: 1,
                    ),
                    if (secondShiftToTime != null &&
                        secondShiftToTime!.isNotEmpty &&
                        secondShiftFromTime != null &&
                        secondShiftFromTime!.isNotEmpty &&
                        !isClosed &&
                        !isOpen24Hours) ...[
                      const CustomVerticalSpace(height: 5),
                      CustomTextWidget(
                        trans('work_time_from') +
                            " " +
                            getTime(secondShiftFromTime ?? "") +
                            " " +
                            trans('work_time_to') +
                            " " +
                            getTime(secondShiftToTime ?? ""),
                        fontSize: 16,
                        fontWeight: AppFontWeight.regular,
                        fontColor: AppColor.black500,
                        maxLines: 1,
                      )
                    ]
                  ],
                ),
              ),
            ],
          ),
          if (showAll)
            const DrawLineWidget(
              verticalMargin: 8,
            )
        ],
      ),
    );
  }

  String getTime(String time) {
    return CommonFunctions.getFormattedTime(time);
  }

  String getTimeText() {
    if (isClosed) {
      return trans('closed');
    } else if (isOpen24Hours) {
      return trans('open_24_hours');
    } else if (firstShiftFromTime.isNotEmpty || firstShiftToTime.isNotEmpty) {
      return trans('work_time_from') +
          " " +
          getTime(firstShiftFromTime) +
          " " +
          trans('work_time_to') +
          " " +
          getTime(firstShiftToTime);
    } else {
      return "-";
    }
  }

  Color getTimeTextColor() {
    if (isClosed) {
      return AppColor.redBrown;
    } else if (isOpen24Hours) {
      return AppColor.greenishYellow500;
    } else {
      return AppColor.black500;
    }
  }
}
