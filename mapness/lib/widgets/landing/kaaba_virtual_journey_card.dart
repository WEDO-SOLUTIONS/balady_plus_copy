import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/gaussian_splatting/gaussian_splatting_entry_point_card.dart';

class KaabaVirtualJourneyCard extends StatelessWidget {
  final VoidCallback? onTap;

  const KaabaVirtualJourneyCard({this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GaussianSplattingEntryPointCard(
      path: 'assets/images/gaussian_splatting_entry_point.png',
      onTap: onTap,
      gradientColors: const [Color(0xFF014850), Color(0xFF00343A)],
      title: context.l10n.kaabaVirtualJourneyTitle,
      subtitle: context.l10n.kaabaVirtualJourneySubtitle,
      buttonText: context.l10n.kaabaVirtualJourneyButton,
    );
  }
}
