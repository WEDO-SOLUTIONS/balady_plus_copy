import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/components/bottom_sheets/bottom_sheet_with_actions.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/home_page/presentation/widgets/home_app_bar/circle_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class SuccessfullySubmitRatingSheet extends StatelessWidget {
  const SuccessfullySubmitRatingSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomSheetWithActions(
      title: "",
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const DrawLineWidget(
            lineWidth: 70.0,
            lineHeight: 6.0,
            lineColor: AppColor.blackModern200Light,
            radius: 46.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () => Navigator.pop(context),
                child: CircleIcon(
                  icon: Icons.close,
                  iconColor: AppColor.primary600Light,
                  backgroundColor: AppColor.geyser.withOpacity(0.4),
                  iconSize: 18,
                ),
              ),
            ],
          ),
          SvgPicture.asset(IconPath.successfullySubmitRating),
          CustomAutoSizeTextWidget(
            'lbl_thank_you'.tr(),
            textStyle: AppStyle.profileNameTextStyle.copyWith(
              color: AppColor.blackModern600Light,
            ),
          ),
          const SizedBox(height: 16),
          CustomAutoSizeTextWidget(
            'done_send_rating'.tr(),
            textStyle: AppStyle.profileNameTextStyle.copyWith(
              color: AppColor.blackModern600Light,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButtonWidget.primaryCustomBorder(
            text: 'return_home_page'.tr(),
            onPressed: () {
              // go to home Page
              bool Function(Route<dynamic>) predicate =
                  ModalRoute.withName(RouteName.bottomNavigation);
              NavigationService.navigatorKey.currentState!
                  .pushNamedAndRemoveUntil(
                RouteName.etmamMainPageCitySelector,
                predicate,
              );
            },
          ),
        ],
      ),
    );
  }
}
