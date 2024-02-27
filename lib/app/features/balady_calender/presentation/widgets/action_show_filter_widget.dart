import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_popups_widgets.dart';
import 'package:balady_plus/app/features/balady_calender/presentation/mvvm/balady_calendar_years_list_view_model.dart';
import 'package:balady_plus/app/features/balady_calender/presentation/widgets/calendar_filter_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ActionShowFilterWidget extends StatelessWidget {
  const ActionShowFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    BaladyCalendarYearsListViewModel baladyCalendarYearsListViewModel =
        context.read<BaladyCalendarYearsListViewModel>();
    return GestureDetector(
      onTap: () async {
        baladyCalendarYearsListViewModel.idsSelected =
            baladyCalendarYearsListViewModel.params.filterationEntity ?? [];
        List<String>? idsSelected = await CustomPopUpsWidgets.showBottomSheet(
          context,
          child: ChangeNotifierProvider.value(
            value: baladyCalendarYearsListViewModel,
            child: const CalendarFilterPopup(),
          ),
          height: MediaQuery.sizeOf(context).height * 0.60,
          radius: 30,
        );
        if (idsSelected != null) {
          baladyCalendarYearsListViewModel.params.filterationEntity =
              idsSelected;
          baladyCalendarYearsListViewModel.getEventsCountInYears();
        }
      },
      child: Container(
        height: 50,
        width: 50,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColor.lightGreen2.withOpacity(0.1),
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: SvgPicture.asset(
          IconPath.filterCalendar,
        ),
      ),
    );
  }
}
