import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../../features/_shared_feature_/presentation/components/bottom_sheets/generic_bottom_sheet_list.dart';
import '../../../../../../../features/_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/drop_downs/drop_down_box_with_title.dart';
import '../../../../data/models/permit_poster_types_response.dart';
import '../../../blocs/posters_license_bloc.dart';

class PosterDropDown extends StatelessWidget {
  final PermitPosterTypeItem? item;
  final Function(PermitPosterTypeItem) onSelect;
  const PosterDropDown({super.key, this.item, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostersLicenseBloc, PostersLicenseState>(
        builder: (context, state) {
      return DropDownWithTitle(
        title: "poster_type".tr(),
        selectedValue: item?.name,
        blocStatus: state.posterTypesStatus,
        onRetry: () {
          context.read<PostersLicenseBloc>().add(const GetPosterTypesEvent());
        },
        onTap: () {
          // if (state.requestDetails?.usageDisable == true) return;
          BottomSheetDialog.showDraggableSheet(
            context,
            //  dialogKeyName: DialogName.reasonCancelDialog,
            // currentRouteName: CommercialRouteName.commercialLicenseApplyCancel,
            child: GenericBottomSheetList<PermitPosterTypeItem>(
              title: "poster_type".tr(),
              items: state.posterTypes ?? [],
              selectedValue: item,
              onTap: (item) {
                onSelect(item);
                Navigator.pop(context, item);
              },
            ),
          );
        },
      );
    });
  }
}
