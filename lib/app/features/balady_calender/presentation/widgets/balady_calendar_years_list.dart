import 'package:balady_plus/app/features/balady_calender/data/models/events_count_in_years/events_count_in_years_item.dart';
import 'package:balady_plus/app/features/balady_calender/presentation/mvvm/balady_calendar_years_list_view_model.dart';
import 'package:flutter/material.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:provider/provider.dart';

class BaladyCalendarYearsList extends StatefulWidget {
  const BaladyCalendarYearsList({super.key});

  @override
  State<BaladyCalendarYearsList> createState() =>
      _BaladyCalendarYearsListState();
}

class _BaladyCalendarYearsListState extends State<BaladyCalendarYearsList> {
  int selectedYearIndex = 0;

  @override
  Widget build(BuildContext context) {
    BaladyCalendarYearsListViewModel baladyCalendarYearsListViewModel =
        context.watch<BaladyCalendarYearsListViewModel>();
    return SizedBox(
      height: 85,
      width: double.infinity,
      child: Selector<BaladyCalendarYearsListViewModel,
          List<EventsCountInYearsItem>?>(
        selector: (p0, p1) => p1.yearList,
        builder: (context, value, child) => ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: value?.length ?? 0,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedYearIndex = index;
                });
              },
              child: Container(
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: selectedYearIndex == index
                        ? AppColor.primary700Light
                        : AppColor.white5),
                width: 80,
                child: Column(children: [
                  Text(
                    value![index].year.toString(),
                    style: TextStyle(
                        color: selectedYearIndex == index
                            ? Colors.white
                            : Colors.black),
                  ),
                  Text(
                    value[index].eventsCount.toString(),
                    style: TextStyle(
                        color: selectedYearIndex == index
                            ? Colors.white
                            : Colors.black),
                  )
                ]),
              ),
            );
          },
        ),
      ),
    );
  }
}
