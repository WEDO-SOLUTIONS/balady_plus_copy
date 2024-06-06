import 'dart:math' as math;

import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_uikit/core/colors/app_color_scheme.dart';
import 'package:balady_uikit/core/typography/text_theme_styles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mapness/_features/common/providers/color_scheme.dart';
import 'package:mapness/_features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/_features/lifestyle_layers/providers/layers_state.dart';
import 'package:mapness/app/routes/esri_layers.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';

class ComplianceCard extends ConsumerWidget {
  const ComplianceCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Padding(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 12,
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          child: SizedBox(
            height: 230,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Directionality.of(context) == TextDirection.ltr
                        ? Matrix4.rotationY(math.pi)
                        : Matrix4.rotationY(0),
                    child: Image.asset(
                      ref.read(colorSchemeProvider) == AppColorScheme.brown
                          ? 'assets/images/compliance_card_brown.png'
                          : 'assets/images/compliance_card.png',
                      package: PackageConfig.packageName,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 20,
                    bottom: 12,
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
                                      .footNoteBold
                                      .copyWith(
                                        color: Colors.white,
                                      ),
                                ),
                                Text(
                                  context.l10n.complianceCardDescription,
                                  style: Theme.of(context)
                                      .extension<ThemeTextStyles>()!
                                      .caption
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
                          GestureDetector(
                            onTap: () {
                              Metrics.logEventAdvanced(
                                MetricsConstants
                                    .layersKeys.complianceOpenCompliance,
                                group: MetricsConstants.layersTag,
                                action: MetricAction.tap.toString(),
                                props: {'id': 'compliance'},
                              );

                              EsriLayersRoute.open(context);
                              ref
                                  .read(layersControlsProvider.notifier)
                                  .handleTap(LayerType.buildings);
                            },
                            child: Container(
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
                                colorFilter: ColorFilter.mode(
                                  context.color.textAndIconsStatusAccent,
                                  BlendMode.srcATop,
                                ),
                              ),
                            ),
                          ),
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
                            Metrics.logEventAdvanced(
                              MetricsConstants
                                  .layersKeys.complianceOpenCreateCompliance,
                              group: MetricsConstants.layersTag,
                              action: MetricAction.tap.toString(),
                              props: {'id': 'compliance'},
                            );

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
                                  ?.callout
                                  .copyWith(
                                    color: context.color.strokeAccent,
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
                            Metrics.logEventAdvanced(
                              MetricsConstants
                                  .layersKeys.complianceOpenRatingBuilding,
                              group: MetricsConstants.layersTag,
                              action: MetricAction.tap.toString(),
                              props: {'id': 'compliance'},
                            );

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
                                  ?.footNote
                                  .copyWith(
                                    color: Colors.white,
                                  ),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: context.l10n.complianceToKnow,
                                style: Theme.of(context)
                                    .extension<ThemeTextStyles>()
                                    ?.footNote
                                    .copyWith(
                                      color: context.color.strokeAccent
                                          .withOpacity(0.7),
                                      fontSize: 11,
                                    ),
                              ),
                              TextSpan(
                                text: ' ',
                                style: Theme.of(context)
                                    .extension<ThemeTextStyles>()
                                    ?.footNote
                                    .copyWith(
                                      color: context.color.strokeAccent
                                          .withOpacity(0.7),
                                      fontSize: 11,
                                    ),
                              ),
                              TextSpan(
                                text: context.l10n.complianceFAQ,
                                recognizer: TapGestureRecognizer()
                                  ..onTap = CommonFunctions.openComplianceFaq,
                                style: Theme.of(context)
                                    .extension<ThemeTextStyles>()
                                    ?.footNote
                                    .copyWith(
                                      color: context.color.strokeAccent,
                                      fontSize: 12,
                                    ),
                              ),
                              TextSpan(
                                text: ' ',
                                style: Theme.of(context)
                                    .extension<ThemeTextStyles>()
                                    ?.footNote
                                    .copyWith(
                                      color: context.color.strokeAccent
                                          .withOpacity(0.7),
                                      fontSize: 11,
                                    ),
                              ),
                              TextSpan(
                                text: context.l10n.complianceOr,
                                style: Theme.of(context)
                                    .extension<ThemeTextStyles>()
                                    ?.footNote
                                    .copyWith(
                                      color: context.color.strokeAccent
                                          .withOpacity(0.7),
                                      fontSize: 11,
                                    ),
                              ),
                              TextSpan(
                                text: ' ',
                                style: Theme.of(context)
                                    .extension<ThemeTextStyles>()
                                    ?.footNote
                                    .copyWith(
                                      color: context.color.strokeAccent
                                          .withOpacity(0.7),
                                      fontSize: 11,
                                    ),
                              ),
                              TextSpan(
                                text: context.l10n.complianceRequirements,
                                recognizer: TapGestureRecognizer()
                                  ..onTap = CommonFunctions.openComplianceTerms,
                                style: Theme.of(context)
                                    .extension<ThemeTextStyles>()
                                    ?.footNote
                                    .copyWith(
                                      color: context.color.strokeAccent,
                                      fontSize: 12,
                                    ),
                              ),
                            ],
                          ),
                        ),
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
