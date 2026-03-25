import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/icons/places_16_icons.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/providers/app_language.dart';

// TODO(Sergei): remove rubrics and rename to QuickSearch when quick search feature is approved
enum QuickFilter { eatOut, mosques, markets, hotels, fuel }

sealed class QuickFilterBase {
  const QuickFilterBase();

  List<QuickFilter> get list;
}

class QuickFilterList extends QuickFilterBase {
  @override
  List<QuickFilter> get list => QuickFilter.values;
}

class NaviQuickFilterList extends QuickFilterBase {
  @override
  List<QuickFilter> get list => [
    QuickFilter.fuel,
    QuickFilter.eatOut,
    QuickFilter.markets,
    QuickFilter.hotels,
    QuickFilter.mosques,
  ];
}

enum NaviQuickFilterMore {
  fuel,
  mosques,
  beauty,
  gyms,
  restaurants,
  malls,
  barbershops,
  banks,
  hotels,
  police,
  hospitals,
  medicine,
  airport,
  education,
  markets,
  carService,
  qibla,
  media,
  connection,
  clothes,
  animals,
  nature,
  business,
  dentist,
  recreation,
  beach,
  wc,
  events,
  cityServices,
  railwayTransport,
  cityTransport,
  childrensGoods,
  newBuilds,
  waterTransport,
  artAndDesign,
  buildingMaterials,
}

class NaviQuickFilterMoreList {
  List<NaviQuickFilterMore> get list => NaviQuickFilterMore.values;
}

extension NaviQuickFilterMoreExtension on NaviQuickFilterMore {
  String title(AppLocalizations locale) => switch (this) {
    NaviQuickFilterMore.mosques => locale.mosques,
    NaviQuickFilterMore.fuel => locale.fuel,
    NaviQuickFilterMore.hotels => locale.hotels,
    NaviQuickFilterMore.markets => locale.markets,
    NaviQuickFilterMore.restaurants => locale.naviQuickFilterMoreRestaurants,
    NaviQuickFilterMore.beauty => locale.naviQuickFilterMoreBeauty,
    NaviQuickFilterMore.gyms => locale.naviQuickFilterMoreGyms,
    NaviQuickFilterMore.malls => locale.naviQuickFilterMoreMalls,
    NaviQuickFilterMore.barbershops => locale.naviQuickFilterMoreBarbershops,
    NaviQuickFilterMore.banks => locale.naviQuickFilterMoreBanks,
    NaviQuickFilterMore.police => locale.naviQuickFilterMorePolice,
    NaviQuickFilterMore.hospitals => locale.naviQuickFilterMoreHospitals,
    NaviQuickFilterMore.medicine => locale.naviQuickFilterMoreMedicine,
    NaviQuickFilterMore.airport => locale.naviQuickFilterMoreAirport,
    NaviQuickFilterMore.education => locale.naviQuickFilterMoreEducation,
    NaviQuickFilterMore.carService => locale.naviQuickFilterMoreCarService,
    NaviQuickFilterMore.qibla => locale.naviQuickFilterMoreQibla,
    NaviQuickFilterMore.media => locale.naviQuickFilterMoreMedia,
    NaviQuickFilterMore.connection => locale.naviQuickFilterMoreConnection,
    NaviQuickFilterMore.clothes => locale.naviQuickFilterMoreClothes,
    NaviQuickFilterMore.animals => locale.naviQuickFilterMoreAnimals,
    NaviQuickFilterMore.nature => locale.naviQuickFilterMoreNature,
    NaviQuickFilterMore.business => locale.naviQuickFilterMoreBusiness,
    NaviQuickFilterMore.dentist => locale.naviQuickFilterMoreDentist,
    NaviQuickFilterMore.recreation => locale.naviQuickFilterMoreRecreation,
    NaviQuickFilterMore.beach => locale.naviQuickFilterMoreBeach,
    NaviQuickFilterMore.wc => locale.naviQuickFilterMoreWc,
    NaviQuickFilterMore.events => locale.naviQuickFilterMoreEvents,
    NaviQuickFilterMore.cityServices => locale.naviQuickFilterMoreCityServices,
    NaviQuickFilterMore.railwayTransport => locale.naviQuickFilterMoreRailwayTransport,
    NaviQuickFilterMore.cityTransport => locale.naviQuickFilterMoreCityTransport,
    NaviQuickFilterMore.childrensGoods => locale.naviQuickFilterMoreChildrensGoods,
    NaviQuickFilterMore.newBuilds => locale.naviQuickFilterMoreNewBuilds,
    NaviQuickFilterMore.waterTransport => locale.naviQuickFilterMoreWaterTransport,
    NaviQuickFilterMore.artAndDesign => locale.naviQuickFilterMoreArtAndDesign,
    NaviQuickFilterMore.buildingMaterials => locale.naviQuickFilterMoreBuildingMaterials,
  };

  IconData? get icon => switch (this) {
    NaviQuickFilterMore.fuel => PlacesIcons.gasstationFilled,
    NaviQuickFilterMore.mosques => PlacesIcons.mosques,
    NaviQuickFilterMore.beauty => Places16Icons.beauty,
    NaviQuickFilterMore.gyms => PlacesIcons.gym,
    NaviQuickFilterMore.restaurants => PlacesIcons.restaurant,
    NaviQuickFilterMore.malls => PlacesIcons.mall,
    NaviQuickFilterMore.barbershops => Places16Icons.barbershop,
    NaviQuickFilterMore.banks => PlacesIcons.banks,
    NaviQuickFilterMore.hotels => PlacesIcons.hotelsFilled,
    NaviQuickFilterMore.police => PlacesIcons.police,
    NaviQuickFilterMore.hospitals => PlacesIcons.hospital,
    NaviQuickFilterMore.medicine => PlacesIcons.medicine,
    NaviQuickFilterMore.airport => PlacesIcons.airport,
    NaviQuickFilterMore.education => PlacesIcons.school,
    NaviQuickFilterMore.markets => PlacesIcons.markets,
    NaviQuickFilterMore.carService => PlacesIcons.carServices,
    NaviQuickFilterMore.qibla => PlacesIcons.qibla,
    NaviQuickFilterMore.media => PlacesIcons.media,
    NaviQuickFilterMore.connection => PlacesIcons.connection,
    NaviQuickFilterMore.clothes => PlacesIcons.clothingAndFootwear,
    NaviQuickFilterMore.animals => PlacesIcons.animals,
    NaviQuickFilterMore.nature => PlacesIcons.park,
    NaviQuickFilterMore.business => PlacesIcons.business,
    NaviQuickFilterMore.dentist => PlacesIcons.tooth,
    NaviQuickFilterMore.recreation => Places16Icons.recreation,
    NaviQuickFilterMore.beach => PlacesIcons.beach,
    NaviQuickFilterMore.wc => PlacesIcons.wc,
    NaviQuickFilterMore.events => PlacesIcons.events,
    NaviQuickFilterMore.cityServices => PlacesIcons.municipalities,
    NaviQuickFilterMore.railwayTransport => Places16Icons.railwayTransport,
    NaviQuickFilterMore.cityTransport => PlacesIcons.cityTransport,
    NaviQuickFilterMore.childrensGoods => PlacesIcons.childrensGoods,
    NaviQuickFilterMore.newBuilds => PlacesIcons.construction,
    NaviQuickFilterMore.waterTransport => PlacesIcons.waterTransport,
    NaviQuickFilterMore.artAndDesign => PlacesIcons.artAndDesign,
    NaviQuickFilterMore.buildingMaterials => PlacesIcons.buildingMaterials,
  };

  Map<Language, String> get query => switch (this) {
    NaviQuickFilterMore.fuel => {Language.english: 'Fuel', Language.arabic: 'الوقود'},
    NaviQuickFilterMore.mosques => {Language.english: 'Mosques', Language.arabic: 'مساجد'},
    NaviQuickFilterMore.beauty => {Language.english: 'Beauty', Language.arabic: 'جمال'},
    NaviQuickFilterMore.gyms => {Language.english: 'Gyms', Language.arabic: 'صالات رياضية'},
    NaviQuickFilterMore.restaurants => {Language.english: 'Restaurants', Language.arabic: 'مطاعم'},
    NaviQuickFilterMore.malls => {Language.english: 'Malls', Language.arabic: 'مولات'},
    NaviQuickFilterMore.barbershops => {Language.english: 'Barbershops', Language.arabic: 'محلات حلاقة'},
    NaviQuickFilterMore.banks => {Language.english: 'Banks', Language.arabic: 'بنوك'},
    NaviQuickFilterMore.hotels => {Language.english: 'Hotels', Language.arabic: 'فنادق'},
    NaviQuickFilterMore.police => {Language.english: 'Police', Language.arabic: 'شرطة'},
    NaviQuickFilterMore.hospitals => {Language.english: 'Hospitals', Language.arabic: 'مستشفيات'},
    NaviQuickFilterMore.medicine => {Language.english: 'Medicine', Language.arabic: 'أدوية'},
    NaviQuickFilterMore.airport => {Language.english: 'Airport', Language.arabic: 'مطار'},
    NaviQuickFilterMore.education => {Language.english: 'Education', Language.arabic: 'تعليم'},
    NaviQuickFilterMore.markets => {Language.english: 'Markets', Language.arabic: 'أسواق'},
    NaviQuickFilterMore.carService => {Language.english: 'Car Service', Language.arabic: 'خدمة سيارات'},
    NaviQuickFilterMore.qibla => {Language.english: 'Qibla', Language.arabic: 'قبلة'},
    NaviQuickFilterMore.media => {Language.english: 'Media', Language.arabic: 'وسائط'},
    NaviQuickFilterMore.connection => {Language.english: 'Connection', Language.arabic: 'اتصال'},
    NaviQuickFilterMore.clothes => {Language.english: 'Clothes', Language.arabic: 'ملابس'},
    NaviQuickFilterMore.animals => {Language.english: 'Animals', Language.arabic: 'حيوانات'},
    NaviQuickFilterMore.nature => {Language.english: 'Nature', Language.arabic: 'طبيعة'},
    NaviQuickFilterMore.business => {Language.english: 'Business', Language.arabic: 'أعمال'},
    NaviQuickFilterMore.dentist => {Language.english: 'Dentist', Language.arabic: 'طبيب أسنان'},
    NaviQuickFilterMore.recreation => {Language.english: 'Recreation', Language.arabic: 'ترفيه'},
    NaviQuickFilterMore.beach => {Language.english: 'Beach', Language.arabic: 'شاطئ'},
    NaviQuickFilterMore.wc => {Language.english: 'WC', Language.arabic: 'دورة المياه'},
    NaviQuickFilterMore.events => {Language.english: 'Events', Language.arabic: 'فعاليات'},
    NaviQuickFilterMore.cityServices => {Language.english: 'City Services', Language.arabic: 'خدمات المدينة'},
    NaviQuickFilterMore.railwayTransport => {
      Language.english: 'Railway transport',
      Language.arabic: 'النقل بالسكك الحديدية',
    },
    NaviQuickFilterMore.cityTransport => {Language.english: 'City transport', Language.arabic: 'دينا ستي للنقل'},
    NaviQuickFilterMore.childrensGoods => {
      Language.english: 'Children’s goods',
      Language.arabic: 'بضائع الأطفال',
    },
    NaviQuickFilterMore.newBuilds => {Language.english: 'New Builds', Language.arabic: 'مباني جديدة'},
    NaviQuickFilterMore.waterTransport => {Language.english: 'Water transport', Language.arabic: 'النقل المائي'},
    NaviQuickFilterMore.artAndDesign => {Language.english: 'Art and design', Language.arabic: 'فن وتصميم'},
    NaviQuickFilterMore.buildingMaterials => {
      Language.english: 'Building materials',
      Language.arabic: 'مواد البناء',
    },
  };
}

extension QuickFilterExtension on QuickFilter {
  String title(AppLocalizations locale) => switch (this) {
    QuickFilter.mosques => locale.mosques,
    QuickFilter.fuel => locale.fuel,
    QuickFilter.hotels => locale.hotels,
    QuickFilter.markets => locale.markets,
    QuickFilter.eatOut => locale.eatOut,
  };

  IconData? get icon => switch (this) {
    QuickFilter.eatOut => PlacesIcons.restaurant,
    QuickFilter.mosques => PlacesIcons.mosques,
    QuickFilter.markets => PlacesIcons.markets,
    QuickFilter.hotels => PlacesIcons.hotelsFilled,
    QuickFilter.fuel => PlacesIcons.gasstationFilled,
  };

  MapMarkersType? get markerType => switch (this) {
    QuickFilter.eatOut => MapMarkersType.restaurants,
    QuickFilter.mosques => MapMarkersType.mosques,
    QuickFilter.markets => MapMarkersType.markets,
    QuickFilter.hotels => MapMarkersType.hotels,
    QuickFilter.fuel => MapMarkersType.gasStation,
  };

  Map<Language, String> get query => switch (this) {
    QuickFilter.mosques => {Language.english: 'Mosques', Language.arabic: 'المساجد'},
    QuickFilter.fuel => {Language.english: 'Fuel', Language.arabic: 'وقود'},
    QuickFilter.hotels => {Language.english: 'Hotels', Language.arabic: 'فنادق'},
    QuickFilter.markets => {Language.english: 'Market', Language.arabic: 'سوق'},
    QuickFilter.eatOut => {Language.english: 'Eat out', Language.arabic: 'مطاعم'},
  };
}
