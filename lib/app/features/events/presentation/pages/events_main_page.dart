import 'package:balady_plus/app/core/utils/constants/analytics_events.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import 'package:balady_plus/app/features/events/presentation/bloc/events_bloc.dart';
import 'package:balady_plus/app/features/events/presentation/dialogs/events_filter_dialog.dart';
import 'package:balady_plus/app/features/events/presentation/widgets/events_main_page_widgets/events_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/app_analytics_events.dart';
import '../../../_shared_feature_/presentation/components/bottom_sheets/bottom_sheet_with_actions.dart';
import '../../../_shared_feature_/presentation/icons/filter_icon.dart';
import '../../domain/entities/search_events/search_events_params.dart';
import '../bloc/events_event.dart';
import '../bloc/events_state.dart';

class EventsMainPage extends StatefulWidget {
  const EventsMainPage({super.key});

  @override
  State<EventsMainPage> createState() => _EventsMainPageState();
}

class _EventsMainPageState extends State<EventsMainPage> {
  @override
  void initState() {
    super.initState();

    CommonFunctions.sendEventToAnalytics(AppEvents.events);
    CommonFunctions.sendAnalyticsEvent(AnalyticsEvents.startServiceEvents);

    CommonFunctions.sendAnalyticsEvent(AnalyticsEvents.Events_Open_List_Event);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventsBloc()..add(const GetSearchEvent()),
      child: BlocListener<EventsBloc, EventsState>(
        listener: (context, state) {
          if (state.status == BlocStatus.failure || state.status == BlocStatus.retry) {
            CommonFunctions.showError(state.errorMessage ?? "");
          }
        },
        child: Scaffold(
          appBar: DefaultAppBarWidget(
            title: 'events_main_title_page'.tr(),
            actions: [
              BlocBuilder<EventsBloc, EventsState>(
                builder: (context, state) {
                  return FilterIcon(
                    onTap: () async {
                      context.read<EventsBloc>().add(GetCategoriesEvent());
                      context.read<EventsBloc>().add(GetAudienceEvent());
                      context.read<EventsBloc>().add(GetCitiesEvent());
                      context.read<EventsBloc>().add(GetSeasonsEvent());
                      context.read<EventsBloc>().add(GetFeesEvent());

                      /*   final sortType = state.sortType;
                          final selectedRequestStatus = state.selectedViolationStatus;
      
                          final selectedRequestType = state.selectedInvoiceStatus;
      */
                      final SearchEventsParams? params = await BottomSheetDialog.showDraggableSheet(
                        context,
                        //  dialogKeyName: DialogName.violationsFilterDialog,
                        //  currentRouteName: RouteName.violationsPage,
                        child: BottomSheetWithActions(
                          title: "filters".tr(),
                          body: EventsFilterDialog(
                            requestsBloc: context.read<EventsBloc>(),
                            params: state.searchedParams,
                          ),
                        ),
                      );

                      if (context.mounted) {
                        context.read<EventsBloc>().add(GetSearchEvent(params: params));
                        /*   context.read<EventsBloc>().add(
                                  ResetViolationsFiltersEvent(
                                      selectedSortType: sortType,
                                      selectedRequestStatus: selectedRequestStatus,
                                      selectedRequestType: selectedRequestType,
                                      dateForm: state.lastDateForm),
                                );*/
                      }
                    },
                  );
                },
              ),
            ],
          ),
          body: EventsSectionWidget(),
        ),
      ),
    );
  }
}
