import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_cancel/presentation/submit_application_successfully_cancel/mvvm/submit_rating_view_model.dart';
import 'package:balady_plus/app/features/home_page/presentation/widgets/home_app_bar/circle_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

class SubmitRatingSheet extends StatefulWidget {
  const SubmitRatingSheet({super.key});

  @override
  State<SubmitRatingSheet> createState() => _SubmitRatingSheetState();
}

class _SubmitRatingSheetState extends State<SubmitRatingSheet> {
  bool isRedRating = false;
  bool isYellowRating = false;
  int rating = 0;

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SubmitRatingViewModel provider = context.watch<SubmitRatingViewModel>();
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
                  backgroundColor: AppColor.geyser.withOpacity(0.4),
                  iconSize: 18,
                ),
              ),
            ],
          ),
          CustomAutoSizeTextWidget(
            'service_evaluation'.tr(),
            textStyle: AppStyle.profileNameTextStyle.copyWith(
              color: AppColor.blackModern600Light,
            ),
          ),
          const SizedBox(height: 16),
          CustomAutoSizeTextWidget(
            'lbl_choose_star_to_evaluate'.tr(),
            textStyle: AppStyle.profileNameTextStyle.copyWith(
              color: AppColor.blackModern600Light,
            ),
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
              setState(() {
                if (rating <= 2) {
                  isRedRating = true;
                  isYellowRating = false;
                } else if (rating == 3) {
                  isRedRating = false;
                  isYellowRating = true;
                } else if (rating > 3) {
                  isRedRating = false;
                  isYellowRating = false;
                }
                this.rating = rating.toInt();
                // widget.onChangeRate(rating.toInt());
              });
            },
            ratingWidget: RatingWidget(
              full: const Icon(
                Icons.star,
                color: AppColor.golden,
              ),
              half: const Icon(
                Icons.star_half,
                color: AppColor.golden,
              ),
              empty: const Icon(
                Icons.star,
                color: AppColor.black100,
              ),
            ),
            // itemBuilder: (context, index) {
            //   switch (index) {
            //     case 0:
            //       return EtmamRatingRowWidget(0,
            //           isRedRating: isRedRating, isYellowRating: isYellowRating);
            //     case 1:
            //       return EtmamRatingRowWidget(1,
            //           isRedRating: isRedRating, isYellowRating: isYellowRating);
            //     case 2:
            //       return EtmamRatingRowWidget(2,
            //           isRedRating: isRedRating, isYellowRating: isYellowRating);
            //     case 3:
            //       return EtmamRatingRowWidget(3,
            //           isRedRating: isRedRating, isYellowRating: isYellowRating);
            //     case 4:
            //       return EtmamRatingRowWidget(4,
            //           isRedRating: isRedRating, isYellowRating: isYellowRating);
            //     default:
            //       return Container();
            //   }
            // },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              CustomAutoSizeTextWidget(
                'optional_comment'.tr(),
                textStyle: AppStyle.profileNameTextStyle.copyWith(
                  color: AppColor.blackModern600Light,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          CustomTextFieldWidget(
            controller: controller,
            maxLines: 4,
          ),
          const SizedBox(height: 16),
          Selector<SubmitRatingViewModel, bool>(
            selector: (_, provider) => provider.isLoading,
            builder: (context, isLoading, child) {
              return isLoading
                  ? const ShimmerEffectWidget(
                      height: 50,
                      borderRadius: 6,
                    )
                  : ElevatedButtonWidget.primaryCustom(
                      text: 'send_evaluation'.tr(),
                      onPressed: !provider.isLoading
                          ? () async {
                              if (rating > 0) {
                                await provider
                                    .addCommercialLicenseCancelSubmitRating(
                                  rating,
                                  controller.text ?? '',
                                );
                              } else {
                                CommonFunctions.showError('select_rating');
                              }
                            }
                          : () {},
                    );
            },
          ),
          const SizedBox(height: 22),
        ],
      ),
    );
  }
}
