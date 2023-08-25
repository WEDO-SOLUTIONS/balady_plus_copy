import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/constants/dialog_names.dart';
import '../../../../../../core/utils/utils_exports.dart';
import '../../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../municipal_advisor_exports.dart';

class AttachmentsSelector extends StatelessWidget {
  const AttachmentsSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MunicipalAdvisorBloc, MunicipalAdvisorState>(
      builder: (context, state) {
        final hasBrand = state.hasBrand == null
            ? null
            : state.hasBrand!
                ? 'yes'.tr()
                : 'no'.tr();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            CustomTextWidget(
              'FillFields'.tr(),
              textStyle: AppStyle.subMessageTextStle,
            ),
            const SizedBox(height: 8),
            const CleaningSelector(
              calculateFees: false,
            ),
            const Divider(thickness: 1),
            const SizedBox(height: 8),
            CustomTextWidget(
              'municipalAdvisorBrand'.tr(),
              textStyle: AppStyle.dropDownTitleTextStyle,
            ),
            const SizedBox(height: 8),
            ChatBubbleRadioSelector(
              items: [
                'yes'.tr(),
                'no'.tr(),
              ],
              initialSelectedValue: hasBrand,
              onSelect: (value) {
                context.read<MunicipalAdvisorBloc>().add(
                      MunicipalAdvisorSelectHasBrandEvent(
                        hasBrand: value == 'yes'.tr(),
                      ),
                    );
              },
            ),
            const Divider(thickness: 1),
            const SizedBox(height: 8),
            CustomTextWidget(
              'municipalAdvisorOwnershipProof'.tr(),
              textStyle: AppStyle.dropDownTitleTextStyle,
            ),
            const SizedBox(height: 4),
            CustomTextWidget(
              'FillFields'.tr(),
              textStyle: AppStyle.subMessageTextStle,
            ),
            const SizedBox(height: 8),
            DropDownWithTitle(
              title: "municipalAdvisorOwnershipProofType".tr(),
              selectedValue: state.selectedShopOwnership?.contractTypeName,
              onTap: () {
                final List<String> items = state.shopOwnerships
                    .map((e) => e.contractTypeName)
                    .toList()
                    .cast<String>();
                BottomSheetDialog.showDraggableSheet(
                  context,
                  dialogKeyName: DialogName.municipalOwnerShipDialog,
                  currentRouteName: RouteName.municipalAdvisor,
                  child: BottomSheetList(
                    title: "municipalAdvisorOwnershipProofType".tr(),
                    items: items,
                    selectedValue:
                        state.selectedShopOwnership?.contractTypeName,
                    onTap: (item) {
                      final selectedOwnerShip = state.shopOwnerships
                          .firstWhere((e) => e.contractTypeName == item);
                      context.read<MunicipalAdvisorBloc>().add(
                            MunicipalAdvisorSelectShopOwnershipEvent(
                              shopOwnership: selectedOwnerShip,
                            ),
                          );
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            DropDownWithTitle(
              title: "municipalAdvisorContractType".tr(),
              selectedValue: state.selectedShopContractOption?.name,
              onTap: () {
                final List<String> items =
                    (state.selectedShopOwnership?.contractOptions ?? [])
                        .map((e) => e.name)
                        .toList()
                        .cast<String>();
                BottomSheetDialog.showDraggableSheet(
                  context,
                  dialogKeyName: DialogName.municipalContractDialog,
                  currentRouteName: RouteName.municipalAdvisor,
                  child: BottomSheetList(
                    title: "municipalAdvisorContractType".tr(),
                    items: items,
                    selectedValue: state.selectedShopContractOption?.name,
                    onTap: (item) {
                      final selectedContractOption = state
                          .selectedShopOwnership?.contractOptions
                          .firstWhere((e) => e.name == item);
                      if (selectedContractOption != null) {
                        context.read<MunicipalAdvisorBloc>().add(
                              MunicipalAdvisorSelectShopContractOptionEvent(
                                shopContractOption: selectedContractOption,
                              ),
                            );
                      }
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            const Divider(thickness: 1),
            const SizedBox(height: 16),
            ElevatedButtonWidget.finishButton(
              onPressed: state.attachmentsFinishEnabled
                  ? () {
                      context.read<MunicipalAdvisorBloc>().add(
                            MunicipalAdvisorGetConsultationAttachmentsEvent(),
                          );
                    }
                  : null,
            )
          ],
        );
      },
    );
  }
}
