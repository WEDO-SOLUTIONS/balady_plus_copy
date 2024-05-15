import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_uikit/core/colors/app_color_scheme.dart';
import 'package:balady_uikit/core/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/color_scheme.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/ui/buttons/labeled_elevated_button.dart';

class SnapAndSendCard extends ConsumerWidget {
  const SnapAndSendCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.contributedToImproving,
              style: Theme.of(context)
                  .extension<ThemeTextStyles>()!
                  .heading2
                  .copyWith(
                    color: context.color.textAndIconsBasePrimary,
                  ),
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
              height: 189,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage(
                    ref.read(colorSchemeProvider) == AppColorScheme.brown
                        ? 'assets/images/snap_and_send_card_brown.png'
                        : 'assets/images/snap_and_send_card.png',
                    package: PackageConfig.packageName,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            context.l10n.snapAndSendTitle,
                            style: Theme.of(context)
                                .extension<ThemeTextStyles>()!
                                .heading2
                                .apply(color: Colors.white),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            context.l10n.snapAndSendDescription,
                            maxLines: 3,
                            style: Theme.of(context)
                                .extension<ThemeTextStyles>()!
                                .caption
                                .apply(color: Colors.white),
                          ),
                          const SizedBox(
                            height: 23,
                          ),
                          LabeledElevatedButton(
                            textColor: context.color.textAndIconsStatusAccent,
                            backgroundColor: context.color.surfaceBasePrimary,
                            label: context.l10n.snapAndSendButton,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            onPressed: () {
                              Metrics.logEventAdvanced(
                                  MetricsConstants.exploreKeys
                                      .enhanceUrbanSceneBannerButton,
                                  action: MetricAction.tap.name,
                                  group: MetricsConstants.exploreTag);

                              CommonFunctions.openSnapAndSend();
                            },
                          ),
                        ],
                      ),
                    ),
                    Image.asset(
                      ref.read(colorSchemeProvider) == AppColorScheme.brown
                          ? 'assets/images/snap_and_send_phone_brown.png'
                          : 'assets/images/snap_and_send_phone.png',
                      package: PackageConfig.packageName,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}
