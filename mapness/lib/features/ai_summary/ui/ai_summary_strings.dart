import 'package:mapness/shared/providers/app_language.dart';

/// Temporary bilingual string provider for the AI Summary card.
///
/// These strings live here as hardcoded constants instead of in
/// `app_en.arb` / `app_ar.arb` because the project's .arb files
/// are generated from Localazy (see `just locale_gen`) and direct
/// additions get wiped on the next sync. Before merging this
/// feature to master, these keys must be uploaded to Localazy and
/// this file replaced with `context.l10n.aiSummary*` getters.
///
/// TODO(localazy): migrate the following keys to Localazy:
///   - aiSummaryLabel
///   - aiSummaryBaladyBadge
///   - aiSummaryPoweredBy
///   - aiSummaryAvailableLines
///   - aiSummaryReviews (parametrized: {count})
class AiSummaryStrings {
  final Language language;

  const AiSummaryStrings(this.language);

  String get label => language.isArabic ? 'وصف مُنشأ بالذكاء الاصطناعي' : 'AI Summary';

  String get baladyBadge => language.isArabic ? 'بلدي+ الذكاء الاصطناعي' : 'Balady AI';

  String get poweredBy => language.isArabic
      ? 'بدعم من بلدي+ الذكاء الاصطناعي · بناءً على مصادر موثوقة'
      : 'Powered by Balady AI · Based on verified sources';

  String get availableLines => language.isArabic ? 'الخطوط المتاحة' : 'Available Lines';

  String reviews(int count) => language.isArabic ? '$count مراجعة' : '$count reviews';
}
