import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import 'package:balady_plus/app/features/balady_calender/domain/entities/events_count_in_months_params.dart';
import 'package:balady_plus/app/features/balady_calender/domain/entities/events_details_params.dart';
import 'package:balady_plus/app/features/balady_calender/presentation/bloc/events_list_cubit.dart';
import 'package:balady_plus/app/features/balady_calender/presentation/mvvm/balady_calendar_months_list_view_model.dart';
import 'package:balady_plus/app/features/balady_calender/presentation/mvvm/balady_calendar_years_list_view_model.dart';
import 'package:balady_plus/app/features/balady_calender/presentation/widgets/balady_calendar_month_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

class BaladyCalendarEventsWidget extends StatelessWidget {
  const BaladyCalendarEventsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    BaladyCalendarYearsListViewModel provider =
        context.read<BaladyCalendarYearsListViewModel>();
    return ChangeNotifierProvider<BaladyCalendarMonthsListViewModel>(
      create: (_) => BaladyCalendarMonthsListViewModel(
        repository: provider.repository,
        paramsMonths: EventsCountInMonthsParams(
          commonParams: provider.params,
          year: provider.selectedYear!.year,
        ),
      ),
      child: Selector<BaladyCalendarMonthsListViewModel, bool>(
        selector: (_, provider) => provider.isLoading,
        builder: (monthsProvider, isLoading, child) {
          BaladyCalendarMonthsListViewModel monthsListViewModel =
              monthsProvider.watch<BaladyCalendarMonthsListViewModel>();
          // if isLoading to get monthsList
          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // if have errors
          if (monthsListViewModel.errorMessage != null) {
            return Center(
              child: Text(
                monthsListViewModel.errorMessage!,
              ),
            );
          }

          // if not have Events
          if (monthsListViewModel.monthsList?.isEmpty ?? true) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    IconPath.noEvents,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text('no_events'.tr())
                ],
              ),
            );
          }

          return BlocProvider<EventsListCubit>(
            create: (BuildContext context) => EventsListCubit(
              baladyCalendarRepository: sl(),
              listMonths: monthsListViewModel.monthsList!,
              params: EventsDetailsParams(
                commonParams: monthsListViewModel.paramsMonths,
                size: 5,
              ),
            ),
            child: Builder(builder: (contextBloc) {
              return BlocBuilder<EventsListCubit, EventsListState>(
                bloc: contextBloc.watch<EventsListCubit>(),
                builder: (_, state) {
                  if (state is InitialEventsListState ||
                      state is LoadingEventsListState) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is FailureEventsListState) {
                    return ReloadWidget(
                      onTab: () => contextBloc
                          .read<EventsListCubit>()
                          .getCommercialLicenseDetailsById(
                            contextBloc.read<EventsListCubit>().params,
                          ),
                    );
                  }

                  /////////////////////////////////////////////////////////////////
                  /////////////////////////////////////////////////////////////////

                  // View Loading In after list item in list
                  if (state is SucceedWithPaginationEventsListState) {
                    ScrollController scrollController = ScrollController();
                    return ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return index == state.listMonths.length
                            ? const Center(child: CircularProgressIndicator())
                            : BaladyCalendarMonthWidget(
                                month: state.listMonths[index],
                                eventOfMonth:
                                    state.event[state.listMonths[index].month],
                              );
                      },
                      controller: scrollController
                        ..addListener(
                          () {
                            if (scrollController.position.pixels ==
                                scrollController.position.maxScrollExtent) {
                              contextBloc
                                  .read<EventsListCubit>()
                                  .getCommercialLicenseDetailsById(
                                    contextBloc.read<EventsListCubit>().params,
                                  );
                            }
                          },
                        ),
                      itemCount: state.listMonths.length + 1,
                    );
                  }

                  if (state is SucceedEventsListState) {
                    return ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return BaladyCalendarMonthWidget(
                          month: state.listMonths[index],
                          eventOfMonth:
                              state.event[state.listMonths[index].month],
                        );
                      },
                      itemCount: state.listMonths.length,
                    );
                  }

                  return const SizedBox();
                },
              );
            }),
          );
        },
      ),
    );
  }
}
