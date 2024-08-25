import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../features/_shared_feature_/presentation/components/bottom_sheets/generic_bottom_sheet_list.dart';
import '../../../../../../features/_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/drop_downs/drop_down_box_with_title.dart';
import '../../../data/models/qr/qr_lookup.dart';
import '../../../domain/entities/cr_lookups_entity.dart';
import '../bloc/cr_step2_activity_data_cubit.dart';

class AccomodationDropDownTypes extends StatelessWidget {
  const AccomodationDropDownTypes({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CrStep2ActivityDataCubit, CrStep2ActivityDataState>(
        builder: (context, state) {
      return DropDownWithTitle(
        title: "accomodation".tr(),
        selectedValue: state.selectedAccommodationType?.name,
        blocStatus: state.accommodationTypesStatus,
        onRetry: () {
          context.read<CrStep2ActivityDataCubit>().getAccommodationTypes();
        },
        onTap: () {
          // if (state.requestDetails?.usageDisable == true) return;
          BottomSheetDialog.showDraggableSheet(
            context,
            //  dialogKeyName: DialogName.reasonCancelDialog,
            // currentRouteName: CommercialRouteName.commercialLicenseApplyCancel,
            child: GenericBottomSheetList<CrLookupsEntity>(
              title: "accomodation".tr(),
              items: state.accommodationTypes ?? [],
              selectedValue: state.selectedAccommodationType,
              onTap: (item) {
                context
                    .read<CrStep2ActivityDataCubit>()
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
