import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/services/local/navigation_services.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../core/utils/constants/paths/image_paths.dart';
import '../../../../core/utils/constants/route_names.dart';
import '../../../../core/utils/enums/app_font_weights.dart';
import '../../../_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

class NonComplianceScreen extends StatelessWidget {
  const NonComplianceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: null,
        body: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(ImagePath.successPageBackground),
                    fit: BoxFit.cover)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                /*Container(
                  margin: EdgeInsetsDirectional.only(
                      top: MediaQuery.of(context).padding.top + 10, start: 16),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Image.asset(
                      IconPath.qrWhiteCloseIcon,
                      height: 20.0,
                      width: 20.0,
                      color: Colors.black,
                    ),
                  ),
                ),*/
                Container(
                  margin: EdgeInsetsDirectional.only(
                      top: MediaQuery.of(context).padding.top + 10, start: 16),
                  child: CustomTextIconButtonWidget(
                    text: ('back').tr(),
                    icon: SvgPicture.asset(IconPath.vdAppBarBack),
                    iconTextTweenSpace: 5,
                    textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColor.blackModern700Light,
                        fontFamily: Constants.appFontType),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Image.asset(
                            ImagePath.nonCompliance,
                            height: 137,
                            width: 239,
                          ),
                          const CustomVerticalSpace(
                            height: 26,
                          ),
                          CustomTextWidget(
                            "request_cannot_be_completed".tr(),
                            fontSize: 22,
                            fontWeight: AppFontWeight.bold,
                            fontColor: AppColor.black,
                            maxLines: 10,
                          ),
                          const CustomVerticalSpace(
                            height: 20,
                          ),
                          CustomTextWidget(
                            "building_must_be_compliance".tr(),
                            fontSize: 16,
                            fontWeight: AppFontWeight.medium,
                            fontColor: AppColor.black500,
                            height: 1.6,
                            maxLines: 10,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: Container(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Column(
                      children: [
                        ElevatedButtonWidget.primaryCustomBorder(
                            onPressed: () {
                              bool Function(Route<dynamic>) predicate =
                                  ModalRoute.withName(
                                      RouteName.bottomNavigation);
                              NavigationService.navigatorKey.currentState!
                                  .pushNamedAndRemoveUntil(
                                      RouteName.selfRatingMainPage, predicate);
                            },
                            text: "move_to_building_rate_service".tr()),
                        const CustomVerticalSpace(
                          height: 16,
                        ),
                        ElevatedButtonWidget.primaryCustom(
                            onPressed: () {
                              bool Function(Route<dynamic>) predicate =
                                  ModalRoute.withName(
                                      RouteName.bottomNavigation);
                              NavigationService.navigatorKey.currentState!
                                  .popUntil((predicate));
                            },
                            text: "return_to_services_page".tr()),
                      ],
                    ),
                  ),
                )
              ],
            )));
  }
}
