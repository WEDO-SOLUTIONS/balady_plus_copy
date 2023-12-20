import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import '../../../../core/utils/app_analytics_events.dart';
import '../../../../core/utils/constants/dialog_names.dart';
import '../../../../core/utils/utils_exports.dart';
import '../../../_shared_feature_/shared_feature_exports.dart'
    show
        BottomSheetDialog,
        BottomSheetWithActions,
        DefaultAppBarWidget,
        FilterIcon;
import '../../objections_exports.dart'
    show
        AppBarSeachBar,
        GetRequestsEvent,
        ObjectableTransactionBloc,
        RequestsFilterActions,
        RequestsList,
        RequestsLoadLookupsEvent,
        ObjectableTransactionState,
        ResetRequestsFiltersEvent,
        SearchRequestsEvent;
import '../widgets/requests_filters_bottom_sheet.dart';

class ObjectableTransactionsPage extends StatefulWidget {
  const ObjectableTransactionsPage({super.key});

  @override
  State<ObjectableTransactionsPage> createState() =>
      _ObjectableTransactionsPageState();
}

class _ObjectableTransactionsPageState
    extends State<ObjectableTransactionsPage> {
  @override
  void initState() {
    super.initState();
    CommonFunctions.sendEventToAnalytics(AppEvents.objectable);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ObjectableTransactionBloc>(
      create: (context) => ObjectableTransactionBloc()..add(GetRequestsEvent()),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: DefaultAppBarWidget(
            title: "objectable_transactions".tr(),
            bottom: AppBarSeachBar(
              onChanged: (value) {
                context.read<ObjectableTransactionBloc>().add(
                      SearchRequestsEvent(query: value),
                    );
              },
            ),
            actions: [
              BlocBuilder<ObjectableTransactionBloc,
                  ObjectableTransactionState>(
                builder: (context, state) {
                  return FilterIcon(
                    onTap: () async {
                      context
                          .read<ObjectableTransactionBloc>()
                          .add(RequestsLoadLookupsEvent());
                      final sortType = state.sortType;
                      final selectedRequestStatus = state.selectedRequestStatus;

                      final selectedRequestType = state.selectedRequestType;
                      final selectedRequestSubType =
                          state.selectedRequestSubType;
                      final selectedRequestDate = state.selectedRequestDate;

                      final bool? actionTaked =
                          await BottomSheetDialog.showDraggableSheet(
                        context,
                        dialogKeyName: DialogName.objectablePageFilters,
                        currentRouteName: RouteName.objectableTransactions,
                        child: BottomSheetWithActions(
                          title: "filters".tr(),
                          body: RequestsFilterBottomSheet(
                            requestsBloc:
                                context.read<ObjectableTransactionBloc>(),
                          ),
                          action: RequestsFilterActions(
                            requestsBloc:
                                context.read<ObjectableTransactionBloc>(),
                          ),
                        ),
                      );
                      if (actionTaked != true && context.mounted) {
                        context.read<ObjectableTransactionBloc>().add(
                              ResetRequestsFiltersEvent(
                                  selectedSortType: sortType,
                                  selectedRequestStatus: selectedRequestStatus,
                                  selectedRequestType: selectedRequestType,
                                  selectedRequestSubType:
                                      selectedRequestSubType,
                                  selectedRequestDate: selectedRequestDate,
                                  dateForm: state.dateForm),
                            );
                      }
                    },
                  );
                },
              ),
            ],
          ),
          body: const Padding(
            padding: EdgeInsets.all(16),
            child: RequestsList(),
          ),
        );
      }),
    );
  }
}
