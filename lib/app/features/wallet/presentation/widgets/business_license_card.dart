import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/utils_exports.dart';
import '../../../_shared_feature_/shared_feature_exports.dart';

class BusinessLicenseCard extends StatelessWidget {
  const BusinessLicenseCard({
    super.key,
    required this.bgImagePath,
    required this.cardNumber,
    required this.expireDate,
    required this.creationDate,
    required this.holderName,
    required this.title,
    required this.onPressed,
  });

  final String title;
  final String bgImagePath;
  final String cardNumber;
  final String expireDate;
  final String creationDate;
  final String holderName;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 206,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 26),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(14)),
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage(bgImagePath),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CustomSvgIconWidget(IconPath.shoppingBag),
                    const SizedBox(width: 4),
                    CustomTextWidget(
                      title,
                      fontSize: 12,
                      fontWeight: AppFontWeight.bold,
                      fontColor: AppColor.blackModern50Light,
                    ),
                  ],
                ),
                CustomTextWidget(
                  "${"createdAt".tr()} $creationDate",
                  fontSize: 10,
                  fontWeight: AppFontWeight.bold,
                  fontColor: AppColor.blackModern50Light,
                ),
              ],
            ),
            CustomTextWidget(
              cardNumber,
              fontSize: 22,
              fontWeight: AppFontWeight.bold,
              fontColor: AppColor.blackModern50Light,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextWidget(
                      "name".tr(),
                      fontSize: 11,
                      fontWeight: AppFontWeight.bold,
                      fontColor: AppColor.blackModern50Light.withOpacity(0.5),
                    ),
                    const SizedBox(height: 4),
                    CustomTextWidget(
                      holderName,
                      fontSize: 13,
                      fontWeight: AppFontWeight.bold,
                      fontColor: AppColor.blackModern50Light,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextWidget(
                      "expire".tr(),
                      fontSize: 11,
                      fontWeight: AppFontWeight.bold,
                      fontColor: AppColor.blackModern50Light.withOpacity(0.5),
                    ),
                    const SizedBox(height: 4),
                    CustomTextWidget(
                      expireDate,
                      fontSize: 13,
                      fontWeight: AppFontWeight.bold,
                      fontColor: AppColor.blackModern50Light,
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
