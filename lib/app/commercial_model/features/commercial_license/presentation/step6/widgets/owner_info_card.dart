import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'package:balady_plus/app/core/utils/utils_exports.dart';
import '../../../../../../features/_shared_feature_/shared_feature_exports.dart';
import '../../../data/models/qr/apply_commercial_response_model.dart';
import '../dialogs/edit_cr_owner_data_dialog.dart';

class OwnerInfoCard extends StatelessWidget {
  final CrOwner item;
  final int index;
  final Function(CrOwner item) onUpdate;
  const OwnerInfoCard(
      {super.key,
      required this.item,
      required this.onUpdate,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        color: AppColor.white,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const CustomSvgIconWidget(IconPath.clipboard),
                    const SizedBox(width: 4),
                    Flexible(
                      child: CustomTextWidget(
                        "${"owner_card".tr()} ${index + 1}",
                        fontColor: AppColor.blackModern600Light,
                        fontSize: 18,
                        fontWeight: AppFontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    if (!item.isCompleteData)
                      CustomTextWidget(
                        "بيانات غير مكتملة",
                        fontColor: Color(0xFFCD5D1A),
                        fontSize: 10,
                        fontWeight: AppFontWeight.bold,
                      )
                  ],
                ),
              ),
              CustomIconButtonWidget(
                icon: Icons.edit,
                iconColor: AppColor.primary900Light,
                onPressed: () async {
                  CrOwner updatedItem =
                      await BottomSheetDialog.showDraggableSheet(context,
                          isFullHeight: true,
                          //   dialogKeyName: DialogName.calculatorEditBoardDialog,
                          //  currentRouteName: CommercialRouteName.calculatorRoute,
                          child: BottomSheetWithActions(
                            title: "edit_owner_data".tr(),
                            body: EditCrOwnerDataDialog(
                              item: item,
                            ),
                          ));

                  onUpdate(updatedItem);
                },
              )
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextWidget(
                      "owner_name".tr(),
                      fontColor: AppColor.primary700Light,
                      fontSize: 10,
                      fontWeight: AppFontWeight.semiBold,
                    ),
                    const SizedBox(height: 8),
                    CustomTextWidget(
                      item.ownerName ?? "",
                      fontColor: AppColor.blackModern600Light,
                      fontSize: 12,
                      textAlign: TextAlign.start,
                      fontWeight: AppFontWeight.semiBold,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextWidget(
                      "phone_number".tr(),
                      fontColor: AppColor.primary700Light,
                      fontSize: 10,
                      fontWeight: AppFontWeight.semiBold,
                    ),
                    const SizedBox(height: 8),
                    CustomTextWidget(
                      item.ownerMobileNumber ?? "",
                      fontColor: AppColor.blackModern600Light,
                      fontSize: 12,
                      textAlign: TextAlign.start,
                      fontWeight: AppFontWeight.semiBold,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextWidget(
                      "id_number".tr(),
                      fontColor: AppColor.primary700Light,
                      fontSize: 10,
                      fontWeight: AppFontWeight.semiBold,
                    ),
                    SizedBox(height: 8),
                    CustomTextWidget(
                      item.identityNumber ?? "",
                      fontColor: AppColor.blackModern600Light,
                      fontSize: 12,
                      textAlign: TextAlign.start,
                      fontWeight: AppFontWeight.semiBold,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextWidget(
                      "email".tr(),
                      fontColor: AppColor.primary700Light,
                      fontSize: 10,
                      fontWeight: AppFontWeight.semiBold,
                    ),
                    SizedBox(height: 8),
                    CustomTextWidget(
                      item.ownerEmail ?? "",
                      fontColor: AppColor.blackModern600Light,
                      fontSize: 12,
                      textAlign: TextAlign.start,
                      fontWeight: AppFontWeight.semiBold,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
