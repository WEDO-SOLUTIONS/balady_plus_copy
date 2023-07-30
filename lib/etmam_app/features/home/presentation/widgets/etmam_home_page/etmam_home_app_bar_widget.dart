import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show CustomTextWidget, CustomVerticalSpace;
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/etmam_app/features/home/home_exports.dart'
    show EtmamCityWidget;
import 'package:flutter/material.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_icon_btn.dart';
import '../../../../../../app/core/services/local/navigation_services.dart';
import '../../../../../core/utils/utils_exports.dart'
    show AppColor, IconPath, RouteName, trans;

class EtmamHomeAppBarWidget extends StatelessWidget {
  const EtmamHomeAppBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 150,
      width: double.infinity,
      color: AppColor.spruce,
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 20,
          right: 23,
          left: 23,
          bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: CustomTextWidget(
                  trans('bottomNavigationBarStoreWord'),
                  fontSize: 24,
                  textAlign: TextAlign.start,
                ),
              ),
              CustomIconButtonWidget(
                svgIcon: IconPath.searchIconWhite,
                btnPressed: () {
                  NavigationService.pushNamed(
                      routeName: EtmamRoutesNames.searchPage);
                },
                btnHeight: 32,
                btnWidth: 32,
                svgIconWidth: 32,
                svgIconHeight: 32,
              ),
              CustomIconButtonWidget(
                svgIcon: IconPath.ordersIconWhite,
                btnPressed: () {
                  NavigationService.pushNamed(
                      routeName: EtmamRoutesNames.myOrdersPage);
                },
                btnHeight: 32,
                btnWidth: 32,
                svgIconWidth: 32,
                svgIconHeight: 32,
              ),
            ],
          ),
          CustomVerticalSpace(height: 16),
          EtmamCityWidget()
        ],
      ),
    );
  }
}
