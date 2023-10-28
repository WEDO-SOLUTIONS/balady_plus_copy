import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../data/models/qr/apply_commercial_response_model.dart';

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
              const CustomSvgIconWidget(IconPath.clipboard),
              const SizedBox(width: 4),
              Flexible(
                child: CustomTextWidget(
                  "مالك $index",
                  fontColor: AppColor.blackModern600Light,
                  fontSize: 18,
                  fontWeight: AppFontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomTextWidget(
                      "اسم المالك",
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
                    const CustomTextWidget(
                      "رقم الجوال",
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
                      "رقم الهويه",
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
                      "البربد الالكتروني",
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
