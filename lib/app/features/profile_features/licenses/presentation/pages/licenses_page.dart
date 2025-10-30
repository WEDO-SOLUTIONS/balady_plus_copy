import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import '../../../../../core/utils/app_analytics_events.dart';
import '../../../../../core/utils/common_functions.dart';
import '../../../../../core/utils/constants/dialog_names.dart';
import '../../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show
        BottomSheetDialog,
        BottomSheetWithActions,
        DefaultAppBarWidget,
        FilterIcon;
import '../../../requests/requests_exports.dart' show AppBarSeachBar;
import '../../licenses_exports.dart'
    show
        GetLicensesEvent,
        LicensesBloc,
        LicensesFilterActions,
        LicensesFilterBottomSheet,
        LicensesList,
        LicensesLoadLookupsEvent,
        LicensesState,
        ResetLicensesFiltersEvent,
        SearchLicensesEvent;

class LicensesPage extends StatefulWidget {
  const LicensesPage({super.key});

  @override
  State<LicensesPage> createState() => _LicensesPageState();
}

class _LicensesPageState extends State<LicensesPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CommonFunctions.sendEventToAnalytics(AppEvents.Licenses);

    CommonFunctions.sendUXCamEvent(UXCamEvents.openLicensesList);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LicensesBloc>(
      create: (context) => sl<LicensesBloc>()..add(GetLicensesEvent()),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: DefaultAppBarWidget(
            title: 'licenses'.tr(),
            bottom: AppBarSeachBar(
              onChanged: (value) {
                context.read<LicensesBloc>().add(
                      SearchLicensesEvent(
                        query: value,
                      ),
                    );
              },
            ),
            actions: [
              BlocBuilder<LicensesBloc, LicensesState>(
                builder: (context, state) {
                  return FilterIcon(
                    onTap: () async {
                      final sortType = state.sortType;
                      final selectedLicenseStatus = state.selectedLicenseStatus;
                      final selectedMunicipality = state.selectedMunicipality;
                      final selectedSubMunicipality =
                          state.selectedSubMunicipality;
                      final selectedLicenseType = state.selectedLicenseType;

                      final selectedLicenseDate = state.selectedLicenseEndDate;

                      context
                          .read<LicensesBloc>()
                          .add(LicensesLoadLookupsEvent());
                      final bool? actionTaked =
                          await BottomSheetDialog.showDraggableSheet(
                        context,
                        dialogKeyName: DialogName.licensesPageFilters,
                        currentRouteName: RouteName.licenses,
                        child: BottomSheetWithActions(
                          title: "filters".tr(),
                          body: LicensesFilterBottomSheet(
                            licensesBloc: context.read<LicensesBloc>(),
                          ),
                          action: LicensesFilterActions(
                            licensesBloc: context.read<LicensesBloc>(),
                          ),
                        ),
                      );
                      if (actionTaked != true && context.mounted) {
                        context.read<LicensesBloc>().add(
                              ResetLicensesFiltersEvent(
                                selectedSortType: sortType,
                                selectedLicenseStatus: selectedLicenseStatus,
                                selectedMunicipality: selectedMunicipality,
                                selectedSubMunicipality:
                                    selectedSubMunicipality,
                                selectedLicenseType: selectedLicenseType,
                                selectedLicenseDate: selectedLicenseDate,
                              ),
                            );
                      }

                      CommonFunctions.sendUXCamEvent(
                          UXCamEvents.openLicensesFilter);
                    },
                  );
                },
              ),
            ],
          ),
          body: const Padding(
            padding: EdgeInsets.all(16),
            child: LicensesList(),
          ),
        );
      }),
    );
  }
}
