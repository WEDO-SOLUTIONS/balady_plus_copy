import 'package:balady_plus/app/core/utils/constants/paths/image_paths.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../core/utils/enums/visual_distortion.dart';
import '../../../_shared_feature_/shared_feature_exports.dart';

class VisualDistortionDetailsScreen extends StatelessWidget {
  VisualDistortionDetailsScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    VisualDistortion visualDistortion =
        ModalRoute.of(context)!.settings.arguments as VisualDistortion;

    return Scaffold(
      appBar: DefaultAppBarWidget(
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColor.primary50Light,
            ),
            child: const CustomSvgIconWidget(
              IconPath.note,
              iconSize: 30,
            ),
          ),
        ],
        title: "visual_distortion".tr(),
      ),
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              ImagePath.visualDistortionFooter,
              width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height / 1.3,
              fit: BoxFit.fill,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Image.asset(
                    ImagePath.grayBg,
                    height: 400,
                    width: MediaQuery.sizeOf(context).width,
                    fit: BoxFit.fill,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Image.asset(
                    ImagePath.whiteBg,
                    height: 400,
                    width: MediaQuery.sizeOf(context).width,
                    fit: BoxFit.fill,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 70),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 420,
                        child: CardSwiper(
                          padding: EdgeInsets.zero,
                          scale: 1,
                          backCardOffset: const Offset(0, 0),
                          numberOfCardsDisplayed: 2,
                          cardsCount: VisualDistortion.values.length,
                          cardBuilder: (_, index, __, ___) => Container(
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(14)),
                              color: AppColor.white,
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 22),
                                CustomTextWidget(
                                  visualDistortion.label,
                                  fontSize: 18,
                                  fontWeight: AppFontWeight.bold,
                                  fontColor: AppColor.primary900Light,
                                ),
                                const SizedBox(height: 16),
                                Stack(
                                  children: [
                                    Image.asset(
                                      index.isEven
                                          ? visualDistortion.badAppearanceImg
                                          : visualDistortion.goodAppearanceImg,
                                      height: 200,
                                      width: MediaQuery.sizeOf(context).width,
                                      fit: BoxFit.fill,
                                    ),
                                    PositionedDirectional(
                                      end: 8,
                                      top: 14,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20)),
                                          color: index.isEven
                                              ? AppColor.blueSkyLight800
                                                  .withOpacity(0.8)
                                              : AppColor.secondary400Light
                                                  .withOpacity(0.8),
                                        ),
                                        child: CustomTextWidget(
                                          index.isEven
                                              ? "visual_distortion_bad".tr()
                                              : "visual_distortion_good".tr(),
                                          fontSize: 12,
                                          fontWeight: AppFontWeight.semiBold,
                                          fontColor: AppColor.white,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Column(
                                    children: [
                                      CustomTextWidget(
                                        index.isEven
                                            ? visualDistortion.badAppearanceDesc
                                            : visualDistortion
                                                .goodAppearanceDesc,
                                        fontSize: 14,
                                        maxLines: 3,
                                        height: 1.5,
                                        fontWeight: AppFontWeight.bold,
                                        fontColor: AppColor.primary900Light,
                                      ),
                                      const SizedBox(height: 6),
                                      CustomTextWidget(
                                        index.isEven
                                            ? visualDistortion
                                                .badAppearanceDesc2
                                            : visualDistortion
                                                .goodAppearanceDesc2,
                                        fontSize: 14,
                                        maxLines: 3,
                                        height: 1.5,
                                        fontWeight: AppFontWeight.semiBold,
                                        fontColor: AppColor.blackModern600Light,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      CustomTextWidget(
                        "scroll_for_more".tr(),
                        fontSize: 12,
                        maxLines: null,
                        textAlign: TextAlign.center,
                        height: 2,
                        fontWeight: AppFontWeight.bold,
                        fontColor: AppColor.secondary200Light,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
