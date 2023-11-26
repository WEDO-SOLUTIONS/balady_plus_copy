import 'package:balady_new_app/app/core/core_exports.dart' show RoutesNames;
import 'package:balady_new_app/app/features/ekram/ekram_exports.dart';
import 'package:balady_new_app/shared/core/services/local/navigation_services.dart';
import 'package:balady_new_app/shared/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';

import '../../../../../../etmam_app/core/utils/constants/app_config.dart';
import '../../../../../../shared/features/_shared_feature_/shared/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../../core/shared_local_services/app_colors.dart';
import '../../../../../core/shared_local_services/constants.dart';
import '../../../../../core/shared_local_services/enums.dart';
import '../../../../../core/shared_widgets/custom_buttons_widgets.dart';
import '../../../../../core/shared_widgets/custom_svg_icon_widget.dart';
import '../../../../../core/shared_widgets/draw_line_widget.dart';

class DriverCardWidget extends StatelessWidget {
  final DeceasedInfoResponseDtoList item;
  const DriverCardWidget({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      width: MediaQuery.of(context).size.width - 60,
      padding: EdgeInsets.only(top: 24),
      decoration: new BoxDecoration(
          color: Color(0xfff1f1f1), borderRadius: BorderRadius.circular(4)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: EkramHeaderAndDescWidget(
                      title: trans('driver'),
                      details: item.transferDriverName ?? "",
                    )),
                    CustomHorizontalSpace(width: 12),
                    Expanded(
                        child: EkramHeaderAndDescWidget(
                      title: trans('carModel'),
                      details: item.carModel ?? "",
                    ))
                  ],
                ),
                const CustomVerticalSpace(height: 20),
                Row(
                  children: [
                    Expanded(
                        child: EkramHeaderAndDescWidget(
                      title: trans('carName'),
                      details: item.carBrand ?? "",
                    )),
                    CustomHorizontalSpace(width: 12),
                    Expanded(
                        child: EkramHeaderAndDescWidget(
                      title: trans('manufacturingYear'),
                      details: item.carManufacturingYear.toString() ?? "",
                    ))
                  ],
                ),
                const CustomVerticalSpace(height: 20),
                Row(
                  children: [
                    Expanded(
                        child: EkramHeaderAndDescWidget(
                      title: trans('carBoard'),
                      details: item.carDashboardDetailsAr ?? "",
                    )),
                    CustomHorizontalSpace(width: 12),
                    Expanded(
                        child: GestureDetector(
                      onTap: () {
                        if (item.driverMobileNumber != null) {
                          CommonFunctions.call(item.driverMobileNumber);
                        }
                      },
                      child: EkramHeaderAndDescWidget(
                        title: trans('driverMobile'),
                        details: item.driverMobileNumber ?? "",
                      ),
                    ))
                  ],
                ),
              ],
            ),
          ),
          Spacer(),
          DrawLineWidget(
            lineColor: AppColors.black400.withOpacity(0.2000000029802322),
          ),
          CustomTextButtonWithIconWidgetWithFlexible(
            mainAxisAlignment: MainAxisAlignment.start,
            btnPressed: () {
              if (item.getTransferOrganizationLocation() != null)
                NavigationService.navigatorKey.currentState!
                    .pushNamed(RoutesNames.EkramMapPage, arguments: item);
            },
            btnText: trans('navigateOnMap'),
            icon: CustomSvgIconWidget(
              "assets/icons/tracking.svg",
              iconHeight: 16,
              iconWidth: 16,
            ),
            buttonIconPosition: BUTTON_ICON_POSITION.right,
            btnTextColor: AppColors.darkTurquoise,
            btnTextSize: 13,
            btnTextWeight: FONT_WEIGHT.medium,
            padding: EdgeInsets.all(Constants.semiMediumPadding),
          ),
        ],
      ),
    );
  }
}
