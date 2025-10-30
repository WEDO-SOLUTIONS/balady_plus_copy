import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:flutter/material.dart';

import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import '../../../../../core/utils/utils_exports.dart'
    show AppColor, ButtonIconPosition, IconPath, RouteName, trans;
import '../../../../_shared_feature_/shared/shared_feature_exports.dart'
    show CustomElevatedButtonWidget, CustomSvgIconWidget;

class SearchWidget extends StatelessWidget {
  const SearchWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(right: 16, left: 16, top: 30),
        child: CustomElevatedButtonWidget(
            btnColor: AppColor.white,
            btnPressed: () {
              NavigationService.pushNamed(
                  routeName: EtmamRoutesNames.searchPage);
            },
            btnHeight: 56,
            btnRadius: 12,
            btnTextSize: 14,
            btnText: trans('Search_SearchForServiceHint'),
            buttonIconPosition: ButtonIconPosition.left,
            btnTextColor: AppColor.bottomNavigationShadow,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            btnPadding: const EdgeInsets.symmetric(horizontal: 16),
            icon: const CustomSvgIconWidget(
              IconPath.search,
              iconSize: 24,
            )));
  }
}
