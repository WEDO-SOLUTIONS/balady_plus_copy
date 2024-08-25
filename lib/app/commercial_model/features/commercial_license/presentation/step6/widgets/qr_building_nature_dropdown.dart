import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../features/_shared_feature_/presentation/components/bottom_sheets/generic_bottom_sheet_list.dart';
import '../../../../../../features/_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/drop_downs/drop_down_box_with_title.dart';
import '../../../data/models/qr/qr_lookup.dart';
import '../bloc/cr_step6_establishment_data_cubit.dart';

class QrBuildingNatureDropDown extends StatelessWidget {
  const QrBuildingNatureDropDown({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CRStep6EstablishmentCubit, CRStep6EstablishmentState>(
        builder: (context, state) {
      return DropDownWithTitle(
        title: "BuildingNature".tr(),
        selectedValue: state.selectedBuildingNature?.name,
        blocStatus: state.buildingNatureStatus,
        onRetry: () {
          context.read<CRStep6EstablishmentCubit>().getBuildingNature();
        },
        onTap: () {
          // if (state.requestDetails?.usageDisable == true) return;
          BottomSheetDialog.showDraggableSheet(
            context,
            //  dialogKeyName: DialogName.reasonCancelDialog,
            // currentRouteName: CommercialRouteName.commercialLicenseApplyCancel,
            child: GenericBottomSheetList<QrLookUpItem>(
              title: "BuildingNature".tr(),
              items: state.buildingNature ?? [],
              selectedValue: state.selectedBuildingNature,
              onTap: (item) {
                context
                    .read<CRStep6EstablishmentCubit>()
                    .updateBuildingNature(item);
                Navigator.pop(context);
              },
            ),
          );
        },
      );
    });
  }
}
