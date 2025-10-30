import 'package:balady_plus/etmam_app/core/utils/constants/app_color.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart';
import 'package:flutter/material.dart';

import '../../../../../app/core/utils/constants/constants.dart';

class BiddingTypeWidgt extends StatelessWidget {
  final String? logoUrl;
  final String name;
  final Function onPress;
  const BiddingTypeWidgt(
      {Key? key, required this.onPress, required this.name, this.logoUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPress(),
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            border:
                Border.all(color: AppColor.black200, width: 0.5775000000000001),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x1a000000),
                  offset: Offset(0, 1),
                  blurRadius: 15,
                  spreadRadius: 0)
            ],
            color: Colors.white),
        padding: const EdgeInsets.all(Constants.semiMediumPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // icon
            CustomNetworkImageWidget(
              logoUrl ?? "",
              imageHeight: 38,
              imageWidth: 38,
            ),
            Constants.verticalSpaceSmall,
            // service name
            CustomTextWidget(
              name,
              fontColor: AppColor.black,
              fontSize: 15.0,
            ),
          ],
        ),
      ),
    );
  }
}
