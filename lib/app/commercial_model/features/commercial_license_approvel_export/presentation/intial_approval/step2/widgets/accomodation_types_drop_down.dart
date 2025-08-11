import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/data/models/lookups_model.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../../../../features/_shared_feature_/presentation/components/bottom_sheets/generic_bottom_sheet_list.dart';
import '../../../../../../../features/_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/drop_downs/drop_down_box_with_title.dart';
import '../bloc/step2_activity_data_export_cubit.dart';

class AccomodationDropDownTypes extends StatelessWidget {
  const AccomodationDropDownTypes({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Step2ActivityDataExportCubit, Step2ActivityDataExportState>(
        builder: (context, state) {
      return DropDownWithTitle(
        title: "accomodation".tr(),
        selectedValue: state.selectedAccommodationType?.name,
        blocStatus: state.accommodationTypesStatus,
        onRetry: () {
          context.read<Step2ActivityDataExportCubit>().getAccommodationTypes();
        },
        onTap: () {
          // if (state.requestDetails?.usageDisable == true) return;
          BottomSheetDialog.showDraggableSheet(
            context,
            //  dialogKeyName: DialogName.reasonCancelDialog,
            // currentRouteName: CommercialRouteName.commercialLicenseApplyCancel,
            child: GenericBottomSheetList<LookupsModel>(
              title: "accomodation".tr(),
              items: state.accommodationTypes ?? [],
              selectedValue: state.selectedAccommodationType,
              onTap: (item) {
                context
                    .read<Step2ActivityDataExportCubit>()
                    .onAccommodationTypes(item);
                Navigator.pop(context);
              },
            ),
          );
        },
      );
    });
  }
}
