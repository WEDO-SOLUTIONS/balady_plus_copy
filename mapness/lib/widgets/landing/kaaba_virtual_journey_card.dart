import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/special_themes/modes/mekkah_base/makkah_poi_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:mapness/shared/ui/gaussian_splatting/gaussian_splatting_entry_point_card.dart';

class KaabaVirtualJourneyCard extends ConsumerWidget {
  final VoidCallback? onTap;

  const KaabaVirtualJourneyCard({this.onTap, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(darkModeProvider).value?.isDark ?? false;
    return GaussianSplattingEntryPointCard(
      path: isDark
          ? 'assets/images/gaussian_splatting_entry_point_dark.png'
          : 'assets/images/gaussian_splatting_entry_point.png',
      onTap: onTap,
      gradientColors: const [Color(0xFF014850), Color(0xFF00343A)],
      title: context.l10n.kaabaVirtualJourneyTitle,
      subtitle: context.l10n.kaabaVirtualJourneySubtitle,
      buttonText: context.l10n.kaabaVirtualJourneyButton,
      titleColor: isDark ? const Color(0xFFFFFFFF) : null,
      subtitleColor: isDark ? const Color(0xFFFFFFFF).withOpacity(0.8) : null,
      ctaBackground: isDark ? MakkahPoiConstants.darkSheet : null,
      ctaTextColor: isDark ? MakkahPoiConstants.darkMutedSlate : null,
    );
  }
}
