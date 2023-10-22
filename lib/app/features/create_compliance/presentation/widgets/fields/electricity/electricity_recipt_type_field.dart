import 'package:balady_plus/app/core/utils/extensions/date_time_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/constants/dialog_names.dart';
import '../../../../../../core/utils/enums/date_form.dart';
import '../../../../../_shared_feature_/presentation/components/bottom_sheets/generic_bottom_sheet_list.dart';
import '../../../../../_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import '../../../../../_shared_feature_/presentation/widgets/drop_downs/drop_down_box_with_title.dart';
import '../../../../domain/entities/ownership_doc_type_response.dart';
import '../../../bloc/compliance_bloc.dart';
import '../../../bloc/compliance_event.dart';
import '../../../bloc/compliance_state.dart';
import '../../compliance_date_picker.dart';

class ElectricityReciptTypeField extends StatelessWidget {
  const ElectricityReciptTypeField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComplianceBloc, ComplianceState>(
        builder: (context, state) {
      return DropDownWithTitle(
          title: "compliance_electricity_type".tr(),
          selectedValue: state.selectedReciptType?.name,
          status: state.reciptTypesStatus,
          onRetry: () {
            context.read<ComplianceBloc>().add(
                  const GetReciptTypesEvent(),
                );
          },
          onTap: () {
            BottomSheetDialog.showDraggableSheet(
              context,
              //  dialogKeyName: DialogName.complianceSubUsagesDialog,
              //   currentRouteName: RouteName.submitCompliancePage,
              child: GenericBottomSheetList<ComplinaceLookUpItem>(
                title: "compliance_electricity_type".tr(),
                items: state.reciptLists?.items ?? [],
                selectedValue: state.selectedReciptType,
                onTap: (item) {
                  context.read<ComplianceBloc>().add(
                        UpdateFieldsEvent(
                          selectedReciptType: item,
                        ),
                      );
                  Navigator.pop(context);
                },
              ),
            );
          });
    });
  }
}
