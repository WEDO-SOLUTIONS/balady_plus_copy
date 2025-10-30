import 'package:balady_plus/app/features/_shared_features/rating_feature/models/rating_request.dart';
import 'package:balady_plus/app/features/_shared_features/rating_feature/widgets/submit_rating_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/commercial_model/commercial_routes/commercial_route_names.dart';
import '../../../../../../features/_shared_feature_/balady_features/widgets/shared/circle_icon.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/draw_icon_based_type_widget.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';

class SucessfullScreen extends StatefulWidget {
  SucessfullScreen({Key? key}) : super(key: key);

  @override
  State<SucessfullScreen> createState() => _SucessfullScreenState();
}

class _SucessfullScreenState extends State<SucessfullScreen> {
  String? requestId;
  bool isfromRequest = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context)!.settings.arguments as Map;
    requestId = data['requestId'];
    isfromRequest = data['isFromRequest'];
    return Scaffold(body: getBody());
  }

  Widget getBody() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15),
      child: Stack(children: [
        Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const DrawIconBasedTypeWidget(
                    icon: IconPath.successfullIcon,
                    iconSize: 120,
                  ),
                  CustomTextWidget(
                    "vd_request_submit".tr(),
                    textStyle: AppStyle.complianceTitleStyle,
                    textAlign: TextAlign.center,
                    maxLines: 4,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    isfromRequest == true
                        ? "${"request_number".tr()} $requestId ${"follow_request".tr()}"
                        : 'transfer_Complete'.tr(),
                    style: AppStyle.personalInfoParameterValueTextStyle
                        .copyWith(fontSize: 12, height: 1.5),
                  ),
                  CustomElevatedButtonWidget(
                    btnColor: Colors.transparent,
                    textStyle: AppStyle.elevatedButtonStyle.copyWith(
                      color: AppColor.blueSkyLight800,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                    btnHeight: 56,
                    text: "service_evaluation".tr(),
                    onPressed: () {
                      BottomSheetDialog.showSheet(
                        context,
                        child: SubmitRatingSheet(
                          title: 'service_evaluation'.tr(),
                          ratingRequest: RatingRequest(
                            requestId: int.parse(requestId!),
                          ),
                        ),
                        isFullHeight: false,
                        isScrollControlled: true,
                        backgroundColor: Colors.white,
                        height: MediaQuery.of(context).size.height * 0.6,
                      );
                    },
                  ),
                  const Spacer(),
                  CustomElevatedButtonWidget(
                    btnColor: Colors.transparent,
                    textStyle: AppStyle.elevatedButtonStyle.copyWith(
                      color: AppColor.blueSkyLight800,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                    btnBorderColor: AppColor.blueSkyLight800,
                    btnHeight: 56,
                    text: "show_request".tr(),
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        CommercialRouteName.requestOwnershipTransferDetailsPage,
                        arguments: {
                          "requestNumber": requestId,
                          "isReadonly": true
                        },
                      );
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomElevatedButtonWidget(
                    btnColor: AppColor.blueSkyLight800,
                    textStyle: AppStyle.elevatedButtonStyle.copyWith(
                      color: AppColor.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                    btnHeight: 56,
                    text: isfromRequest
                        ? "go_to_license".tr()
                        : "go_to_request".tr(),
                    onPressed: () {
                      if (isfromRequest == true) {
                        Navigator.popUntil(
                          context,
                          ModalRoute.withName(CommercialRouteName.licenses),
                        );
                      } else {
                        Navigator.popUntil(
                          context,
                          ModalRoute.withName(CommercialRouteName.requests),
                        );
                      }
                    },
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          left: 5,
          top: 70,
          child: Padding(
            padding: const EdgeInsetsDirectional.only(end: 10),
            child: InkWell(
              onTap: () {
                if (isfromRequest == true) {
                  Navigator.popUntil(
                    context,
                    ModalRoute.withName(CommercialRouteName.licenses),
                  );
                } else {
                  Navigator.popUntil(
                    context,
                    ModalRoute.withName(CommercialRouteName.requests),
                  );
                }
              },
              child: CircleIcon(
                icon: Icons.close,
                iconColor: AppColor.primary600Light,
                backgroundColor: AppColor.geyser.withOpacity(0.4),
                iconSize: 18,
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
