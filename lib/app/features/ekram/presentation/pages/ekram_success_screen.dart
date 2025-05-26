import 'package:balady_plus/app/app.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/ekram/data/model/driver/transport_request_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:balady_plus/app/features/_shared_features/rating_feature/widgets/submit_rating_widget.dart';
import 'package:smart_advisor/app/core/services/local/navigation_services.dart';

import '../../../../../etmam_app/core/utils/constants/app_config.dart';
import '../../../../../etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/app_style.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import '../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/draw_icon_based_type_widget.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../_shared_features/rating_feature/models/rating_request.dart';

class EkramSuccessPage extends StatefulWidget {
  const EkramSuccessPage({Key? key}) : super(key: key);

  @override
  State<EkramSuccessPage> createState() => _EkramSuccessPageState();
}

class _EkramSuccessPageState extends State<EkramSuccessPage> {
  @override
  Widget build(BuildContext context) {
    String? msg = ModalRoute.of(context)!.settings.arguments as String?;
    return Scaffold(body: getBody(msg));

    //   Scaffold(
    //   body: Container(
    //     margin: EdgeInsets.only(
    //         right: 16,
    //         left: 16,
    //         top: MediaQuery.of(context).padding.top + 10,
    //         bottom: 30),
    //     color: AppColor.white,
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: <Widget>[
    //         GestureDetector(
    //           onTap: () {
    //             Navigator.of(context).pop();
    //           },
    //           child: Image.asset(
    //             Constants.whiteCloseImg,
    //             height: 20.0,
    //             width: 20.0,
    //             color: Colors.black,
    //           ),
    //         ),
    //         Expanded(
    //           child: Container(
    //             width: double.infinity,
    //             margin: EdgeInsets.symmetric(horizontal: 14),
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               mainAxisSize: MainAxisSize.min,
    //               children: [
    //                 SvgPicture.asset("assets/icons/ekram_success.svg"),
    //                 CustomVerticalSpace(height: 32),
    //                 CustomTextWidget(
    //                   trans('successEkramTitle'),
    //                   fontSize: 22,
    //                   fontWeight: AppFontWeight.bold,
    //                   fontColor: AppColor.black,
    //                 ),
    //                 CustomVerticalSpace(height: 12),
    //                 CustomTextWidget(
    //                   msg ?? "${"request_number".tr()}", //.replaceAll("_", "3276547326"),
    //                   fontSize: 16,
    //                   fontWeight: AppFontWeight.medium,
    //                   fontColor: AppColor.black500,
    //                   height: 1.4,
    //                 ),
    //                 CustomVerticalSpace(height: 32),
    //               ],
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }

  Widget getBody(String? requestId) {
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
                    "${"request_number".tr()} $requestId ${"follow_request".tr()}",
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
                          RouteName.driverEkramTransportationDetailsScreen,
                          arguments: TransportRequestItemModel(
                              requestId: int.parse(requestId!)));
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
                    text: "go_to_request".tr(),
                    onPressed: () {
                      Navigator.popUntil(
                        context,
                        ModalRoute.withName(
                            RouteName.ekramTransportationListScreen),
                      );
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
      ]),
    );
  }
}
