import 'package:balady_plus/app/core/utils/constants/paths/image_paths.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../core/utils/enums/visual_distortion.dart';
import '../../../_shared_feature_/shared_feature_exports.dart';

class VisualDistortionScreen extends StatelessWidget {
  const VisualDistortionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              height: MediaQuery.sizeOf(context).height / 1.4,
              fit: BoxFit.fill,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.sizeOf(context).height / 4,
              right: 34,
              left: 34,
            ),
            child: Column(
              children: [
                Expanded(
                  child: CardSwiper(
                    padding: EdgeInsets.zero,
                    scale: 1,
                    backCardOffset: const Offset(0, -60),
                    numberOfCardsDisplayed: 5,
                    cardsCount: VisualDistortion.values.length,
                    cardBuilder: (_, index, __, ___) => GestureDetector(
                      onTap: () => context.pushNamedRoute(
                        RouteName.visualDistortionDetailsPage,
                        arguments: VisualDistortion.values[index],
                      ),
                      child: Center(
                        child: Image.asset(
                          VisualDistortion.values[index].cardImg,
                          height: 242,
                          width: MediaQuery.sizeOf(context).width,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
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
