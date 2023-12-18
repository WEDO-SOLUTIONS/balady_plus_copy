import 'dart:ui';

import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mapness/shared/config/package_config.dart';

class ComplianceCard extends StatelessWidget {
  const ComplianceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
      ),
      child: Container(
        height: 215,
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: 12,
        ),
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage(
              'assets/images/compliance_card.png',
              package: PackageConfig.packageName,
            ),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "خريطة شهادة الإمتثال",
                        style: Theme.of(context)
                            .extension<ThemeTextStyles>()!
                            .accentS
                            .copyWith(
                              color: Colors.white,
                            ),
                      ),
                      Text(
                        "تعرف على الطرق المستهدفة لتطبيق شهادة الامتثال من خلال الخريطة ",
                        style: Theme.of(context)
                            .extension<ThemeTextStyles>()!
                            .textXS
                            .copyWith(
                              color: Colors.white.withOpacity(0.8),
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 60,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(37),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: SvgPicture.asset(
                    'assets/icons/svg/ic_bug.svg',
                    width: 24,
                    height: 24,
                    package: PackageConfig.packageName,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 14,
            ),
            Column(
              children: [
                Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    onTap: () {
                      CommonFunctions.openCreateCompliance();
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 9,
                        horizontal: 12,
                      ),
                      child: Text(
                        'أصدر الشهادة',
                        style: Theme.of(context)
                            .extension<ThemeTextStyles>()
                            ?.accentM
                            .copyWith(
                              color: const Color(0xFF4CA5B4),
                            ),
                      ),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    onTap: () {
                      CommonFunctions.openRatingBuilding();
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 9,
                      ),
                      child: Text(
                        'أو قيم مبناك',
                        style: Theme.of(context)
                            .extension<ThemeTextStyles>()
                            ?.textS
                            .copyWith(
                              color: Colors.white,
                            ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaY: 7.5,
                  sigmaX: 7.5,
                ),
                child: Container(
                  color: Colors.white.withOpacity(0.8),
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 12,
                  ),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "لمعرفه المزيد اطلع على",
                          style: Theme.of(context)
                              .extension<ThemeTextStyles>()
                              ?.textS
                              .copyWith(
                                color: const Color(0xFF4CA5B4).withOpacity(0.7),
                                fontSize: 11,
                              ),
                        ),
                        TextSpan(
                          text: " ",
                          style: Theme.of(context)
                              .extension<ThemeTextStyles>()
                              ?.textS
                              .copyWith(
                                color: const Color(0xFF4CA5B4).withOpacity(0.7),
                                fontSize: 11,
                              ),
                        ),
                        TextSpan(
                          text: "الاسئلة الشائعة",
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              CommonFunctions.openComplianceFaq();
                            },
                          style: Theme.of(context)
                              .extension<ThemeTextStyles>()
                              ?.textS
                              .copyWith(
                                color: const Color(0xFF4CA5B4),
                                fontSize: 12,
                              ),
                        ),
                        TextSpan(
                          text: " ",
                          style: Theme.of(context)
                              .extension<ThemeTextStyles>()
                              ?.textS
                              .copyWith(
                                color: const Color(0xFF4CA5B4).withOpacity(0.7),
                                fontSize: 11,
                              ),
                        ),
                        TextSpan(
                          text: "أو",
                          style: Theme.of(context)
                              .extension<ThemeTextStyles>()
                              ?.textS
                              .copyWith(
                                color: const Color(0xFF4CA5B4).withOpacity(0.7),
                                fontSize: 11,
                              ),
                        ),
                        TextSpan(
                          text: " ",
                          style: Theme.of(context)
                              .extension<ThemeTextStyles>()
                              ?.textS
                              .copyWith(
                                color: const Color(0xFF4CA5B4).withOpacity(0.7),
                                fontSize: 11,
                              ),
                        ),
                        TextSpan(
                          text: "الاشتراطات",
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              CommonFunctions.openComplianceTerms();
                            },
                          style: Theme.of(context)
                              .extension<ThemeTextStyles>()
                              ?.textS
                              .copyWith(
                                color: const Color(0xFF4CA5B4),
                                fontSize: 12,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
