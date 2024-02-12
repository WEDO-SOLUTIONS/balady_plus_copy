import 'package:balady_plus/app/features/balady_calender/data/models/events_count_in_years/events_count_in_years_item.dart';
import 'package:balady_plus/app/features/balady_calender/presentation/mvvm/balady_calendar_years_list_view_model.dart';
import 'package:flutter/material.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:provider/provider.dart';

class BaladyCalendarYearsList extends StatelessWidget {
  const BaladyCalendarYearsList({super.key});

  @override
  Widget build(BuildContext context) {
    BaladyCalendarYearsListViewModel baladyCalendarYearsListViewModel =
        context.watch<BaladyCalendarYearsListViewModel>();
    return SizedBox(
      height: 85,
      width: double.infinity,
      child: Selector<BaladyCalendarYearsListViewModel,
          List<EventsCountInYearsItem>?>(
        selector: (_, provider) => provider.yearList,
        builder: (context, yearsList, child) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: yearsList?.length ?? 0,
            itemBuilder: (context, index) {
              return Selector<BaladyCalendarYearsListViewModel,
                  EventsCountInYearsItem?>(
                selector: (_, provider) => provider.selectedYear,
                builder: (context, selectedYear, child) {
                  return GestureDetector(
                    onTap: () {
                      baladyCalendarYearsListViewModel
                          .selectYear(yearsList[index]);
                    },
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: selectedYear?.year == yearsList![index].year
                            ? AppColor.primary700Light
                            : AppColor.white5,
                      ),
                      width: 80,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(yearsList[index].year.toString(),
                              style: AppStyle.blackTextStyle.copyWith(
                                fontWeight: FontWeight.w600,
                                color:
                                    selectedYear?.year == yearsList[index].year
                                        ? Colors.white
                                        : Colors.black,
                              )),
                          const SizedBox(
                            height: 5,
                          ),
                          Text('(${yearsList[index].eventsCount.toString()})',
                              style: AppStyle.serviceTitleStyle.copyWith(
                                fontWeight: FontWeight.w600,
                                color:
                                    selectedYear?.year == yearsList[index].year
                                        ? Colors.white
                                        : Colors.black,
                              ))
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
