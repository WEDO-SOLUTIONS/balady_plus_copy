import 'package:balady_plus/app/app.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show
        CustomCircularContainerForIcons,
        CustomNewIconButtonWidget,
        CustomTextWidget,
        CustomVerticalSpace;
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/etmam_app/features/home/home_exports.dart'
    show EtmamCityWidget;
import 'package:flutter/material.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_icon_btn.dart';
import '../../../../../../app/core/services/local/navigation_services.dart';
import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppFontWeight, IconPath, RouteName, trans;

class EtmamHomeAppBarWidget extends StatelessWidget {
  const EtmamHomeAppBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 150,
      width: double.infinity,
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0x663B69DE),
            blurRadius: 12,
            offset: Offset(0, 6.8),
          ),
        ],
        gradient: LinearGradient(
          colors: [
            Color(0xFF155F75),
            Color(0xFF3A879D),
          ],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        ),
      ),
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 20,
          right: 16,
          left: 16,
          bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomNewIconButtonWidget(
                btnPressed: () {
                  Navigator.pop(context);
                },
                iconWidget: const Icon(Icons.close, color: AppColor.white),
              ),
              CustomTextWidget(
                trans('bottomNavigationBarStoreWord'),
                fontSize: 24,
                textAlign: TextAlign.start,
                fontColor: AppColor.white,
              ),
              // CustomIconButtonWidget(
              //   svgIcon: IconPath.searchIconWhite,
              //   btnPressed: () {
              //     NavigationService.pushNamed(
              //         routeName: EtmamRoutesNames.searchPage);
              //   },
              //   btnHeight: 32,
              //   btnWidth: 32,
              //   svgIconWidth: 32,
              //   svgIconHeight: 32,
              // ),

              // CustomCircularContainerForIcons(iconPath: IconPath.ordersIconWhite, onPressed:() {
              //     NavigationService.pushNamed(
              //         routeName: EtmamRoutesNames.myOrdersPage);
              //   } ,)

              CustomCircularContainerForIcons(
                child: CustomIconButtonWidget(
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
              ),
            ],
          ),
          const CustomVerticalSpace(height: 11),
          const CustomTextWidget(
            'حدد المدينة التي تريد تنفيذ الخدمة فيها',
            fontWeight: AppFontWeight.bold,
            fontColor: Color(0xFFCADCB7),
          ),
          const CustomVerticalSpace(height: 11),
          const EtmamCityWidget()
        ],
      ),
    );
  }
}
