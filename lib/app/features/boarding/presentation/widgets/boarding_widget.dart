import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/constants/paths/image_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class BoardingWidget extends StatelessWidget {
  const BoardingWidget({
    super.key,
    required this.title,
    required this.phoneDisplay,
    required this.subtitle,
  });
  final String title;
  final String subtitle;
  final String phoneDisplay;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: 440,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage(
                    ImagePath.boardingRiyadhImage,
                  ),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      AppColor.athkarAppbarGreen.withOpacity(0.25),
                      BlendMode.luminosity),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                phoneDisplay,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 30,
              right: 18,
              child: Text(
                'skip'.tr(),
                style: AppStyle.boardingAppBarTitleStyle,
              ),
            ),
          ],
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(
              16,
            ),
            decoration: const BoxDecoration(
              color: AppColor.white,
            ),
            child: Column(children: [
              CustomTextWidget(
                title,
                textStyle: AppStyle.boardingTitle,
              ),
              const SizedBox(
                height: 12,
              ),
              CustomTextWidget(
                subtitle,
                textStyle: AppStyle.boardingSubtitle,
                maxLines: 3,
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
              ),
              const SizedBox(
                height: 20,
              ),
            ]),
          ),
        )
      ],
    );
  }
}

//
