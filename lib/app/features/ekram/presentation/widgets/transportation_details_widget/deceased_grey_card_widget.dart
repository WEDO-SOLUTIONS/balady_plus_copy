import 'package:balady_new_app/app/features/ekram/ekram_exports.dart';
import 'package:balady_new_app/shared/core/utils/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:balady_new_app/app/core/core_exports.dart' show RoutesNames;
import 'package:balady_new_app/shared/core/services/local/navigation_services.dart';
import '../../../../../../etmam_app/core/utils/constants/app_config.dart';
import '../../../../../../shared/features/_shared_feature_/shared/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../../core/shared_local_services/app_colors.dart';
import '../../../../../core/shared_widgets/draw_line_widget.dart';
import '../../../../../core/shared_local_services/enums.dart';
import '../../../../../core/shared_widgets/custom_buttons_widgets.dart';
import '../../../../../core/shared_widgets/custom_svg_icon_widget.dart';

class DeceasedGreyCardWidget extends StatelessWidget {
  final DeceasedInfoResponseDtoList item;
  final bool isDriver;
  final Function onPressShowTrips;
  final Function onPressLogTrip;
  final Function showLocation;
  final bool showLogTrip;

  const DeceasedGreyCardWidget(
      {Key? key,
      required this.item,
      required this.isDriver,
      required this.onPressShowTrips,
      required this.showLocation,
      required this.onPressLogTrip,
      required this.showLogTrip})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 60,
      decoration: new BoxDecoration(
          color: Color(0xfff1f1f1), borderRadius: BorderRadius.circular(4)),
      // padding: EdgeInsets.all(24),
      padding: EdgeInsets.only(bottom: 12, left: 24, top: 24, right: 24),
      margin: EdgeInsets.only(bottom: 8, left: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                  child: EkramHeaderAndDescWidget(
                title: trans('deceasedName'),
                details: item.name ?? "",
              )),
              CustomHorizontalSpace(width: 12),
              Expanded(
                  child: EkramHeaderAndDescWidget(
                title: trans('ekramGender'),
                details: item.gender ?? "",
              ))
            ],
          ),
          const CustomVerticalSpace(height: 20),
          Row(
            children: [
              Expanded(
                  child: EkramHeaderAndDescWidget(
                title: trans('ekramNationality'),
                details: item.nationality ?? "",
              )),
              CustomHorizontalSpace(width: 12),
              Expanded(
                  child: EkramHeaderAndDescWidget(
                title: trans('ekramReligion'),
                details: !(item.isMuslimReligion ?? false)
                    ? trans("non_muslim")
                    : trans("muslim"),
              ))
            ],
          ),
          const CustomVerticalSpace(height: 20),
          Row(
            children: [
              Expanded(
                  child: EkramHeaderAndDescWidget(
                title: trans('needSpecialTransfer'),
                details: (item.specialTransferNeeded ?? false)
                    ? trans("yes")
                    : trans("no"),
              )),
              CustomHorizontalSpace(width: 12),
              if (item.specialTransferNeeded == true)
                Expanded(
                    child: EkramHeaderAndDescWidget(
                  title: trans('reasonForSpecialTransfer'),
                  details: item.getSpecialTransferReason(),
                ))
            ],
          ),
          const CustomVerticalSpace(height: 20),
          Row(
            children: [
              Expanded(
                  child: EkramHeaderAndDescWidget(
                title: trans('driver'),
                details: item.transferDriverName ?? "",
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
          const CustomVerticalSpace(height: 16),
          Row(
            children: [
              Expanded(
                  child: EkramHeaderAndDescWidget(
                title: trans('burial_city'),
                details: item.burialCityName ?? "",
              )),
              CustomHorizontalSpace(width: 12),
              Expanded(
                  child: EkramHeaderAndDescWidget(
                title: trans('transportation_orgnization'),
                details: item.transferOrganizationName ?? "",
              ))
            ],
          ),
          const CustomVerticalSpace(height: 16),
          Row(
            children: [
              Expanded(
                  child: EkramHeaderAndDescWidget(
                title: trans('transportationType'),
                details: item.getCityType(),
              )),
              CustomHorizontalSpace(width: 12),
              Expanded(
                  child: EkramHeaderAndDescWidget(
                title: trans('carModel'),
                details: item.carBrand ?? "",
              ))
            ],
          ),
          const CustomVerticalSpace(height: 16),
          Row(
            children: [
              Expanded(
                  child: EkramHeaderAndDescWidget(
                title: trans('carBard'),
                details: item.carModel ?? "",
              )),
              CustomHorizontalSpace(width: 12),
              Expanded(
                  child: EkramHeaderAndDescWidget(
                title: trans('carYear'),
                details: item.carManufacturingYear?.toString() ?? "",
              ))
            ],
          ),
          const CustomVerticalSpace(height: 16),
          Row(
            children: [
              Expanded(
                  child: EkramHeaderAndDescWidget(
                title: trans('carBoard_en'),
                details: item.carDashboardDetailsEn ?? "",
              )),
              CustomHorizontalSpace(width: 12),
              Expanded(
                  child: EkramHeaderAndDescWidget(
                title: trans('carBoard'),
                details: item.carDashboardDetailsAr ?? "",
              ))
            ],
          ),
          const CustomVerticalSpace(height: 20),
          DrawLineWidget(
            lineColor: AppColors.black400.withOpacity(0.2000000029802322),
          ),
          if (!isDriver)
            CustomTextButtonWithIconWidgetWithFlexible(
              mainAxisAlignment: MainAxisAlignment.start,
              btnPressed: () {
                showLocation();
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
              //  padding: EdgeInsets.all(Constants.semiMediumPadding),
            ),
          if (isDriver)
            Row(
              children: [
                if (showLogTrip)
                  Expanded(
                    child: CustomTextButtonWithIconWidgetWithFlexible(
                      mainAxisAlignment: MainAxisAlignment.start,
                      btnPressed: () => onPressLogTrip(),
                      btnText: trans('log_driver_trip'),
                      icon: CustomSvgIconWidget(
                        "assets/icons/tracking.svg",
                        iconHeight: 16,
                        iconWidth: 16,
                      ),
                      buttonIconPosition: BUTTON_ICON_POSITION.right,
                      btnTextColor: AppColors.darkTurquoise,
                      btnTextSize: 13,
                      btnTextWeight: FONT_WEIGHT.medium,
                      //  padding: EdgeInsets.all(Constants.semiMediumPadding),
                    ),
                  ),
                Expanded(
                  child: CustomTextButtonWithIconWidgetWithFlexible(
                    mainAxisAlignment: MainAxisAlignment.start,
                    btnPressed: () => onPressShowTrips(),

                    btnText: trans('show_driver_trips'),
                    icon: CustomSvgIconWidget(
                      "assets/icons/detailsIconSVG.svg",
                      iconHeight: 16,
                      iconWidth: 16,
                    ),
                    buttonIconPosition: BUTTON_ICON_POSITION.right,
                    btnTextColor: AppColors.darkTurquoise,
                    btnTextSize: 13,
                    btnTextWeight: FONT_WEIGHT.medium,
                    //  padding: EdgeInsets.all(Constants.semiMediumPadding),
                  ),
                ),
              ],
            )
        ],
      ),
    );
  }
}
