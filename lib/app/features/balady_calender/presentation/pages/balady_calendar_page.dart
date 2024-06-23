import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/balady_calender/data/models/events_count_in_years/events_count_in_years_item.dart';
import 'package:balady_plus/app/features/balady_calender/domain/entities/events_common_params.dart';
import 'package:balady_plus/app/features/balady_calender/presentation/mvvm/balady_calendar_years_list_view_model.dart';
import 'package:balady_plus/app/features/balady_calender/presentation/widgets/action_show_filter_widget.dart';
import 'package:balady_plus/app/features/balady_calender/presentation/widgets/action_show_type_date_widget.dart';
import 'package:balady_plus/app/features/balady_calender/presentation/widgets/balady_calendar_events_widget.dart';
import 'package:balady_plus/app/features/balady_calender/presentation/widgets/balady_calendar_years_list.dart';
import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
import 'package:balady_plus/app/features/home_page/home_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

class BaladyCalendarPage extends StatelessWidget {
  const BaladyCalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {
        EntryPointCubit auth = context.read<EntryPointCubit>();
        final selectedAgent = auth.state.selectedAgent;
        final selectedDelegator = auth.state.selectedDelegator;
        EventsCommonParams eventsCommonParams() {
          if (selectedAgent != null) {
            return EventsCommonParams(
              typeUser: UserType.agency,
              agencyInRequestDto: AgencyInRequestDto(
                agencyNumber: selectedAgent.agencyNumber!,
                ownerNumber: selectedAgent.ownerNumber!,
                ownerTypeId: selectedAgent.ownerTypeId!,
              ),
            );
          } else if (selectedDelegator != null) {
            return EventsCommonParams(
              typeUser: UserType.delegator,
              ownerNumber: selectedDelegator.crNumber,
              ownerTypeId: selectedDelegator.crType,
              unifiedNationalNumber: selectedDelegator.unifiedNationalNumber!,
              relationTypeeId: int.tryParse(selectedDelegator.relationTypeId),
            );
          } else {
            return EventsCommonParams(typeUser: UserType.owner);
          }
        }

        return BaladyCalendarYearsListViewModel(
            repository: sl(), params: eventsCommonParams());
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                // AppBar
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: CircleIcon(
                        icon: Icons.close,
                        iconColor: AppColor.primary600Light,
                        backgroundColor: AppColor.geyser.withOpacity(0.5),
                        iconSize: 15,
                        circleSize: 40,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      fit: FlexFit.tight,
                      child: Text(
                        "balady_calendar".tr(),
                        style: AppStyle.appBarTitleTextStyle.copyWith(
                            fontWeight: FontWeight.w900, fontSize: 16),
                      ),
                    ),
                    const ActionShowTypeDateWidget(),
                    const SizedBox(width: 4),
                    const ActionShowFilterWidget(),
                  ],
                ),
                const SizedBox(height: 20),
                const BaladyCalendarYearsList(),
                Expanded(
                  child: Selector<BaladyCalendarYearsListViewModel, bool>(
                    selector: (_, provider) => provider.isLoading,
                    builder: (contextYearsSelector, isLoading, child) {
                      // if Loading
                      if (isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      // if have error
                      String? t = contextYearsSelector
                          .watch<BaladyCalendarYearsListViewModel>()
                          .errorMessage;
                      if (contextYearsSelector
                              .watch<BaladyCalendarYearsListViewModel>()
                              .errorMessage !=
                          null) {
                        return Padding(
                          padding: const EdgeInsets.all(24),
                          child: Center(
                            child: Text(
                              contextYearsSelector
                                  .watch<BaladyCalendarYearsListViewModel>()
                                  .errorMessage!,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }

                      return Selector<BaladyCalendarYearsListViewModel,
                          EventsCountInYearsItem?>(
                        selector: (_, provider) => provider.selectedYear,
                        builder: (_, selectedYear, child) {
                          // if have errors
                          if (selectedYear == null) {
                            return const SizedBox();
                          }

                          // if have errors
                          if (selectedYear.eventsCount == 0) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    IconPath.noEvents,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text('no_events'.tr())
                                ],
                              ),
                            );
                          }

                          return BaladyCalendarEventsWidget(
                            key: Key(
                              DateTime.now().microsecondsSinceEpoch.toString(),
                            ),
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
