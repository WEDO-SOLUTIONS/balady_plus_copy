import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:flutter/material.dart';

import '../../../../../../etmam_app/core/utils/common_functions.dart';
import '../../../../../../etmam_app/core/utils/constants/app_config.dart';
import '../../../../../core/services/services_exports.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../../core/utils/enums/app_font_weights.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/draw_line_widget.dart';
import '../../../domain/entities/deceased_request_details/deceased_request_details.dart';
import '../ekram_status_widget.dart';

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
            lineColor: AppColor.black400.withOpacity(0.2000000029802322),
          ),
          CustomTextButtonWithIconWidgetWithFlexible(
            mainAxisAlignment: MainAxisAlignment.start,
            btnPressed: () {
              if (item.getTransferOrganizationLocation() != null)
                NavigationService.navigatorKey.currentState!
                    .pushNamed(RouteName.EkramMapPage, arguments: item);
            },
            btnText: trans('navigateOnMap'),
            icon: CustomSvgIconWidget(
              "assets/icons/tracking.svg",
              iconHeight: 16,
              iconWidth: 16,
            ),
            buttonIconPosition: BUTTON_ICON_POSITION.right,
            btnTextColor: AppColor.primary900Light,
            btnTextSize: 13,
            btnTextWeight: AppFontWeight.medium,
            padding: EdgeInsets.all(Constants.semiMediumPadding),
          ),
        ],
      ),
    );
  }
}
