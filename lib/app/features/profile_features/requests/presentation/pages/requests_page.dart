import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show
        BottomSheetDialog,
        BottomSheetWithActions,
        DefaultAppBarWidget,
        FilterIcon;
import '../../requests_exports.dart'
    show
        AppBarSeachBar,
        GetRequestsEvent,
        RequestsBloc,
        RequestsFilterActions,
        RequestsList,
        RequestsLoadLookupsEvent,
        RequestsState,
        ResetRequestsFiltersEvent,
        SearchRequestsEvent;
import '../widgets/requests_filters_bottom_sheet.dart';

class RequestsPage extends StatelessWidget {
  const RequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RequestsBloc>(
      create: (context) => sl<RequestsBloc>()..add(GetRequestsEvent()),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: DefaultAppBarWidget(
            title: 'requests'.tr(),
            bottom: AppBarSeachBar(
              onChanged: (value) {
                context.read<RequestsBloc>().add(
                      SearchRequestsEvent(query: value),
                    );
              },
            ),
            actions: [
              BlocBuilder<RequestsBloc, RequestsState>(
                builder: (context, state) {
                  return FilterIcon(
                    onTap: () async {
                      context
                          .read<RequestsBloc>()
                          .add(RequestsLoadLookupsEvent());
                      final sortType = state.sortType;
                      final selectedRequestStatus = state.selectedRequestStatus;
                      final selectedMunicipality = state.selectedMunicipality;
                      final selectedSubMunicipality =
                          state.selectedSubMunicipality;
                      final selectedRequestType = state.selectedRequestType;
                      final selectedRequestSubType =
                          state.selectedRequestSubType;
                      final selectedRequestDate = state.selectedRequestDate;

                      final bool? actionTaked =
                          await BottomSheetDialog.showDraggableSheet(
                        context,
                        child: BottomSheetWithActions(
                          title: "filters".tr(),
                          body: RequestsFilterBottomSheet(
                            requestsBloc: context.read<RequestsBloc>(),
                          ),
                          action: RequestsFilterActions(
                            requestsBloc: context.read<RequestsBloc>(),
                          ),
                        ),
                      );
                      if (actionTaked != true && context.mounted) {
                        context.read<RequestsBloc>().add(
                              ResetRequestsFiltersEvent(
                                selectedSortType: sortType,
                                selectedRequestStatus: selectedRequestStatus,
                                selectedMunicipality: selectedMunicipality,
                                selectedSubMunicipality:
                                    selectedSubMunicipality,
                                selectedRequestType: selectedRequestType,
                                selectedRequestSubType: selectedRequestSubType,
                                selectedRequestDate: selectedRequestDate,
                              ),
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
