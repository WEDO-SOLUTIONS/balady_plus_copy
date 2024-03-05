import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:flutter/material.dart';
import 'package:balady_plus/app/features/facility_qr/facility_qr_exports.dart'
    show FacilityRatingScreen, RateAndReviewWidget;
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/services/local/navigation_services.dart';
import '../../../../core/utils/common_functions.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../../core/utils/constants/route_names.dart';
import '../../../../core/utils/constants/ux_cam_events.dart';
import '../../../_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import '../../../_shared_feature_/presentation/components/bottom_sheets/bottom_sheet_with_actions.dart';
import '../../../_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import '../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import '../../../_shared_feature_/presentation/widgets/draw_line_widget.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

class FacilityDialog extends StatefulWidget {
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
  State<FacilityDialog> createState() => _FacilityDialogState();
}

class _FacilityDialogState extends State<FacilityDialog> {
  String? coverPhoto;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    CommonFunctions.sendUXCamEvent(
        UXCamEvents.YourFeedback_Show_Dialog_QR_Event);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
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
                        widget.facilityImg ?? "",
                        imageHeight: 82,
                        imageWidth: 82,
                        ssoAuth: false,
                      ),
                    ),
                    Constants.verticalSpaceMedium,
                    CustomTextWidget(
                      widget.facilityName ?? "",
                      fontColor: AppColor.black,
                      fontWeight: AppFontWeight.bold,
                      fontSize: 22,
                    ),
                    Constants.verticalSpaceSmall,
                    RateAndReviewWidget(
                        rate: widget.rate ?? 0, review: widget.reviewers ?? 0),
                    Constants.verticalSpaceMedium,
                    CustomTextWidget(
                      widget.address ?? "",
                      fontColor: AppColor.black500,
                      fontWeight: AppFontWeight.medium,
                      fontSize: 16,
                    ),
                    Constants.verticalSpaceMedium,
                    ElevatedButtonWidget.primaryCustom(
                        onPressed: () async {
                          await BottomSheetDialog.showDraggableSheet(context,
                              child: BottomSheetWithActions(
                                title: ("review").tr() +
                                    " " +
                                    (widget.facilityName ?? ""),
                                body: FacilityRatingScreen(),
                              ));
                        },
                        text: ("review").tr()),
                    Constants.verticalSpaceSmall,
                    ElevatedButtonWidget.primaryCustomBorder(
                        onPressed: () {
                          widget.onIncidentScreen();
                        },
                        color: Color(0xffDC2828),
                        text: ("submit_incident_facility").tr()),
                    Constants.verticalSpaceSmall,
                    DrawLineWidget(
                        lineColor:
                            AppColor.black200.withOpacity(0.2000000029802322)),
                    CustomTextButtonWithIconWidget(
                      btnPressed: () {
                        NavigationService.navigatorKey.currentState!
                            .pushNamed(RouteName.qrFacilityScreenRoute);
                      },
                      icon: RotatedBox(
                        quarterTurns: CommonFunctions.isAppAR ? 0 : 2,
                        child: Image.asset(
                          IconPath.qrbackIconIcon,
                          height: 18,
                          width: 18,
                        ),
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
      ),
    );
  }
}
