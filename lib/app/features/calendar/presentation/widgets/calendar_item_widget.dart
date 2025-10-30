import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/paths/image_paths.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../domain/entities/search_calendar/search_calendar_item.dart';
import 'calendar_image_widget.dart';

class CalendarItemWidget extends StatelessWidget {
  final SearchCalendarItem item;
  final Function onPress;
  const CalendarItemWidget(
      {super.key, required this.item, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPress(),
      child: Container(
        height: 180,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Color(0x4CE9EAF1),
              blurRadius: 40,
              offset: Offset(0, 10),
              spreadRadius: 0,
            ),
          ],
          image: calendarImage(item.logoURL, ImagePath.calendarBackground),
        ),
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.65,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CalendarTag(
                      text: item.type ?? "",
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    CustomTextWidget(
                      item.name ?? "",
                      fontColor: const Color(0xFF3F3F46),
                      fontSize: 14,
                      fontWeight: AppFontWeight.bold,
                      height: 1.4,
                      maxLines: 2,
                      textOverflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    CustomTextWidget(
                      item.getDate(),
                      fontColor: const Color(0xFF71717A),
                      fontSize: 12,
                      fontWeight: AppFontWeight.bold,
                      height: 1.4,
                      maxLines: 2,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButtonWidget.primaryCustomBorder(
                        height: 40,
                        width: 130,
                        onPressed: () {
                          Add2Calendar.addEvent2Cal(
                            buildEvent(
                              title: item.name ?? "",
                              startDate: item.startDate!,
                              endDate: (item.endDate) ?? (item.startDate!),
                            ),
                          );
                        },
                        fontSize: 12,
                        text: "saudi_calendar_add".tr())
                  ]),
            ),
            if (item.timeToStartInDays != null)
              RemainingDaysWidget(
                dayNo: item.timeToStartInDays!,
              )
          ],
        ),
      ),
    );
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
}

class CalendarTag extends StatelessWidget {
  final String text;
  const CalendarTag({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: ShapeDecoration(
        color: Color(0x3FA7C587),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      child: CustomTextWidget(
        text,
        fontColor: AppColor.primary900Light,
        fontSize: 12,
        fontWeight: AppFontWeight.semiBold,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class RemainingDaysWidget extends StatelessWidget {
  final int dayNo;
  const RemainingDaysWidget({super.key, required this.dayNo});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        width: 65,
        height: 93,
        padding: EdgeInsets.all(9),
        decoration: ShapeDecoration(
          color: Color(0xFF145E75),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomTextWidget(
                "remaining".tr(),
                fontColor: AppColor.white,
                fontSize: 12,
                fontWeight: AppFontWeight.medium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 8,
              ),
              CustomTextWidget(
                dayNo.toString(),
                fontColor: AppColor.white,
                fontSize: 26,
                fontWeight: AppFontWeight.bold,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 8,
              ),
              CustomTextWidget(
                "saudi_calendar_day_text".tr(),
                fontColor: AppColor.white,
                fontSize: 12,
                fontWeight: AppFontWeight.medium,
                textAlign: TextAlign.center,
              ),
            ]),
      ),
    );
  }
}
