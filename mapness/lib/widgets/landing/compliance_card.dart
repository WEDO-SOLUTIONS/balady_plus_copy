import 'package:balady_plus/app/core/utils/constants/remote_config.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/extensions/string_ext.dart';

class ComplianceCard extends ConsumerWidget {
  const ComplianceCard({super.key});

  void createCompliance() {
    CommonFunctions.openCreateCompliance();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
    child: ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(RadiusBorder.xl)),
      child: ColoredBox(
        color: context.colors.backgroundSurface1,
        child: Padding(
          padding: const EdgeInsets.only(top: Spacing.$5x),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.$6x),
                child: Text(
                  context.l10n.complianceCardTitle,
                  style: context.textStyles.h4SemiBold,
                ),
              ),
              const SizedBox(height: Spacing.$1x + Spacing.$0_5x),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.$6x),
                child: Text(
                  context.l10n.complianceCardDescription.multilines,
                  style: context.textStyles.captionLargeRegular.copyWith(
                    color: context.colors.foregroundSoft,
                  ),
                ),
              ),
              const SizedBox(height: Spacing.$6x - Spacing.$2x),
              _RowButton(
                icon: GeneralIcons.sertificate,
                onTap: createCompliance,
                label: context.l10n.createCompliance,
              ),
              Divider(height: Spacing.px / 2, indent: 63, color: context.colors.borderMuted),
              _RowButton(
                icon: context.isLTR ? GeneralIcons.questionSupportLTR : GeneralIcons.questionSupportRTL,
                onTap: () {
                  if ((RemoteConfig.municipalServicesIDs['create_complianceLocation'] as Map?)?['id']
                      case final String id) {
                    CommonFunctions.openComplianceFaq(id);
                  }
                },
                label: context.l10n.complianceFAQ,
              ),
              Divider(height: Spacing.px / 2, indent: 63, color: context.colors.borderMuted),
              _RowButton(
                icon: GeneralIcons.documentDefenceLTR,
                onTap: CommonFunctions.openComplianceTerms,
                label: context.l10n.complianceRequirements,
              ),
              const SizedBox(height: Spacing.$6x - Spacing.$2x),
            ],
          ),
        ),
      ),
    ),
  );
}

class _RowButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _RowButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
    child: Material(
      color: context.colors.backgroundSurface1,
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
                  Icon(
                    icon,
                    size: Spacing.$6x,
                    color: context.colors.accentDefault,
                  ),
                  const SizedBox(width: Spacing.$4x),
                  Text(label, style: context.textStyles.bodySmallRegular),
                ],
              ),
              Icon(
                SystemIcons.arrowCornerRightSmall,
                color: context.colors.foregroundMuted,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
