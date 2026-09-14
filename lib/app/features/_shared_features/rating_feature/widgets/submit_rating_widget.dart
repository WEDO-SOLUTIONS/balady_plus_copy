import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/_shared_features/rating_feature/models/rating_request.dart';
import 'package:balady_plus/app/features/_shared_features/rating_feature/mvvm/submit_rating_view_model.dart';
import 'package:balady_plus/app/features/home_page/presentation/widgets/home_app_bar/circle_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

class SubmitRatingSheet extends StatelessWidget {
  final RatingRequest ratingRequest;
  final String? title;

  const SubmitRatingSheet({super.key, required this.ratingRequest, this.title});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => SubmitRatingViewModel(webService: sl(), ratingRequest: ratingRequest),
      child: Builder(
        builder: (BuildContext contextViewModel) {
          SubmitRatingViewModel provider = contextViewModel.watch<SubmitRatingViewModel>();
          return Padding(
            padding: const EdgeInsets.all(16.0),
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
                      onTap: () => Navigator.pop(context),
                      child: CircleIcon(
                        icon: Icons.close,
                        iconColor: AppColor.primary600Light,
                        backgroundColor: AppColor.geyser.withValues(alpha: 0.4),
                        iconSize: 18,
                      ),
                    ),
                  ],
                ),
                CustomAutoSizeTextWidget(
                  title ?? 'service_evaluation'.tr(),
                  textStyle: AppStyle.profileNameTextStyle.copyWith(color: AppColor.blackModern600Light),
                ),
                const SizedBox(height: 16),
                CustomAutoSizeTextWidget(
                  'lbl_choose_star_to_evaluate'.tr(),
                  textStyle: AppStyle.profileNameTextStyle.copyWith(color: AppColor.blackModern600Light),
                ),
                const SizedBox(height: 16),
                RatingBar(
                  unratedColor: AppColor.black200,
                  glow: false,
                  minRating: 1,
                  itemSize: 48,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 5.0),
                  maxRating: 5,
                  initialRating: 0.0,
                  itemCount: 5,
                  onRatingUpdate: (rating) {
                    provider.ratingRequest.value = rating.toInt();
                  },
                  ratingWidget: RatingWidget(
                    full: const Icon(Icons.star, color: AppColor.golden),
                    half: const Icon(Icons.star_half, color: AppColor.golden),
                    empty: const Icon(Icons.star, color: AppColor.black100),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    CustomAutoSizeTextWidget(
                      'optional_comment'.tr(),
                      textStyle: AppStyle.profileNameTextStyle.copyWith(color: AppColor.blackModern600Light),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                CustomTextFieldWidget(onChanged: (text) => provider.ratingRequest.remarks = text, maxLines: 4),
                const SizedBox(height: 16),
                Selector<SubmitRatingViewModel, bool>(
                  selector: (_, provider) => provider.isLoading,
                  builder: (contextViewModel, isLoading, child) {
                    return isLoading
                        ? const ShimmerEffectWidget(height: 50, borderRadius: 6)
                        : ElevatedButtonWidget.primaryCustom(
                            text: 'send_evaluation'.tr(),
                            onPressed: () async {
                              if ((provider.ratingRequest.value ?? 0) > 0) {
                                NavigatorState navigator = Navigator.of(context);
                                int? id = await provider.submitRating();
                                if (id != null) {
                                  navigator.pop(true);
                                  CommonFunctions.showSuccess("done_send_rating".tr());
                                }
                              } else {
                                CommonFunctions.showError('select_rating'.tr());
                              }
                            },
                          );
                  },
                ),
                const SizedBox(height: 22),
              ],
            ),
          );
        },
      ),
    );
  }
}
