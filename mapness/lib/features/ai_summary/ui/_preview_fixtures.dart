import 'dart:ui';

/// Static in-memory fixtures for rendering the AI Summary card
/// in isolation during visual iteration and RTL smoke-tests.
///
/// This file is a temporary scaffold. Once the proper freezed
/// `AiSummary` model lands in Phase 2 (T10), this file will be
/// rewritten to use the real model type and the local
/// `_PreviewAiSummary` / `_PreviewTransitLine` classes below
/// will be deleted.
class PreviewAiSummary {
  final String description;
  final double? rating;
  final int? reviewCount;
  final List<PreviewTransitLine>? transitLines;

  const PreviewAiSummary({
    required this.description,
    this.rating,
    this.reviewCount,
    this.transitLines,
  });
}

class PreviewTransitLine {
  final String shortName;
  final String? headsign;
  final int colorArgb;

  const PreviewTransitLine({
    required this.shortName,
    required this.colorArgb,
    this.headsign,
  });
}

/// Commonly used colours for transit line badges in previews.
/// Values chosen to mimic real brand colours seen in DGIS data.
class _LineColors {
  static const int metroBlue = 0xFF0072CE;
  static const int busOrange = 0xFFEF7B10;
  static const int busYellow = 0xFFF2C200;
}

/// ---------- English fixtures ----------

const previewEnRegularWithRating = PreviewAiSummary(
  description:
      'Blue Butterfly Medical Center is a well-regarded healthcare '
      'facility located in the Al Naseem district of Makkah. The center '
      'is known for its professional medical staff and clean, welcoming '
      'environment.',
  rating: 4.3,
  reviewCount: 127,
);

const previewEnRegularNoRating = PreviewAiSummary(
  description:
      'A small neighbourhood bakery tucked away near the old market. '
      'Locals drop by for fresh flatbread in the mornings and sweet '
      'pastries in the afternoons.',
);

const previewEnShort = PreviewAiSummary(
  description: 'A quiet park with shaded benches and a playground.',
  rating: 3.5,
  reviewCount: 12,
);

const previewEnLong = PreviewAiSummary(
  description:
      'Al Noor Commercial Complex is a large multi-purpose retail and '
      'dining destination in central Jeddah. The complex houses over '
      'eighty stores across three floors, a food court with regional and '
      'international cuisine, a supervised children\'s play area, and '
      'ample parking. It is popular with families on weekends and hosts '
      'seasonal markets during Ramadan and the summer holidays.',
  rating: 4.7,
  reviewCount: 2584,
);

const previewEnTransitBusStation = PreviewAiSummary(
  description:
      'Kudai Bus Station is a key transit hub in central Makkah, '
      'serving as a major stop along the city\'s public bus network. '
      'It connects pilgrims and residents to Masjid al-Haram and the '
      'surrounding neighbourhoods.',
  rating: 3.8,
  reviewCount: 42,
  transitLines: [
    PreviewTransitLine(shortName: 'L 5', headsign: 'Ajyad', colorArgb: _LineColors.busOrange),
    PreviewTransitLine(shortName: 'L 9', headsign: 'Al Aziziyah', colorArgb: _LineColors.busYellow),
    PreviewTransitLine(shortName: 'M 1', headsign: 'Arafat', colorArgb: _LineColors.metroBlue),
  ],
);

/// ---------- Arabic fixtures ----------

const previewArRegularWithRating = PreviewAiSummary(
  description:
      'مركز الفراشة الزرقاء الطبي هو مرفق صحي يحظى بتقدير كبير في حي '
      'النسيم بمكة المكرمة. يُعرف المركز بطاقمه الطبي المحترف وبيئته '
      'النظيفة والمرحبة.',
  rating: 4.3,
  reviewCount: 127,
);

const previewArTransitBusStation = PreviewAiSummary(
  description:
      'محطة كدي للحافلات هي محور نقل رئيسي في وسط مكة المكرمة، وتُعد '
      'محطة كبرى على شبكة الحافلات العامة في المدينة. تربط الحجاج '
      'والسكان بالمسجد الحرام والأحياء المحيطة.',
  rating: 3.8,
  reviewCount: 42,
  transitLines: [
    // headsign present in data but hidden in UI when locale is Arabic
    PreviewTransitLine(shortName: 'خط ٥', headsign: 'Ajyad', colorArgb: _LineColors.busOrange),
    PreviewTransitLine(shortName: 'خط ٩', headsign: 'Al Aziziyah', colorArgb: _LineColors.busYellow),
    PreviewTransitLine(shortName: 'خط ١', headsign: 'Arafat', colorArgb: _LineColors.metroBlue),
  ],
);

/// Helper for turning an ARGB int into a Flutter [Color] at call-site
/// without pulling material.dart into this file.
Color colorFromArgb(int argb) => Color(argb);
