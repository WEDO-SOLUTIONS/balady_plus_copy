import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../domain/entities/commercial_board_type.dart';

class BillboardCard extends StatelessWidget {
  final CommercialBoardType type;
  const BillboardCard({super.key, required this.type});

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
          CustomTextWidget(
            "نوع اللوحة",
            fontColor: AppColor.primary700Light,
            fontSize: 12,
            fontWeight: AppFontWeight.bold,
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
            "مساحة اللوحة",
            fontColor: AppColor.primary700Light,
            fontSize: 12,
            fontWeight: AppFontWeight.bold,
          ),
          SizedBox(height: 4),
          CustomTextWidget(
            "${type.area} متر مربع",
            fontColor: AppColor.blackModern600Light,
            fontSize: 16,
            fontWeight: AppFontWeight.semiBold,
          ),
        ],
      ),
    );
  }
}
