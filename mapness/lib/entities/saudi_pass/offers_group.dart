import 'dart:ui';

import 'package:mapness/l10n/generated/app_localizations.dart';

enum OffersGroup {
  food,
  shopping,
  homeAndAuto,
  beautyAndHealth,
  entertainment,
  services,
}

extension OffersGroupExtension on OffersGroup {
  String title(AppLocalizations locale) => switch (this) {
        OffersGroup.food => locale.tastyDeals,
        OffersGroup.shopping => locale.styleForLess,
        OffersGroup.homeAndAuto => locale.homeAndAuto,
        OffersGroup.beautyAndHealth => locale.selfCare,
        OffersGroup.entertainment => locale.timeToRelax,
        OffersGroup.services => locale.usefulServices,
      };

  String description(AppLocalizations locale) => switch (this) {
        OffersGroup.food => locale.tastyDealsDescription,
        OffersGroup.shopping => locale.styleForLessDescription,
        OffersGroup.homeAndAuto => locale.homeAndAutoDescription,
        OffersGroup.beautyAndHealth => locale.selfCareDescription,
        OffersGroup.entertainment => locale.timeToRelaxDescription,
        OffersGroup.services => locale.usefulServicesDescription,
      };

  String get imagePath {
    const pathPrefix = 'packages/mapness/assets/images';
    return switch (this) {
      OffersGroup.food => '$pathPrefix/basket.png',
      OffersGroup.shopping => '$pathPrefix/clock.png',
      OffersGroup.homeAndAuto => '$pathPrefix/car.png',
      OffersGroup.beautyAndHealth => '$pathPrefix/hearts.png',
      OffersGroup.entertainment => '$pathPrefix/plane.png',
      OffersGroup.services => '$pathPrefix/books.png',
    };
  }

  List<Color> get color => switch (this) {
        OffersGroup.food => const [
            Color(0xFFF19F2F),
            Color(0xFFD6650E),
          ],
        OffersGroup.shopping => const [
            Color(0xFF343338),
            Color(0xFF17171A),
          ],
        OffersGroup.homeAndAuto => const [
            Color(0xFF3B81B7),
            Color(0xFF1B4890),
          ],
        OffersGroup.beautyAndHealth => const [
            Color(0xFF3DC4BA),
            Color(0xFF04756D),
          ],
        OffersGroup.entertainment => const [
            Color(0xFFB180E8),
            Color(0xFF7035AE),
          ],
        OffersGroup.services => const [
            Color(0xFF58A768),
            Color(0xFF277035),
          ],
      };
}
