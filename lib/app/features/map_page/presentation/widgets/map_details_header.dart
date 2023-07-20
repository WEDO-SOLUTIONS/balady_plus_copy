import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class MapDetailsHeader extends StatelessWidget {
  final String name;
  final String address;
  const MapDetailsHeader(
      {super.key, required this.name, required this.address});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        decoration: ShapeDecoration(
          color: AppColor.primary900Light,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),

          // image: DecorationImage(image: AssetImage())
        ),
        child: Column(
          children: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.close,
                  color: AppColor.white,
                )),
            CustomVerticalSpace(height: 20),
            CustomTextWidget(
              name,
              fontColor: AppColor.blackModern800Light,
              fontWeight: AppFontWeight.bold,
              fontSize: 18,
            ),
            CustomTextWidget(
              address,
              fontColor: AppColor.blackModern500Light,
              fontWeight: AppFontWeight.semiBold,
              fontSize: 14,
            )
          ],
        ));
  }
}
