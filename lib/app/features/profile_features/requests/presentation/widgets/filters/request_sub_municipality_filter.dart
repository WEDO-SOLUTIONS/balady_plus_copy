import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/constants/dialog_names.dart';
import '../../../../../../core/utils/constants/route_names.dart';
import '../../../../../_shared_feature_/shared_feature_exports.dart'
    show BottomSheetDialog, BottomSheetList, DropDownWithTitle, MessageDialog;
import '../../../requests_exports.dart'
    show
        GetSubMunicipalitiesEvent,
        RequestsBloc,
        RequestsState,
        SubMunicipalitySelectedEvent;

class RequestsSubMunicipalityFilter extends StatelessWidget {
  const RequestsSubMunicipalityFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestsBloc, RequestsState>(
      buildWhen: (previous, current) =>
          previous.subMunicipalitiesStatus != current.subMunicipalitiesStatus ||
          previous.selectedSubMunicipality != current.selectedSubMunicipality ||
          previous.selectedMunicipality != current.selectedMunicipality,
      builder: (context, state) {
        return DropDownWithTitle(
          title: "sub_municipality".tr(),
          selectedValue: state.selectedSubMunicipality?.name,
          status: state.subMunicipalitiesStatus,
          onRetry: () {
            final selectedMunicipality = state.selectedMunicipality;
            if (selectedMunicipality != null) {
              context.read<RequestsBloc>().add(
                    GetSubMunicipalitiesEvent(
                      municipality: selectedMunicipality,
                    ),
                  );
            }
          },
          onTap: () {
            if (state.selectedMunicipality == null) {
              MessageDialog.showErrorNotification(
                msg: '${"choose".tr()} ${"municipality".tr()} ${"first".tr()}',
              );
              return;
            }
            final List<String> items =
                state.subMunicipalities.map((e) => e.name).toList();
            BottomSheetDialog.showDraggableSheet(
              context,
              dialogKeyName: DialogName.requestsSubMunicapilityFilterDialog,
              currentRouteName: RouteName.requests,
              child: BottomSheetList(
                title: "sub_municipality".tr(),
                items: items,
                selectedValue: state.selectedSubMunicipality?.name,
                onTap: (item) {
                  final selectedItem = state.subMunicipalities
                      .where((e) => e.name == item)
                      .first;
                  context.read<RequestsBloc>().add(
                        SubMunicipalitySelectedEvent(
                          subMunicipality: selectedItem,
                        ),
                      );
                  Navigator.pop(context);
                },
              ),
            );
          },
        );
      },
    );
  }
}
