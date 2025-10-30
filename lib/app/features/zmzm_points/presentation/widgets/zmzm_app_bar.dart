import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/constants/paths/image_paths.dart';

class ZmZmAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function onChangeCityPressed;
  final String? currentCity;

  const ZmZmAppBar(
      {super.key, required this.onChangeCityPressed, this.currentCity});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 214,
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                ImagePath.zmzmBackground,
              ))),
      child: Column(children: [
        CustomVerticalSpace(height: MediaQuery.of(context).padding.top),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.close,
                  color: AppColor.white,
                )),
            CustomTextWidget(
              ("zamzam_points").tr(),
              fontColor: AppColor.blackModern50Light,
              fontSize: 20,
              fontWeight: AppFontWeight.bold,
            ),
            Container(
              height: 24,
              width: 24,
            )
          ],
        ),
        const CustomVerticalSpace(height: 37),
        ZmZmChangeCityDropDownButton(
          currentCity: currentCity,
          onChangeCityPressed: onChangeCityPressed,
        ),
      ]),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(214);
}

class ZmZmChangeCityDropDownButton extends StatelessWidget {
  final String? currentCity;
  final Function onChangeCityPressed;

  const ZmZmChangeCityDropDownButton(
      {super.key, this.currentCity, required this.onChangeCityPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChangeCityPressed(),
      child: Container(
        height: 48,
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(16),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          CustomTextWidget(
            currentCity ?? ("city_select").tr(),
          ),
          Icon(Icons.arrow_drop_down, color: AppColor.white)
        ]),
        decoration: BoxDecoration(
            border: Border.all(color: AppColor.white),
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(6)),
      ),
    );
  }
}
