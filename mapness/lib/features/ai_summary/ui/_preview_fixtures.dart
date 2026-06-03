import 'dart:ui';

import 'package:mapness/features/ai_summary/domain/ai_summary.dart';
import 'package:mapness/features/ai_summary/domain/transit_line.dart';

/// Static in-memory fixtures for rendering the AI Summary card
/// in isolation during visual iteration and RTL smoke-tests.
///
/// Backed by the real freezed [AiSummary] / [TransitLine] models.
/// Once the mock repository (Phase 2, T12) is wired up, these
/// fixtures become the data source for `MockAiSummaryRepository`.

/// Commonly used colours for transit line badges in previews.
/// Values chosen to mimic real brand colours seen in DGIS data.
class _LineColors {
  static const int metroBlue = 0xFF0072CE;
  static const int busOrange = 0xFFEF7B10;
  static const int busYellow = 0xFFF2C200;
}

/// ---------- English fixtures ----------

final previewEnRegularWithRating = AiSummary(
  description:
      'Blue Butterfly Medical Center is a well-regarded healthcare '
      'facility located in the Al Naseem district of Makkah. The center '
      'is known for its professional medical staff and clean, welcoming '
      'environment.',
  rating: 4.3,
  reviewCount: 127,
);

final previewEnRegularNoRating = AiSummary(
  description:
      'A small neighbourhood bakery tucked away near the old market. '
      'Locals drop by for fresh flatbread in the mornings and sweet '
      'pastries in the afternoons.',
);

final previewEnShort = AiSummary(
  description: 'A quiet park with shaded benches and a playground.',
  rating: 3.5,
  reviewCount: 12,
);

final previewEnLong = AiSummary(
  description:
      'Al Noor Commercial Complex is a large multi-purpose retail and '
      'dining destination in central Jeddah. The complex houses over '
      'eighty stores across three floors, a food court with regional and '
      "international cuisine, a supervised children's play area, and "
      'ample parking. It is popular with families on weekends and hosts '
      'seasonal markets during Ramadan and the summer holidays.',
  rating: 4.7,
  reviewCount: 2584,
);

final previewEnTransitBusStation = AiSummary(
  description:
      'Kudai Bus Station is a key transit hub in central Makkah, '
      "serving as a major stop along the city's public bus network. "
      'It connects pilgrims and residents to Masjid al-Haram and the '
      'surrounding neighbourhoods.',
  rating: 3.8,
  reviewCount: 42,
  transitLines: [
    TransitLine(shortName: 'L 5', colorArgb: _LineColors.busOrange, headsign: 'Ajyad'),
    TransitLine(shortName: 'L 9', colorArgb: _LineColors.busYellow, headsign: 'Al Aziziyah'),
    TransitLine(shortName: 'M 1', colorArgb: _LineColors.metroBlue, headsign: 'Arafat'),
  ],
);

/// ---------- Arabic fixtures ----------

final previewArRegularWithRating = AiSummary(
  description:
      'مركز الفراشة الزرقاء الطبي هو مرفق صحي يحظى بتقدير كبير في حي '
      'النسيم بمكة المكرمة. يُعرف المركز بطاقمه الطبي المحترف وبيئته '
      'النظيفة والمرحبة.',
  rating: 4.3,
  reviewCount: 127,
);

final previewArTransitBusStation = AiSummary(
  description:
      'محطة كدي للحافلات هي محور نقل رئيسي في وسط مكة المكرمة، وتُعد '
      'محطة كبرى على شبكة الحافلات العامة في المدينة. تربط الحجاج '
      'والسكان بالمسجد الحرام والأحياء المحيطة.',
  rating: 3.8,
  reviewCount: 42,
  transitLines: [
    // headsign present in data but hidden in UI when locale is Arabic
    TransitLine(shortName: 'خط ٥', colorArgb: _LineColors.busOrange, headsign: 'Ajyad'),
    TransitLine(shortName: 'خط ٩', colorArgb: _LineColors.busYellow, headsign: 'Al Aziziyah'),
    TransitLine(shortName: 'خط ١', colorArgb: _LineColors.metroBlue, headsign: 'Arafat'),
  ],
);

/// Helper for turning an ARGB int into a Flutter [Color] at call-site
/// without pulling material.dart into this file.
Color colorFromArgb(int argb) => Color(argb);
