import 'package:flutter/material.dart';

import '../../../core/utils/utils_exports.dart';
import '../../_shared_feature_/shared_feature_exports.dart';

class HeaderWithDivider extends StatelessWidget {
  const HeaderWithDivider({
    super.key,
    required this.firstTitle,
    required this.secondTitle,
    required this.firstValue,
    required this.secondValue,
    required this.firstIconPath,
  });

  final String firstTitle;
  final String secondTitle;
  final String firstValue;
  final String secondValue;
  final String firstIconPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 32),
      width: MediaQuery.sizeOf(context).width,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        color: AppColor.white,
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextWidget(
                  firstTitle,
                  fontSize: 14,
                  fontWeight: AppFontWeight.bold,
                  fontColor: AppColor.blackModern600Light,
                ),
                const SizedBox(height: 4),
                Flexible(
                  child: Row(
                    children: [
                      CustomSvgIconWidget(firstIconPath),
                      const SizedBox(width: 8),
                      CustomTextWidget(
                        firstValue,
                        fontSize: 14,
                        fontWeight: AppFontWeight.bold,
                        fontColor: AppColor.blackModern500Light,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 34),
              child: VerticalDivider(
                color: Colors.black,
                thickness: 1,
              ),
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextWidget(
                    secondTitle,
                    fontSize: 14,
                    fontWeight: AppFontWeight.bold,
                    fontColor: AppColor.blackModern600Light,
                  ),
                  const SizedBox(height: 8),
                  CustomTextWidget(
                    secondValue,
                    fontSize: 14,
                    fontWeight: AppFontWeight.bold,
                    fontColor: AppColor.blackModern500Light,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
