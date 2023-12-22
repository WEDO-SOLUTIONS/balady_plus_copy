import 'package:balady_plus/app/app.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show
        CustomCircularContainerForIcons,
        CustomNewIconButtonWidget,
        CustomTextWidget,
        CustomVerticalSpace;
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/etmam_app/features/home/home_exports.dart'
    show EtmamCityWidget, HomeBloc, HomeState;
import 'package:flutter/material.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_icon_btn.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../../../app/core/services/local/navigation_services.dart';
import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppFontWeight, IconPath, RouteName, trans;

class EtmamHomeAppBarWidget extends StatelessWidget {
  const EtmamHomeAppBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      return Container(
        // height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF3B69DE).withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 6.8),
            ),
          ],
          gradient: const LinearGradient(
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
              children: [
                CustomNewIconButtonWidget(
                  btnPressed: () {
                    Navigator.pop(context);
                  },
                  iconWidget: const Icon(Icons.close, color: AppColor.white),
                ),
                Expanded(
                  child: CustomTextWidget(
                    !context.read<HomeBloc>().isMunicipalService
                        ? "service_provide_services".tr()
                        : "balady_works".tr(),
                    fontSize: 20,
                    fontWeight: AppFontWeight.bold,
                    textAlign: TextAlign.start,
                    fontColor: AppColor.white,
                  ),
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
                const SizedBox(width: 8),
                CustomCircularContainerForIcons(
                  child: CustomIconButtonWidget(
                    svgIcon: IconPath.ordersIconWhite,
                    btnPressed: () {
                      NavigationService.pushNamed(
                          routeName: EtmamRoutesNames.myRequestsPage);
                    },
                    btnHeight: 32,
                    btnWidth: 32,
                    svgIconWidth: 30,
                    svgIconHeight: 30,
                  ),
                ),
              ],
            ),
            const CustomVerticalSpace(height: 11),
            CustomTextWidget(
              trans("etmam_appBar_text"),
              fontWeight: AppFontWeight.bold,
              fontColor: AppColor.secondary200,
              fontSize: 14,
            ),
            const CustomVerticalSpace(height: 11),
            const EtmamCityWidget()
          ],
        ),
      );
    });
  }
}
