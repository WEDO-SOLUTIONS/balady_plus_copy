import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'package:balady_plus/app/core/utils/utils_exports.dart';
import '../../../../../../features/_shared_feature_/shared_feature_exports.dart';
import '../../../domain/entities/commercial_board_type.dart';

class BillboardCard extends StatelessWidget {
  final CommercialBoardType type;
  final Function onDelete;

  const BillboardCard({super.key, required this.type, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        color: AppColor.primary50Light.withOpacity(0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextWidget(
                "BoardType".tr(),
                fontColor: AppColor.primary700Light,
                fontSize: 12,
                fontWeight: AppFontWeight.bold,
              ),
              CustomIconButtonWidget(
                icon: Icons.delete,
                iconColor: AppColor.redBrown,
                onPressed: () {
                  onDelete();
                },
              )
            ],
          ),
          SizedBox(height: 4),
          CustomTextWidget(
            type.name,
            fontColor: AppColor.blackModern600Light,
            fontSize: 16,
            fontWeight: AppFontWeight.semiBold,
          ),
          SizedBox(height: 16),
          CustomTextWidget(
            "lbl_painting_space".tr(),
            fontColor: AppColor.primary700Light,
            fontSize: 12,
            fontWeight: AppFontWeight.bold,
          ),
          SizedBox(height: 4),
          CustomTextWidget(
            "${type.area}  ${"m2".tr()}",
            fontColor: AppColor.blackModern600Light,
            fontSize: 16,
            fontWeight: AppFontWeight.semiBold,
          ),
        ],
      ),
    );
  }
}
