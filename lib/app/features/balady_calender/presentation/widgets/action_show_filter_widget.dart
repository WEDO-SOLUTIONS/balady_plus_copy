import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/paths/image_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_popups_widgets.dart';
import 'package:balady_plus/app/features/balady_calender/data/models/events_details/calendar_event_item.dart';
import 'package:balady_plus/app/features/balady_calender/presentation/mvvm/balady_calendar_years_list_view_model.dart';
import 'package:balady_plus/app/features/balady_calender/presentation/widgets/calendar_filter_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ListItemsEventsWidget extends StatelessWidget {
  final List<CalendarEventItem> listEvents;

  const ListItemsEventsWidget({super.key, required this.listEvents});

  @override
  Widget build(BuildContext context) {
    BaladyCalendarYearsListViewModel baladyCalendarYearsListViewModel =
        context.read<BaladyCalendarYearsListViewModel>();
    return GestureDetector(
      onTap: () async {
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
        height: 60,
        width: 60,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColor.white10,
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: SvgPicture.asset(ImagePath.filter),
      ),
    );
  }
}
