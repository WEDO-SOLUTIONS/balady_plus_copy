import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/calendar/presentation/bloc/calendar_state.dart';
import 'package:balady_plus/app/features/transaction_inquiry/presentation/pages/inquiry/transactions_inquiry/details_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/app_analytics_events.dart';
import '../../../../core/utils/constants/ux_cam_events.dart';
import '../../../_shared_feature_/presentation/components/bottom_sheets/bottom_sheet_with_actions.dart';
import '../../../_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import '../../../_shared_feature_/presentation/icons/filter_icon.dart';
import '../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../_shared_feature_/presentation/widgets/custom_shimmer_list_widget.dart';
import '../../../_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import '../../../_shared_feature_/presentation/widgets/reload_widget.dart';
import '../../../_shared_feature_/presentation/widgets/retry_widget.dart';
import '../../../events/presentation/pages/events_not_found_page.dart';
import '../../calendar_exports.dart'
    show SectionDate, SectionContainer, NationalDay;
import '../../domain/entities/search_calendar/search_calendar_params.dart';
import '../bloc/calendar_bloc.dart';
import '../bloc/calendar_event.dart';
import '../dialogs/calendar_filter_dialog.dart';
import '../widgets/calendar_item_widget.dart';
import '../widgets/calendar_not_found_page.dart';
import '../widgets/old_calendar_card.dart';

class MainPageCalendar extends StatefulWidget {
  const MainPageCalendar({super.key});

  @override
  State<MainPageCalendar> createState() => _MainPageCalendarState();
}

class _MainPageCalendarState extends State<MainPageCalendar> {
  @override
  void initState() {
    super.initState();

    CommonFunctions.sendEventToAnalytics(AppEvents.calendar);
    CommonFunctions.sendUXCamEvent(UXCamEvents.startServiceKingdomCalendar);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CalendarBloc()..add(GetSearchEvent()),
      child: BlocBuilder<CalendarBloc, CalendarState>(
        builder: (context, state) {
          return Scaffold(
            appBar: DefaultAppBarWidget(
              title: "saudi_calendar".tr(),
              showBack: true,
              actions: [
                FilterIcon(onTap: () async {
                  context.read<CalendarBloc>().add(GetSeasonsEvent());

                  final SearchCalendarParams? params =
                      await BottomSheetDialog.showDraggableSheet(
                    context,
                    //  dialogKeyName: DialogName.violationsFilterDialog,
                    //  currentRouteName: RouteName.violationsPage,
                    child: BottomSheetWithActions(
                      title: "filters".tr(),
                      body: CalendarFilterDialog(
                        requestsBloc: context.read<CalendarBloc>(),
                        params: state.searchedParams,
                      ),
                    ),
                  );
                  print("keyword ${params}");

                  print("keyword ${params?.keyword}");

                  if (context.mounted) {
                    context
                        .read<CalendarBloc>()
                        .add(GetSearchEvent(params: params));
                  }
                })
              ],
            ),
            body: CalendarBody(),
          );
        },
      ),
    );
  }
}

class CalendarBody extends StatefulWidget {
  const CalendarBody({
    super.key,
  });

  @override
  State<CalendarBody> createState() => _CalendarBodyState();
}

class _CalendarBodyState extends State<CalendarBody> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      print("scroll");
      context.read<CalendarBloc>().add(GetMoreSearchEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (context, state) {
        if (state.status == BlocStatus.loading)
          return CustomShimmerListWidget(
            height: 189,
            itemCount: 10,
          );
        if (state.status == BlocStatus.success && state.searchItems.isEmpty)
          return CalendarNotFoundPage();

        if (state.status == BlocStatus.retry)
          return ReloadWidget(
            onTab: () {
              context.read<CalendarBloc>().add(GetSearchEvent(
                  update: false,
                  params: state.searchedParams.copyWith(
                      page: 1,
                      size: ((state.searchedParams.page ?? 1) - 1) *
                          (state.searchedParams.size ?? 10))));
            },
          );

        return RefreshIndicator(
          onRefresh: () async {
            context.read<CalendarBloc>().add(GetSearchEvent(
                update: false,
                params: state.searchedParams.copyWith(
                    page: 1,
                    size: ((state.searchedParams.page ?? 1) - 1) *
                        (state.searchedParams.size ?? 10))));
          },
          child: ListView.builder(
            controller: _scrollController,
            itemCount: state.searchItems.length + 1,
            itemBuilder: (context, index) {
              if (index >= (state.searchItems.length)) {
                if (state.status == BlocStatus.loadMore) {
                  return const SizedBox(
                    height: 50,
                    child: Center(child: CustomCircularLoadingWidget()),
                  );
                } else {
                  return Container(height: 50);
                }
              }
              return Column(
                children: [
                  /* SectionDate(
                    month: state.searchItems[index].getStartDay(),
                    year: state.searchItems[index].startDate?.year.toString() ??
                        "",
                  ),
                  CalendarItemWidget(
                    item: state.searchItems[index],
                    onPress: () {
                      Navigator.of(context).pushNamed(
                          RouteName.calendarDetailsPage,
                          arguments: state.searchItems[index]);
                    },
                  ),*/
                  OldCalendarCard(
                    item: state.searchItems[index],
                  )
                ],
              );
            },
          ),
        );
      },
    );
  }
}
