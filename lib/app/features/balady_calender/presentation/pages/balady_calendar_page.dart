import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/balady_calender/data/models/events_count_in_months/months_events_count.dart';
import 'package:balady_plus/app/features/balady_calender/domain/entities/events_common_params.dart';
import 'package:balady_plus/app/features/balady_calender/domain/entities/events_details_params.dart';
import 'package:balady_plus/app/features/balady_calender/presentation/bloc/events_list_cubit.dart';
import 'package:balady_plus/app/features/balady_calender/presentation/mvvm/balady_calendar_years_list_view_model.dart';
import 'package:balady_plus/app/features/balady_calender/presentation/widgets/action_show_type_date_widget.dart';
import 'package:balady_plus/app/features/balady_calender/presentation/widgets/balady_calendar_events_widget.dart';
import 'package:balady_plus/app/features/balady_calender/presentation/widgets/balady_calendar_years_list.dart';
import 'package:balady_plus/app/features/home_page/home_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

class BaladyCalendarPage extends StatelessWidget {
  const BaladyCalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => BaladyCalendarYearsListViewModel(
        repository: sl(),
        params: EventsCommonParams(),
      ),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                // AppBar
                Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: CircleIcon(
                        icon: Icons.close,
                        iconColor: AppColor.primary600Light,
                        backgroundColor: AppColor.geyser.withOpacity(0.5),
                        iconSize: 18,
                      ),
                    ),
                    const SizedBox(width: 15),
                    CustomTextWidget(
                      "balady_calendar".tr(),
                      textStyle: AppStyle.appBarTitleTextStyle,
                    ),
                    const Spacer(),
                    const ActionShowTypeDateWidget(),
                    const SizedBox(width: 10),
                    const ActionShowTypeDateWidget(),
                  ],
                ),
                const SizedBox(height: 20),
                const BaladyCalendarYearsList(),
                Expanded(
                  child: Selector<BaladyCalendarYearsListViewModel, bool>(
                    selector: (_, provider) => provider.isLoading,
                    builder: (_, isLoading, child) {
                      // if Loading
                      if (isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return Selector<BaladyCalendarYearsListViewModel,
                          List<MonthsEventsCount>?>(
                        selector: (_, provider) => provider.monthsList,
                        builder: (_, monthsList, child) {
                          // if have errors
                          if (monthsList == null) {
                            return const Center(
                              child: Text(
                                "Not Have Any Events In The Years !",
                              ),
                            );
                          }

                          // done get Data
                          return BlocProvider<EventsListCubit>(
                            create: (BuildContext context) => EventsListCubit(
                              baladyCalendarRepository: sl(),
                              listMonths: monthsList,
                              params: EventsDetailsParams(
                                commonParams: context.read<BaladyCalendarYearsListViewModel>().paramsMonths,
                                size: 5,
                              ),
                            ),
                            child: const BaladyCalendarEventsWidget(),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
