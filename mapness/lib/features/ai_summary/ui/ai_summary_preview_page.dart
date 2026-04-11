import 'package:flutter/material.dart';
import 'package:mapness/features/ai_summary/ui/_preview_fixtures.dart';
import 'package:mapness/features/ai_summary/ui/ai_summary_card.dart';
import 'package:mapness/shared/providers/app_language.dart';

/// Debug-only visual gallery for the AI Summary card.
///
/// Renders every fixture variant (EN/AR × regular/transit/
/// short/long, with and without rating) plus the skeleton
/// state, side-by-side in one scrollable screen so the card
/// can be visually iterated on without hunting through real
/// POIs on the map.
///
/// This page is NOT wired into the production navigation
/// graph. It is intended to be pushed manually from a dev
/// overlay or a temporary entry point for visual review,
/// and deleted (or at least gated behind `kDebugMode`)
/// before merging to master.
///
/// TODO(pre-merge): remove this file or gate its entry point
/// behind `kDebugMode` / a debug flag before the feature branch
/// is merged.
class AiSummaryPreviewPage extends StatefulWidget {
  const AiSummaryPreviewPage({super.key});

  @override
  State<AiSummaryPreviewPage> createState() => _AiSummaryPreviewPageState();
}

class _AiSummaryPreviewPageState extends State<AiSummaryPreviewPage> {
  Language _language = Language.english;

  @override
  Widget build(BuildContext context) => Directionality(
        textDirection: _language.isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('AI Summary — preview'),
            actions: [
              IconButton(
                icon: const Icon(Icons.translate),
                tooltip: 'Toggle EN / AR',
                onPressed: () {
                  setState(() {
                    _language = _language.isEnglish ? Language.arabic : Language.english;
                  });
                },
              ),
            ],
          ),
          body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          children: [
            _Section(
              title: 'Regular POI with rating',
              child: AiSummaryCard(
                summary: _language.isEnglish ? previewEnRegularWithRating : previewArRegularWithRating,
                language: _language,
              ),
            ),
            _Section(
              title: 'Regular POI without rating',
              child: AiSummaryCard(
                summary: previewEnRegularNoRating,
                language: _language,
              ),
            ),
            _Section(
              title: 'Short description, half-star rating',
              child: AiSummaryCard(
                summary: previewEnShort,
                language: _language,
              ),
            ),
            _Section(
              title: 'Long description',
              child: AiSummaryCard(
                summary: previewEnLong,
                language: _language,
              ),
            ),
            _Section(
              title: 'Transit bus station',
              child: AiSummaryCard(
                summary: _language.isEnglish ? previewEnTransitBusStation : previewArTransitBusStation,
                language: _language,
              ),
            ),
            _Section(
              title: 'Skeleton (loading state)',
              child: AiSummaryCard.skeleton(language: _language),
            ),
          ],
          ),
        ),
      );
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;

  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 4),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF9CA3AF),
                letterSpacing: 0.6,
              ),
            ),
          ),
          child,
        ],
      );
}
