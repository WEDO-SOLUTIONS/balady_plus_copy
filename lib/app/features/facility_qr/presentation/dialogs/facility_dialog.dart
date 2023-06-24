import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:flutter/material.dart';
import 'package:balady_plus/app/features/facility_qr/facility_qr_exports.dart'
    show RateAndReviewWidget;
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/services/local/navigation_services.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../../core/utils/constants/route_names.dart';
import '../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import '../../../_shared_feature_/presentation/widgets/draw_line_widget.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

class FacilityDialog extends StatelessWidget {
  String? coverPhoto;
  String? facilityName;
  double? rate;
  int? reviewers;
  String? address;
  String? facilityImg;

  Function onRatingScreen;
  Function onDetailsScreen;
  Function onIncidentScreen;

  FacilityDialog(
      {Key? key,
      required this.address,
      required this.facilityImg,
      required this.facilityName,
      required this.rate,
      required this.reviewers,
      required this.onDetailsScreen,
      required this.onRatingScreen,
      required this.onIncidentScreen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(4)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Image.asset(
                          IconPath.qrWhiteCloseIcon,
                          height: 16.0,
                          width: 16.0,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Constants.verticalSpaceMedium,
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: CustomNetworkImageWidget(
                      facilityImg ?? "",
                      imageHeight: 82,
                      imageWidth: 82,
                    ),
                  ),
                  Constants.verticalSpaceMedium,
                  CustomTextWidget(
                    facilityName ?? "",
                    fontColor: AppColor.black,
                    fontWeight: AppFontWeight.bold,
                    fontSize: 22,
                  ),
                  Constants.verticalSpaceSmall,
                  RateAndReviewWidget(rate: rate ?? 0, review: reviewers ?? 0),
                  Constants.verticalSpaceMedium,
                  CustomTextWidget(
                    address ?? "",
                    fontColor: AppColor.black500,
                    fontWeight: AppFontWeight.medium,
                    fontSize: 16,
                  ),
                  Constants.verticalSpaceMedium,
                  EnhancedCustomElevatedButtonWidget(
                    btnPressed: () {
                      NavigationService.navigatorKey.currentState!
                          .pushNamed(RouteName.qrFacilityRatingRoute);
                    },
                    btnText: ("review").tr(),
                    btnTextSize: 16,
                    btnTextWeight: AppFontWeight.regular,
                    btnHeight: 56,
                    btnWidth: 240,
                  ),
                  Constants.verticalSpaceSmall,
                  CustomTextButtonWidget(
                    onPressed: () {
                      onIncidentScreen();
                    },
                    text: ("submit_incident_facility").tr(),
                    btnTextSize: 16,
                    btnTextWeight: AppFontWeight.medium,
                    btnTextColor: AppColor.redBrown,
                  ),
                  Constants.verticalSpaceSmall,
                  DrawLineWidget(
                      lineColor:
                          AppColor.black200.withOpacity(0.2000000029802322)),
                  CustomTextButtonWithIconWidget(
                    btnPressed: () {
                      NavigationService.navigatorKey.currentState!
                          .pushNamed(RouteName.qrFacilityScreenRoute);
                    },
                    icon: Image.asset(
                      IconPath.qrbackIconIcon,
                      height: 18,
                      width: 18,
                    ),
                    btnTextSize: 16,
                    padding: const EdgeInsets.symmetric(
                        vertical: Constants.mediumPadding),
                    btnText: ("facility_details").tr(),
                    btnTextWeight: AppFontWeight.medium,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  )
                ],
              )),
        ],
      ),
    );
  }
}
