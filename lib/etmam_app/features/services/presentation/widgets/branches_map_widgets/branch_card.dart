import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppFontWeight, CommonFunctions, IconPath;

class BranchCard extends StatelessWidget {
  final String name;
  final String address;
  final String? mobile;

  const BranchCard(
      {Key? key, required this.name, required this.address, this.mobile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 103,
        margin: const EdgeInsets.only(right: 16, left: 16, bottom: 30),
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(1)),
            color: AppColor.black100,
            boxShadow: [
              BoxShadow(
                  color: AppColor.greyShadow,
                  offset: Offset(0, 2),
                  blurRadius: 5,
                  spreadRadius: 0)
            ]),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextWidget(
                    name,
                    fontSize: 16,
                    fontWeight: AppFontWeight.bold,
                    fontColor: AppColor.black,
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                  const CustomVerticalSpace(height: 16),
                  Row(
                    children: [
                      const CustomSvgIconWidget(
                        IconPath.providerDetailsLocation,
                        iconColor: AppColor.greyText,
                        iconHeight: 10,
                        iconWidth: 8,
                      ),
                      const CustomHorizontalSpace(width: 5),
                      Expanded(
                        child: CustomTextWidget(
                          address,
                          fontSize: 14,
                          fontWeight: AppFontWeight.medium,
                          fontColor: AppColor.black500,
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          textOverflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            if (mobile != null && mobile!.isNotEmpty)
              CustomIconButtonWidget(
                  padding: EdgeInsets.zero,
                  btnPressed: () {
                    CommonFunctions.call(mobile);
                  },
                  icon: Container(
                    width: 48,
                    height: 48,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColor.darkTurquoise),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: const CustomSvgIconWidget(
                      IconPath.callIcon,
                      iconColor: AppColor.darkTurquoise,
                      iconSize: 14,
                      iconHeight: 14,
                      iconWidth: 14,
                    ),
                  ))
          ],
        ));
  }
}
