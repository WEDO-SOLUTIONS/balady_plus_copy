import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../_shared_feature_/presentation/components/bottom_sheets/generic_bottom_sheet_list.dart';
import '../../../../../_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import '../../../../../_shared_feature_/presentation/widgets/drop_downs/drop_down_box_with_title.dart';
import '../../../../renew_commercial_license_exports.dart'
    show
        GetRenewYearsEvent,
        RenewCommercialLicenseBloc,
        RenewCommercialLicenseState;

class CommercialRenewStep1 extends StatelessWidget {
  const CommercialRenewStep1({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<RenewCommercialLicenseBloc, RenewCommercialLicenseState>(
          builder: (context, state) {
            return DropDownWithTitle(
              title: "events_filter_city".tr(),
              selectedValue: state.licensePeriod.toString(),
              status: state.renewYearsStatus,
              onRetry: () => context.read<RenewCommercialLicenseBloc>().add(
                    GetRenewYearsEvent(),
                  ),
              onTap: () {
                BottomSheetDialog.showDraggableSheet<int>(
                  context,
                  // dialogKeyName: DialogName.objectablePageProductsFilters,
                  // currentRouteName: RouteName.objectableTransactions,
                  child: GenericBottomSheetList<int>(
                    title: "events_filter_city".tr(),
                    items: state.renewYears ?? [],
                    selectedValue: state.licensePeriod,
                    onTap: (item) {
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
