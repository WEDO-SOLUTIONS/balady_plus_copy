import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/constants/dialog_names.dart';
import '../../../../../../core/utils/constants/route_names.dart';
import '../../../../../_shared_feature_/shared_feature_exports.dart'
    show BottomSheetDialog, BottomSheetList, DropDownWithTitle;
import '../../../requests_exports.dart'
    show
        GetMunicipalitiesEvent,
        MunicipalitySelectedEvent,
        RequestsBloc,
        RequestsState;

class RequestsMunicipalityFilter extends StatelessWidget {
  const RequestsMunicipalityFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestsBloc, RequestsState>(
      buildWhen: (previous, current) =>
          previous.municipalitiesStatus != current.municipalitiesStatus ||
          previous.selectedMunicipality != current.selectedMunicipality,
      builder: (context, state) {
        return DropDownWithTitle(
          title: "municipality".tr(),
          selectedValue: state.selectedMunicipality?.name,
          status: state.municipalitiesStatus,
          onRetry: () => context.read<RequestsBloc>().add(
                GetMunicipalitiesEvent(),
              ),
          onTap: () {
            final List<String> items =
                state.municipalities.map((e) => e.name).toList();
            BottomSheetDialog.showDraggableSheet(
              context,
              dialogKeyName: DialogName.requestsMunicipalityFilterDialog,
              currentRouteName: RouteName.requests,
              child: BottomSheetList(
                title: "municipality".tr(),
                items: items,
                selectedValue: state.selectedMunicipality?.name,
                onTap: (item) {
                  final selectedItem =
                      state.municipalities.where((e) => e.name == item).first;
                  context.read<RequestsBloc>().add(
                        MunicipalitySelectedEvent(
                          municipality: selectedItem,
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
