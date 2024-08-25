import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../features/_shared_feature_/presentation/components/bottom_sheets/generic_bottom_sheet_list.dart';
import '../../../../../../features/_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/drop_downs/drop_down_box_with_title.dart';
import '../../../data/models/qr/qr_lookup.dart';
import '../bloc/cr_step4_shop_data_cubit.dart';

class MallsDropDown extends StatelessWidget {
  const MallsDropDown({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CrStep4ShopDataCubit, CrStep4ShopDataState>(
        builder: (context, state) {
      return DropDownWithTitle(
        title: "step4label7".tr(),
        selectedValue: state.selectedMall?.name,
        blocStatus: state.mallsStatus,
        onRetry: () {
          context.read<CrStep4ShopDataCubit>().getMalls();
        },
        onTap: () {
          // if (state.requestDetails?.usageDisable == true) return;
          BottomSheetDialog.showDraggableSheet(
            context,
            //  dialogKeyName: DialogName.reasonCancelDialog,
            // currentRouteName: CommercialRouteName.commercialLicenseApplyCancel,
            child: GenericBottomSheetList<QrLookUpItem>(
              title: "step4label7".tr(),
              items: state.mallsList ?? [],
              noDataMsg: "no_malls_available".tr(),
              selectedValue: state.selectedMall,
              onTap: (item) {
                context.read<CrStep4ShopDataCubit>().updateMall(item);
                Navigator.pop(context);
              },
            ),
          );
        },
      );
    });
  }
}
