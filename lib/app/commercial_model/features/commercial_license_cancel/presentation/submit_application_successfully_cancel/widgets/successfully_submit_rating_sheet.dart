import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/services/local/helpers.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/commercial_model/commercial_routes/commercial_route_names.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_cancel/presentation/submit_application_successfully_cancel/mvvm/submit_rating_view_model.dart';
import 'package:balady_plus/app/features/home_page/presentation/widgets/home_app_bar/circle_icon.dart';
import 'package:balady_plus/app/commercial_model/features/request_commercial_license_details/data/data_sources/remote_data_source.dart';
import 'package:balady_plus/app/commercial_model/features/request_commercial_license_details/data/repositories/repository_implementation.dart';
import 'package:balady_plus/app/commercial_model/features/request_commercial_license_details/domain/use_cases/get_request_commercial_license_details.dart';
import 'package:balady_plus/app/commercial_model/features/request_commercial_license_details/presentation/bloc/request_commercial_license_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

class SuccessfullySubmitRatingSheet extends StatelessWidget {
  const SuccessfullySubmitRatingSheet({super.key});

  @override
  Widget build(BuildContext context) {
    SubmitRatingViewModel provider = context.watch<SubmitRatingViewModel>();
    return Padding(
      padding: const EdgeInsets.all(22.0),
      child: Column(
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
                onTap: () {
                  Helpers.backNavigationToHomeScreen();
                },
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
            textStyle: AppStyle.complianceSubtitle.copyWith(),
          ),
          const SizedBox(height: 16),
          if (provider.showDetails == true)
            ElevatedButtonWidget.primaryCustom(
              text: 'return_order_details'.tr(),
              onPressed: () {
                // go to home Page
                // bool Function(Route<dynamic>) predicate =
                // ModalRoute.withName(CommercialRouteName.bottomNavigation);
                // NavigationService.navigatorKey.currentState!.popUntil((predicate));
                // Helpers.backNavigationToHomeScreen();
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(
                  context,
                  CommercialRouteName.requestCommercialLicenseDetails,
                  arguments: {
                    "requestNumber": provider.submitResponse.requestId.toString()
                  },
                );
              },
            ),
          const SizedBox(height: 22),
        ],
      ),
    );
  }
}
