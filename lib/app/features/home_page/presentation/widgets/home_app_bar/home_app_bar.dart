import 'package:balady_plus/app/features/home_page/home_exports.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, IconPath, WeathherConditions;

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Row(
        children: [
          const CircleIcon(
            icon: IconPath.profile,
            iconColor: AppColor.black,
          ),
          const SizedBox(width: 8),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  style: AppStyle.semiBoldTextStyle,
                  text: "${"welcome".tr()}, ",
                ),
                TextSpan(
                  style: AppStyle.blackTextStyle,
                  text: "محمد",
                )
              ],
            ),
          ),
          const Spacer(),
          const CurrentWeather(
            weatherCondition: WeathherConditions.partlyClouded,
            temperature: "16",
          )
        ],
      ),
    );
  }
}
