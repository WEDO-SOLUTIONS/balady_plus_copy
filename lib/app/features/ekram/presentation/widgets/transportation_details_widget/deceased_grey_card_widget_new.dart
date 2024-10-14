import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../etmam_app/core/utils/common_functions.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/enums/app_font_weights.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/draw_line_widget.dart';
import '../../../domain/entities/deceased_request_details/deceased_request_details.dart';
import '../ekram_status_widget.dart';

class DeceasedGreyCardWidget_new extends StatelessWidget {
  final DeceasedInfoResponseDtoList item;
  final bool isDriver;
  final Function onPressShowTrips;
  final Function onPressLogTrip;
  final Function showLocation;
  final bool showLogTrip;

  const DeceasedGreyCardWidget_new(
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
          color: AppColor.white, borderRadius: BorderRadius.circular(16)),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(height: 15,),
          EkramHeaderAndDescWidget_new(
                      title: ('deceasedName').tr(),
                      details: item.name ?? "",
                    ),
          EkramHeaderAndDescWidget_new(
                      title: ('ekram_deceased_id').tr(),
                      details: item.carId !=null ?"${item.carId}" :"",
                    ),
          EkramHeaderAndDescWidget_new(
                      title: ('transportationStatus').tr(),
                      details: item.carId !=null ?"${item.carId}" :"",
                    ),
          EkramHeaderAndDescWidget_new(
            title: ('deathCity/arrivelCity').tr(),
            details: item.carId !=null ?"${item.carId}" :"",
          ),
          EkramHeaderAndDescWidget_new(
            title: ('burial_city').tr(),
            details: item.burialCityName ?? "",
          ),
          EkramHeaderAndDescWidget_new(
            title: ('ekram_reciever_Mobile').tr(),
            details: item.burialCityName ?? "",
          ),
          EkramHeaderAndDescWidget_new(
                      title: ('needSpecialTransfer').tr(),
                      details: (item.specialTransferNeeded ?? false)
            ? ("yes").tr()
            : ("no").tr(),
                    ),
          if (item.specialTransferNeeded == true)
            EkramHeaderAndDescWidget_new(
                          title: ('reasonForSpecialTransfer').tr(),
                          details: item.getSpecialTransferReason(),
                        ),
          //
          // EkramHeaderAndDescWidget_new(
          //             title: ('driver').tr(),
          //             details: item.transferDriverName ?? "",
          //           ),
          //
          // GestureDetector(
          //             onTap: () {
          // if (item.driverMobileNumber != null) {
          //   CommonFunctions.call(item.driverMobileNumber);
          // }
          //             },
          //             child: EkramHeaderAndDescWidget_new(
          // title: ('driverMobile').tr(),
          // details: item.driverMobileNumber ?? "",
          //             ),
          //           ),



          // EkramHeaderAndDescWidget_new(
          //             title: ('transportation_orgnization').tr(),
          //             details: item.transferOrganizationName ?? "",
          //           ),
          // const CustomVerticalSpace(height: 16),
          // EkramHeaderAndDescWidget_new(
          //             title: ('transportationType').tr(),
          //             details: item.getCityType(),
          //           ),
          // CustomHorizontalSpace(width: 12),
          // EkramHeaderAndDescWidget_new(
          //             title: ('carModel').tr(),
          //             details: item.carBrand ?? "",
          //           ),
          // const CustomVerticalSpace(height: 16),
          // EkramHeaderAndDescWidget_new(
          //             title: ('carBard').tr(),
          //             details: item.carModel ?? "",
          //           ),
          // CustomHorizontalSpace(width: 12),
          // EkramHeaderAndDescWidget_new(
          //             title: ('carYear').tr(),
          //             details: item.carManufacturingYear?.toString() ?? "",
          //           ),
          // const CustomVerticalSpace(height: 16),
          // EkramHeaderAndDescWidget_new(
          //             title: ('carBoard_en').tr(),
          //             details: item.carDashboardDetailsEn ?? "",
          //           ),
          // CustomHorizontalSpace(width: 12),
          // EkramHeaderAndDescWidget_new(
          //             title: ('carBoard').tr(),
          //             details: item.carDashboardDetailsAr ?? "",
          //           ),
          // const CustomVerticalSpace(height: 16),
          // if (item.baqieBurialPermitStatus != null)
          //   EkramHeaderAndDescWidget_new(
          //                 title: ('ekram_baquie_approval_status').tr(),
          //                 details: item.baqieBurialPermitStatus.toString() ?? "",
          //               ),
          // CustomHorizontalSpace(width: 12),
          // if (item.baqieBurialPermitApprovalDate != null)
          //   EkramHeaderAndDescWidget_new(
          //                 title: ('ekram_baquie_approval_date').tr(),
          //                 details: item.baqieBurialPermitApprovalDate.toString() ?? "",
          //               ),
          // const CustomVerticalSpace(height: 20),
          // DrawLineWidget(
          //   lineColor: AppColor.black400.withOpacity(0.2000000029802322),
          // ),
          //

          if (!isDriver && item.trips != null && item.trips!.isNotEmpty)
            ElevatedButtonWidget.primaryCustom(
              onPressed: () {
                showLocation();
              },
              text: ('navigateOnMap').tr(),
            ),
          if (isDriver)
            Row(
              children: [
                if (showLogTrip)
                  Expanded(
                    child: CustomTextButtonWithIconWidgetWithFlexible(
                      mainAxisAlignment: MainAxisAlignment.start,
                      btnPressed: () => onPressLogTrip(),
                      btnText: ('log_driver_trip').tr(),
                      icon: CustomSvgIconWidget(
                        "assets/icons/tracking.svg",
                        iconHeight: 16,
                        iconWidth: 16,
                      ),
                      buttonIconPosition: BUTTON_ICON_POSITION.right,
                      btnTextColor: AppColor.primary900Light,
                      btnTextSize: 13,
                      btnTextWeight: AppFontWeight.medium,
                      //  padding: EdgeInsets.all(Constants.semiMediumPadding),
                    ),
                  ),
                Expanded(
                  child: CustomTextButtonWithIconWidgetWithFlexible(
                    mainAxisAlignment: MainAxisAlignment.start,
                    btnPressed: () => onPressShowTrips(),

                    btnText: ('show_driver_trips').tr(),
                    icon: CustomSvgIconWidget(
                      "assets/icons/detailsIconSVG.svg",
                      iconHeight: 16,
                      iconWidth: 16,
                    ),
                    buttonIconPosition: BUTTON_ICON_POSITION.right,
                    btnTextColor: AppColor.primary900Light,
                    btnTextSize: 13,
                    btnTextWeight: AppFontWeight.medium,
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
