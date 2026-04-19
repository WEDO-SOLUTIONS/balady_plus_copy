import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

enum OffersGroup {
  eat,
  shopping,
  homeAndAuto,
  beautyAndHealth,
  entertainment,
  services,
  others,
}

extension OffersGroupExtension on OffersGroup {
  static List<OffersGroup> get mainCategories => [
        OffersGroup.eat,
        OffersGroup.shopping,
        OffersGroup.homeAndAuto,
        OffersGroup.beautyAndHealth,
        OffersGroup.entertainment,
        OffersGroup.services,
      ];


  String title(AppLocalizations locale) => switch (this) {
        OffersGroup.eat => locale.tastyDeals,
        OffersGroup.shopping => locale.styleForLess,
        OffersGroup.homeAndAuto => locale.homeAndAuto,
        OffersGroup.beautyAndHealth => locale.selfCare,
        OffersGroup.entertainment => locale.timeToRelax,
        OffersGroup.services => locale.usefulServices,
        OffersGroup.others => '',
      };

  String description(AppLocalizations locale) => switch (this) {
        OffersGroup.eat => locale.tastyDealsDescription,
        OffersGroup.shopping => locale.styleForLessDescription,
        OffersGroup.homeAndAuto => locale.homeAndAutoDescription,
        OffersGroup.beautyAndHealth => locale.selfCareDescription,
        OffersGroup.entertainment => locale.timeToRelaxDescription,
        OffersGroup.services => locale.usefulServicesDescription,
        OffersGroup.others => '',
      };

  String get imagePath {
    const pathPrefix = 'packages/mapness/assets/images/saudi_pass';
    return switch (this) {
      OffersGroup.eat => '$pathPrefix/basket.png',
      OffersGroup.shopping => '$pathPrefix/clock.png',
      OffersGroup.homeAndAuto => '$pathPrefix/car.png',
      OffersGroup.beautyAndHealth => '$pathPrefix/hearts.png',
      OffersGroup.entertainment => '$pathPrefix/plane.png',
      OffersGroup.services => '$pathPrefix/books.png',
      OffersGroup.others => '$pathPrefix/others.png',
    };
  }

  List<Color> get color => switch (this) {
        OffersGroup.eat => const [
            Color(0xFFD9F7E6),
          Color(0xFFD9F7E6),
          ],
        OffersGroup.shopping => const [
          Color(0xFFD9F7E6),
          Color(0xFFD9F7E6),
          ],
        OffersGroup.homeAndAuto => const [
          Color(0xFFD9F7E6),
          Color(0xFFD9F7E6),
          ],
        OffersGroup.beautyAndHealth => const [
          Color(0xFFD9F7E6),
          Color(0xFFD9F7E6),
          ],
        OffersGroup.entertainment => const [
          Color(0xFFD9F7E6),
          Color(0xFFD9F7E6),
          ],
        OffersGroup.services => const [
          Color(0xFFD9F7E6),
          Color(0xFFD9F7E6),
          ],
        OffersGroup.others => const [
          Color(0xFFD9F7E6),
          Color(0xFFD9F7E6),
          ],
      };



  (double?, double?, double?, double?) get imagePosition => switch (this) {
    OffersGroup.eat => (null, 2, null, -10),
    OffersGroup.shopping   => (null, 6, null, -10),
    OffersGroup.homeAndAuto => (30, -5, 80, 0),
    OffersGroup.beautyAndHealth  => (null, 0, null, 0),
    OffersGroup.entertainment => (0, -10, null, 2),
    OffersGroup.services => (null, -10, null, -5),
    OffersGroup.others => (null, 6, null, -20),
  };

}


