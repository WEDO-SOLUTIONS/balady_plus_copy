import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/constants/paths/image_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_popups_widgets.dart';
import 'package:balady_plus/app/features/balady_calender/presentation/mvvm/balady_calendar_years_list_view_model.dart';
import 'package:balady_plus/app/features/balady_calender/presentation/widgets/calendar_type_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

class ActionShowTypeDateWidget extends StatelessWidget {
  const ActionShowTypeDateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    BaladyCalendarYearsListViewModel baladyCalendarYearsListViewModel =
        context.read<BaladyCalendarYearsListViewModel>();
    return GestureDetector(
      onTap: () async {
        var isHijri = await CustomPopUpsWidgets.showBottomSheet(
          context,
          child: CalendarTypePopup(
            isHijri: baladyCalendarYearsListViewModel.params.hijri ? 2 : 1,
          ),
          height: 300,
          radius: 30,
        );
        if (isHijri is int) {
          baladyCalendarYearsListViewModel.params.hijri = isHijri == 2;
          baladyCalendarYearsListViewModel.selectedYear = null;
          baladyCalendarYearsListViewModel.getEventsCountInYears();
        }
      },
      child: Container(
        height: 50,
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: AppColor.lightGreen2.withOpacity(0.1),
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              IconPath.baladyCalendar,
              width: 25,
              height: 25,
            ),
            const SizedBox(width: 2),
            Selector<BaladyCalendarYearsListViewModel, bool>(
              selector: (_, provider) => provider.params.hijri,
              builder: (BuildContext context, hijri, Widget? child) {
                return Text(
                  hijri
                      ? "balady_calendar_hijri".tr()
                      : "balady_calendar_gregorian".tr(),
                  style: AppStyle.mainTextStyle.copyWith(fontSize: 10),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
