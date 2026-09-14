import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Row(
        children: [
          /* if (CommonProperties.isLoggedIn) ...[
            const CircleIcon(
              icon: IconPath.profile,
              iconColor: AppColor.black,
            ),
            const SizedBox(width: 8)
          ],
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  style: AppStyle.semiBoldTextStyle,
                  text: CommonProperties.isLoggedIn
                      ? "${"welcome".tr()}, "
                      : "Welcome_Guest".tr(),
                ),
                TextSpan(
                  style: AppStyle.blackTextStyle,
                  text: CommonProperties.userInfo?.getFirstAndLastName(),
                )
              ],
            ),
          ),
          // const Spacer(),
          // const CurrentWeather(
          //   weatherCondition: WeathherConditions.partlyClouded,
          //   temperature: "16",
          // )*/
        ],
      ),
    );
  }
}
