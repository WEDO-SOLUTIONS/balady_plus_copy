import 'package:flutter/material.dart';
import 'package:mapness/features/ai_summary/ui/_preview_fixtures.dart';
import 'package:mapness/features/ai_summary/ui/ai_summary_strings.dart';
import 'package:mapness/features/ai_summary/ui/ai_summary_tokens.dart';
import 'package:mapness/shared/providers/app_language.dart';

/// "Available Lines" section with colored pill-shaped badges
/// for each transit line that serves a bus/metro station POI.
///
/// Headsigns (e.g. `→ Ajyad`) are rendered in English mode but
/// deliberately hidden in Arabic mode, because the upstream
/// data source returns headsigns in English regardless of the
/// requested locale, and showing English text inside an
/// otherwise fully Arabic card creates a jarring mixed-language
/// experience.
class AiSummaryTransitBadges extends StatelessWidget {
  final List<PreviewTransitLine> lines;
  final Language language;

  const AiSummaryTransitBadges({
    required this.lines,
    required this.language,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (lines.isEmpty) {
      return const SizedBox.shrink();
    }

    final strings = AiSummaryStrings(language);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(strings.availableLines, style: AiSummaryTokens.transitSectionLabelStyle),
        const SizedBox(height: AiSummaryTokens.transitBadgeGap),
        Wrap(
          spacing: AiSummaryTokens.transitBadgeGap,
          runSpacing: AiSummaryTokens.transitBadgeGap,
          children: [
            for (final line in lines)
              _TransitLineBadge(line: line, showHeadsign: language.isEnglish),
          ],
        ),
      ],
    );
  }
}

class _TransitLineBadge extends StatelessWidget {
  final PreviewTransitLine line;
  final bool showHeadsign;

  const _TransitLineBadge({required this.line, required this.showHeadsign});

  @override
  Widget build(BuildContext context) {
    final text = showHeadsign && line.headsign != null
        ? '${line.shortName} → ${line.headsign}'
        : line.shortName;

    return Container(
      padding: AiSummaryTokens.transitBadgePadding,
      decoration: BoxDecoration(
        color: colorFromArgb(line.colorArgb),
        borderRadius: BorderRadius.circular(AiSummaryTokens.transitBadgeBorderRadius),
      ),
      child: Text(text, style: AiSummaryTokens.transitBadgeTextStyle),
    );
  }
}
