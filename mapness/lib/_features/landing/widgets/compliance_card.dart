import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';

class ComplianceCard extends ConsumerWidget {
  const ComplianceCard({super.key});

  void createCompliance() {
    Metrics.logEventAdvanced(
      MetricsConstants.layersKeys.complianceOpenCreateCompliance,
      group: MetricsConstants.layersTag,
      action: MetricAction.tap.toString(),
      props: {'id': 'compliance'},
    );

    CommonFunctions.openCreateCompliance();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(RadiusBorder.xl)),
          child: SizedBox(
            height: 237,
            child: ColoredBox(
              color: context.colorsV2.backgroundSurface1,
              child: Padding(
                padding: const EdgeInsets.only(top: Spacing.$5x),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Spacing.$6x),
                      child: Text(
                        context.l10n.complianceCardTitle,
                        style: context.textStyleV3.h4SemiBold,
                      ),
                    ),
                    const SizedBox(height: Spacing.$1x + Spacing.$0_5x),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Spacing.$6x),
                      child: Text(
                        context.l10n.complianceCardDescription,
                        style: context.textStyleV3.captionLargeRegular.copyWith(
                          color: context.colorsV2.foregroundSoft,
                        ),
                      ),
                    ),
                    const SizedBox(height: Spacing.$5x + Spacing.$0_5x),
                    _RowButton(
                      svgImageName: 'sertificate',
                      onTap: createCompliance,
                      label: context.l10n.createCompliance,
                    ),
                    const Divider(height: Spacing.px, indent: 63),
                    _RowButton(
                      svgImageName: 'question',
                      onTap: CommonFunctions.openComplianceFaq,
                      label: context.l10n.complianceFAQ,
                    ),
                    const Divider(height: Spacing.px, indent: 63),
                    _RowButton(
                      svgImageName: 'document',
                      onTap: CommonFunctions.openComplianceTerms,
                      label: context.l10n.complianceRequirements,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}

class _RowButton extends StatelessWidget {
  final String label;
  final String svgImageName;
  final VoidCallback onTap;

  const _RowButton({
    required this.label,
    required this.svgImageName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
        child: Material(
          color: context.colorsV2.backgroundSurface1,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(RadiusBorder.m),
            child: Padding(
              padding: const EdgeInsets.all(Spacing.$2x),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/images_svg/$svgImageName.svg',
                        package: PackageConfig.packageName,
                        height: Spacing.$6x,
                        width: Spacing.$6x,
                      ),
                      const SizedBox(width: Spacing.$4x),
                      Text(label, style: context.textStyleV3.bodySmallRegular),
                    ],
                  ),
                  Icon(
                    /// TODO: fix in uikit, icons not the same as in design.
                    context.isLTR ? SystemIcons.arrowCornerRightSmall : SystemIcons.arrowCornerLeftSmall,
                    color: context.colorsV2.foregroundMuted,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
