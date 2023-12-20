import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../_shared_feature_/presentation/components/bottom_sheets/generic_bottom_sheet_list.dart';
import '../../../data/models/establishment_size_response.dart';
import '../../bloc/violation_bloc.dart';
import '../../bloc/violation_state.dart';
import '../../pages/map/bloc/map_bloc.dart';

class ViolationEstabloshmentWidget extends StatelessWidget {
  const ViolationEstabloshmentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViolationBloc, ViolationState>(
        builder: (context, state) {
      return GestureDetector(
        onTap: () {
          BottomSheetDialog.showDraggableSheet(
            context,
            //  dialogKeyName: DialogName.reasonCancelDialog,
            // currentRouteName: RouteName.commercialLicenseApplyCancel,
            child: GenericBottomSheetList<EstablishmentSizeItem>(
              title: "establishment_size".tr(),
              items: state.establishmentSizeResponse?.result ?? [],
              selectedValue: state.selectedEstablishmentSizeItem,
              onTap: (item) {
                context.read<ViolationBloc>().selectEstablishment(item);
                Navigator.pop(context);
              },
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColor.grayLight,
            borderRadius: BorderRadius.circular(16),
          ),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextWidget(
                    "establishment_size".tr(),
                    textStyle: AppStyle.violationLocationAdressStyle,
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: CustomTextWidget(
                          state.selectedEstablishmentSizeItem
                                  ?.establishmentSizeName ??
                              "select".tr(),
                          textStyle: AppStyle.violationLocationMapStyle,
                          maxLines: 4,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const CustomSvgIconWidget(
              IconPath.arrowLeft,
            ),
          ]),
        ),
      );
    });
  }
}
