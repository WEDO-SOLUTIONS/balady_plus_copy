import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/utils_exports.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../home_exports.dart';

class ReadHomeCard extends StatelessWidget {
  const ReadHomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        NavigationService.navigatorKey.currentState!.pushNamed(RouteName.menuQuranPage);
      },
      child: HomeSection(
        title: 'read_and_repeat'.tr(),
        child: Container(
          padding: const EdgeInsetsDirectional.only(start: 12, end: 18, top: 16, bottom: 16),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            image: DecorationImage(image: AssetImage(ImagePath.readBg)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                ImagePath.quranImg,
                fit: BoxFit.fill,
                width: 84,
                height: 84,
              ),
              const SizedBox(width: 14),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextWidget(
                      "holy_quran".tr(),
                      fontColor: AppColor.blackModern800Light,
                      fontWeight: AppFontWeight.bold,
                      fontSize: 14,
                    ),
                    SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: EdgeInsetsDirectional.only(end: 80),
                            child: CustomTextWidget(
                              "احمل القرآن بين يديك، تلاوة في أي وقت ومكان.",
                              fontColor: AppColor.blackModern400Light,
                              fontWeight: AppFontWeight.bold,
                              fontSize: 12,
                              maxLines: null,
                              height: 1.5,
                            ),
                          ),
                        ),
                        CustomSvgIconWidget(
                          IconPath.arrowForward2,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
