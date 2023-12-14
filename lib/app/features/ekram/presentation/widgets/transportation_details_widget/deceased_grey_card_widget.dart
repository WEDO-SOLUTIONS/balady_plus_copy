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
          color: Color(0xffF3F7F7), borderRadius: BorderRadius.circular(16)),
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
                title: ('deceasedName').tr(),
                details: item.name ?? "",
              )),
              CustomHorizontalSpace(width: 12),
              Expanded(
                  child: EkramHeaderAndDescWidget(
                title: ('ekramGender').tr(),
                details: (item.gender == "FEMALE")
                    ? "female".tr()
                    : (item.gender == "MALE" ? "male".tr() : item.gender ?? ""),
              ))
            ],
          ),
          const CustomVerticalSpace(height: 20),
          Row(
            children: [
              Expanded(
                  child: EkramHeaderAndDescWidget(
                title: ('ekramNationality').tr(),
                details: item.nationality ?? "",
              )),
              CustomHorizontalSpace(width: 12),
              Expanded(
                  child: EkramHeaderAndDescWidget(
                title: ('ekramReligion').tr(),
                details: !(item.isMuslim ?? false)
                    ? ("non_muslim").tr()
                    : ("muslim").tr(),
              ))
            ],
          ),
          const CustomVerticalSpace(height: 20),
          Row(
            children: [
              Expanded(
                  child: EkramHeaderAndDescWidget(
                title: ('needSpecialTransfer').tr(),
                details: (item.specialTransferNeeded ?? false)
                    ? ("yes").tr()
                    : ("no").tr(),
              )),
              CustomHorizontalSpace(width: 12),
              if (item.specialTransferNeeded == true)
                Expanded(
                    child: EkramHeaderAndDescWidget(
                  title: ('reasonForSpecialTransfer').tr(),
                  details: item.getSpecialTransferReason(),
                ))
            ],
          ),
          const CustomVerticalSpace(height: 20),
          Row(
            children: [
              Expanded(
                  child: EkramHeaderAndDescWidget(
                title: ('driver').tr(),
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
                  title: ('driverMobile').tr(),
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
                title: ('burial_city').tr(),
                details: item.burialCityName ?? "",
              )),
              CustomHorizontalSpace(width: 12),
              Expanded(
                  child: EkramHeaderAndDescWidget(
                title: ('transportation_orgnization').tr(),
                details: item.transferOrganizationName ?? "",
              ))
            ],
          ),
          const CustomVerticalSpace(height: 16),
          Row(
            children: [
              Expanded(
                  child: EkramHeaderAndDescWidget(
                title: ('transportationType').tr(),
                details: item.getCityType(),
              )),
              CustomHorizontalSpace(width: 12),
              Expanded(
                  child: EkramHeaderAndDescWidget(
                title: ('carModel').tr(),
                details: item.carBrand ?? "",
              ))
            ],
          ),
          const CustomVerticalSpace(height: 16),
          Row(
            children: [
              Expanded(
                  child: EkramHeaderAndDescWidget(
                title: ('carBard').tr(),
                details: item.carModel ?? "",
              )),
              CustomHorizontalSpace(width: 12),
              Expanded(
                  child: EkramHeaderAndDescWidget(
                title: ('carYear').tr(),
                details: item.carManufacturingYear?.toString() ?? "",
              ))
            ],
          ),
          const CustomVerticalSpace(height: 16),
          Row(
            children: [
              Expanded(
                  child: EkramHeaderAndDescWidget(
                title: ('carBoard_en').tr(),
                details: item.carDashboardDetailsEn ?? "",
              )),
              CustomHorizontalSpace(width: 12),
              Expanded(
                  child: EkramHeaderAndDescWidget(
                title: ('carBoard').tr(),
                details: item.carDashboardDetailsAr ?? "",
              ))
            ],
          ),
          const CustomVerticalSpace(height: 16),
          Row(
            children: [
              if (item.baqieBurialPermitStatus != null)
                Expanded(
                    child: EkramHeaderAndDescWidget(
                  title: ('ekram_baquie_approval_status').tr(),
                  details: item.baqieBurialPermitStatus.toString() ?? "",
                )),
              CustomHorizontalSpace(width: 12),
              if (item.baqieBurialPermitApprovalDate != null)
                Expanded(
                    child: EkramHeaderAndDescWidget(
                  title: ('ekram_baquie_approval_date').tr(),
                  details: item.baqieBurialPermitApprovalDate.toString() ?? "",
                ))
            ],
          ),
          const CustomVerticalSpace(height: 20),
          DrawLineWidget(
            lineColor: AppColor.black400.withOpacity(0.2000000029802322),
          ),
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
