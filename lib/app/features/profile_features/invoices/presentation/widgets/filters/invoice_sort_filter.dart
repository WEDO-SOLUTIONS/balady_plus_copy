import 'package:balady_plus/app/core/utils/enums/sort_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/constants/dialog_names.dart';
import '../../../../../../core/utils/constants/route_names.dart';
import '../../../../../_shared_feature_/shared_feature_exports.dart'
    show BottomSheetDialog, BottomSheetList, DropDownWithTitle;
import '../../../invoices_exports.dart'
    show InvoicesBloc, InvoicesSortChangedEvent, InvoicesState;

class InvoicesSortFilter extends StatelessWidget {
  const InvoicesSortFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvoicesBloc, InvoicesState>(
      buildWhen: (previous, current) => previous.sortType != current.sortType,
      builder: (context, state) {
        return DropDownWithTitle(
          title: "sort".tr(),
          selectedValue: state.sortType.value.tr(),
          onTap: () {
            final List<String> items =
                SortType.values.map((e) => e.value.tr()).toList();
            BottomSheetDialog.showDraggableSheet(
              context,
              dialogKeyName: DialogName.invoicesSortFilters,
              currentRouteName: RouteName.invoices,
              child: BottomSheetList(
                title: "sort".tr(),
                items: items,
                selectedValue: state.sortType.value.tr(),
                onTap: (item) {
                  final slectedSort =
                      SortType.values.where((e) => e.value.tr() == item).first;
                  context.read<InvoicesBloc>().add(
                        InvoicesSortChangedEvent(
                          sortType: slectedSort,
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
