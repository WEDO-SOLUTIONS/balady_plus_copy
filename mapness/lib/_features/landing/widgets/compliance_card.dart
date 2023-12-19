import 'dart:ui';

import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

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
                        context.l10n.complianceCardTitle,
                        style: Theme.of(context)
                            .extension<ThemeTextStyles>()!
                            .accentS
                            .copyWith(
                              color: Colors.white,
                            ),
                      ),
                      Text(
                        context.l10n.complianceCardDescription,
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
                  width: 40,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(37),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: SvgPicture.asset(
                    'assets/icons/svg/ic_compliance.svg',
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
                    context.l10n.createCompliance,
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
                    context.l10n.ratingBuilding,
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
                          text: context.l10n.complianceToKnow,
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
                          text: context.l10n.complianceFAQ,
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
                          text: context.l10n.complianceOr,
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
                          text: context.l10n.complianceRequirements,
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
