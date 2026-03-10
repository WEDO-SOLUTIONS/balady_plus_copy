// ============================================================
// MapMarkersType → icon paths (SMALL + BIG)
// ============================================================

import 'package:dgis_map/library.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/entities/city_event/city_event.dart';
import 'package:mapness/shared/ui/markers/markers.dart';

extension IconPathFromMapMarkersType on MapMarkersType {
  // ==========================================================
  // SMALL
  // ==========================================================

  String pathBuilder(CityEventType? event, {bool isDark = false}) {
    final def = _smallDefault(isDark);
    final saudi = _smallSaudi(isDark) ?? def;
    final founding = _smallFounding(isDark) ?? def;

    return switch (event) {
      CityEventType.saudiNationalDay => saudi,
      CityEventType.foundingDay => founding,
      _ => def,
    };
  }

  String _smallDefault(bool isDark) => isDark ? (_small.dark ?? _small.def) : _small.def;

  String? _smallSaudi(bool isDark) => isDark ? (_small.saudiDark ?? _small.saudi) : _small.saudi;

  String? _smallFounding(bool isDark) => isDark ? (_small.foundingDark ?? _small.founding) : _small.founding;

  // ==========================================================
  // BIG (derived from SMALL)
  // ==========================================================

  String bigPathBuilder(CityEventType? event, {bool isDark = false}) {
    final small = pathBuilder(event, isDark: isDark);
    return small.toBigIcon(event: event, isDark: isDark);
  }
}

// ============================================================
// SMALL ICON MAP — ВСЕ MapMarkersType
// ============================================================

extension _SmallIconMap on MapMarkersType {
  ({String def, String? dark, String? saudi, String? saudiDark, String? founding, String? foundingDark}) get _small =>
      switch (this) {
        MapMarkersType.markets => _s(
            def: Assets.icons.svg.placesNew.old.icMarkets.keyName,
            saudiDay: Assets.icons.svg.placesNewSaudiDay.icMarkets.keyName,
            foundingDay: Assets.icons.svg.placesNewFoundingDay.icMarkets.keyName,
            foundingDayDark: Assets.icons.svg.placesNewFoundingDayDark.icMarkets.keyName,
          ),
        MapMarkersType.beach => _s(
            def: Assets.icons.svg.placesNew.old.icBeach.keyName,
            saudiDay: Assets.icons.svg.placesNewSaudiDay.icBeach.keyName,
            foundingDay: Assets.icons.svg.placesNewFoundingDay.icBeach.keyName,
            foundingDayDark: Assets.icons.svg.placesNewFoundingDayDark.icBeach.keyName,
          ),
        MapMarkersType.gym => _s(
            def: Assets.icons.svg.placesNew.old.icGym.keyName,
            saudiDay: Assets.icons.svg.placesNewSaudiDay.icGym.keyName,
            foundingDay: Assets.icons.svg.placesNewFoundingDay.icGym.keyName,
            foundingDayDark: Assets.icons.svg.placesNewFoundingDayDark.icGym.keyName,
          ),
        MapMarkersType.gasStation => _s(
            def: Assets.icons.svg.placesNew.old.icGasstationLtr.keyName,
            saudiDay: Assets.icons.svg.placesNewSaudiDay.icGasstationLtr.keyName,
            foundingDay: Assets.icons.svg.placesNewFoundingDay.icGasstationLtr.keyName,
            foundingDayDark: Assets.icons.svg.placesNewFoundingDayDark.icGasstationLtr.keyName,
          ),
        MapMarkersType.events => _s(
            def: Assets.icons.svg.placesNew.old.icEventsLtr.keyName,
            saudiDay: Assets.icons.svg.placesNewSaudiDay.icEventsLtr.keyName,
            foundingDay: Assets.icons.svg.placesNewFoundingDay.icEvents.keyName,
            foundingDayDark: Assets.icons.svg.placesNewFoundingDayDark.icEvents.keyName,
          ),
        MapMarkersType.carServices => _s(
            def: Assets.icons.svg.placesNew.old.icCarServices.keyName,
            saudiDay: Assets.icons.svg.placesNewSaudiDay.icCarServices.keyName,
            foundingDay: Assets.icons.svg.placesNewFoundingDay.icCarServices.keyName,
            foundingDayDark: Assets.icons.svg.placesNewFoundingDayDark.icCarServices.keyName,
          ),
        MapMarkersType.hospitals => _s(
            def: Assets.icons.svg.placesNew.old.icHospitalPlace.keyName,
            saudiDay: Assets.icons.svg.placesNewSaudiDay.icHospitalPlace.keyName,
            foundingDay: Assets.icons.svg.placesNewFoundingDay.icHospital.keyName,
            foundingDayDark: Assets.icons.svg.placesNewFoundingDayDark.icHospital.keyName,
          ),
        MapMarkersType.hotels => _s(
            def: Assets.icons.svg.placesNew.old.icHotels.keyName,
            saudiDay: Assets.icons.svg.placesNewSaudiDay.icHotels.keyName,
            foundingDay: Assets.icons.svg.placesNewFoundingDay.icHotels.keyName,
            foundingDayDark: Assets.icons.svg.placesNewFoundingDayDark.icHotels.keyName,
          ),
        MapMarkersType.pharmacies => _s(
            def: Assets.icons.svg.placesNew.old.icMedicineLtr.keyName,
            saudiDay: Assets.icons.svg.placesNewSaudiDay.icMedicineLtr.keyName,
            foundingDay: Assets.icons.svg.placesNewFoundingDay.icMedicineLtr.keyName,
            foundingDayDark: Assets.icons.svg.placesNewFoundingDayDark.icMedicineLtr.keyName,
          ),
        MapMarkersType.mosques => _s(
            def: Assets.icons.svg.placesNew.old.icMosques.keyName,
            saudiDay: Assets.icons.svg.placesNewSaudiDay.icMosques.keyName,
            foundingDay: Assets.icons.svg.placesNewFoundingDay.icMosques.keyName,
            foundingDayDark: Assets.icons.svg.placesNewFoundingDayDark.icMosques.keyName,
          ),
        MapMarkersType.parks => _s(
            def: Assets.icons.svg.placesNew.old.icPark.keyName,
            saudiDay: Assets.icons.svg.placesNewSaudiDay.icPark.keyName,
            foundingDay: Assets.icons.svg.placesNewFoundingDay.icPark.keyName,
            foundingDayDark: Assets.icons.svg.placesNewFoundingDayDark.icPark.keyName,
          ),
        MapMarkersType.qibla => _s(
            def: Assets.icons.svg.placesNew.old.icQibla.keyName,
            saudiDay: Assets.icons.svg.placesNewSaudiDay.icQibla.keyName,
            foundingDay: Assets.icons.svg.placesNewFoundingDay.icQibla.keyName,
            foundingDayDark: Assets.icons.svg.placesNewFoundingDayDark.icQibla.keyName,
          ),
        MapMarkersType.restaurants => _s(
            def: Assets.icons.svg.placesNew.old.icRestaurant.keyName,
            saudiDay: Assets.icons.svg.placesNewSaudiDay.icRestaurant.keyName,
            foundingDay: Assets.icons.svg.placesNewFoundingDay.icRestaurant.keyName,
            foundingDayDark: Assets.icons.svg.placesNewFoundingDayDark.icRestaurant.keyName,
          ),
        MapMarkersType.wc => _s(
            def: Assets.icons.svg.placesNew.old.icWc.keyName,
            saudiDay: Assets.icons.svg.placesNewSaudiDay.icWc.keyName,
            foundingDay: Assets.icons.svg.placesNewFoundingDay.icWc.keyName,
            foundingDayDark: Assets.icons.svg.placesNewFoundingDayDark.icWc.keyName,
          ),
        MapMarkersType.dentalCenters => _s(
            def: Assets.icons.svg.placesNew.old.icTooth.keyName,
            saudiDay: Assets.icons.svg.placesNewSaudiDay.icTooth.keyName,
            foundingDay: Assets.icons.svg.placesNewFoundingDay.icTooth.keyName,
            foundingDayDark: Assets.icons.svg.placesNewFoundingDayDark.icTooth.keyName,
          ),
        MapMarkersType.schools => _s(
            def: Assets.icons.svg.placesNew.old.icSchoolLtr.keyName,
            saudiDay: Assets.icons.svg.placesNewSaudiDay.icSchoolLtr.keyName,
            foundingDay: Assets.icons.svg.placesNewFoundingDay.icSchoolLtr.keyName,
            foundingDayDark: Assets.icons.svg.placesNewFoundingDayDark.icSchoolLtr.keyName,
          ),
        MapMarkersType.shopping => _s(
            def: Assets.icons.svg.placesNew.old.icShopping.keyName,
            saudiDay: Assets.icons.svg.placesNewSaudiDay.icShopping.keyName,
            foundingDay: Assets.icons.svg.placesNewFoundingDay.icShopping.keyName,
            foundingDayDark: Assets.icons.svg.placesNewFoundingDayDark.icShopping.keyName,
          ),
        MapMarkersType.beauty => _s(
            def: Assets.icons.svg.placesNew.old.icBeauty.keyName,
            saudiDay: Assets.icons.svg.placesNewSaudiDay.icBeauty.keyName,
            foundingDay: Assets.icons.svg.placesNewFoundingDay.icBeauty.keyName,
            foundingDayDark: Assets.icons.svg.placesNewFoundingDayDark.icBeauty.keyName,
          ),
        MapMarkersType.barbershops => _s(
            def: Assets.icons.svg.placesNew.old.icBarbershop.keyName,
            saudiDay: Assets.icons.svg.placesNewSaudiDay.icBarbershop.keyName,
            foundingDay: Assets.icons.svg.placesNewFoundingDay.icBarbershop.keyName,
            foundingDayDark: Assets.icons.svg.placesNewFoundingDayDark.icBarbershop.keyName,
          ),
        MapMarkersType.recreationCenters => _s(
            def: Assets.icons.svg.placesNew.old.icRecreation.keyName,
            saudiDay: Assets.icons.svg.placesNewSaudiDay.icRecreation.keyName,
            foundingDay: Assets.icons.svg.placesNewFoundingDay.icRecreation.keyName,
            foundingDayDark: Assets.icons.svg.placesNewFoundingDayDark.icRecreation.keyName,
          ),
        MapMarkersType.waterPlaces => _s(
            def: Assets.icons.svg.placesNew.old.icWaterPlaces.keyName,
            saudiDay: Assets.icons.svg.placesNewSaudiDay.icWaterPlaces.keyName,
            foundingDay: Assets.icons.svg.placesNewFoundingDay.icWaterPlaces.keyName,
            foundingDayDark: Assets.icons.svg.placesNewFoundingDayDark.icWaterPlaces.keyName,
          ),
        MapMarkersType.medicalHelp => _s(
            def: Assets.icons.svg.placesNew.old.icMedicalHelp.keyName,
            saudiDay: Assets.icons.svg.placesNewSaudiDay.icMedicalHelp.keyName,
            foundingDay: Assets.icons.svg.placesNewFoundingDay.icMedicineLtr.keyName,
            foundingDayDark: Assets.icons.svg.placesNewFoundingDayDark.icMedicineLtr.keyName,
          ),
        MapMarkersType.healthCenter => _s(
            def: Assets.icons.svg.placesNew.old.icHealthCenter.keyName,
            saudiDay: Assets.icons.svg.placesNewSaudiDay.icHealthCenter.keyName,
            foundingDay: Assets.icons.svg.placesNewFoundingDay.icHospital.keyName,
            foundingDayDark: Assets.icons.svg.placesNewFoundingDayDark.icHospital.keyName,
          ),
        MapMarkersType.hospital => _s(
            def: Assets.icons.svg.placesNew.old.icHospital.keyName,
            saudiDay: Assets.icons.svg.placesNewSaudiDay.icHospital.keyName,
            foundingDay: Assets.icons.svg.placesNewFoundingDay.icHospital.keyName,
            foundingDayDark: Assets.icons.svg.placesNewFoundingDayDark.icHospital.keyName,
          ),
        MapMarkersType.fireStation => _s(
            def: Assets.icons.svg.placesNew.old.icFireStation.keyName,
            saudiDay: Assets.icons.svg.placesNewSaudiDay.icFireStation.keyName,
            foundingDay: Assets.icons.svg.placesNewFoundingDay.icFireStation.keyName,
          ),
        MapMarkersType.policeStation => _s(
            def: Assets.icons.svg.placesNew.old.icPoliceStation.keyName,
            saudiDay: Assets.icons.svg.placesNewSaudiDay.icPoliceStation.keyName,
            foundingDay: Assets.icons.svg.placesNewFoundingDay.icPoliceStation.keyName,
            foundingDayDark: Assets.icons.svg.placesNewFoundingDayDark.icPoliceStation.keyName,
          ),
        MapMarkersType.lostAndFound => _s(
            def: Assets.icons.svg.placesNew.old.icLostAndFound.keyName,
            saudiDay: Assets.icons.svg.placesNewSaudiDay.icLostAndFound.keyName,
            foundingDay: Assets.icons.svg.placesNewFoundingDay.icDefault.keyName,
            foundingDayDark: Assets.icons.svg.placesNewFoundingDayDark.icDefault.keyName,
          ),
        MapMarkersType.hajjSupport => _s(
            def: Assets.icons.svg.placesNew.old.icHajjSupport.keyName,
            saudiDay: Assets.icons.svg.placesNewSaudiDay.icHajjSupport.keyName,
            foundingDay: Assets.icons.svg.placesNewFoundingDay.icMosques.keyName,
            foundingDayDark: Assets.icons.svg.placesNewFoundingDayDark.icMosques.keyName,
          ),
        MapMarkersType.kiosksRetail => _s(
            def: Assets.icons.svg.placesNew.old.icKiosksRetail.keyName,
            saudiDay: Assets.icons.svg.placesNewSaudiDay.icKiosksRetail.keyName,
            foundingDay: Assets.icons.svg.placesNewFoundingDay.icShopping.keyName,
            foundingDayDark: Assets.icons.svg.placesNewFoundingDayDark.icShopping.keyName,
          ),
        MapMarkersType.additional => _s(
            def: Assets.icons.svg.placesNew.old.icAdditional.keyName,
            saudiDay: Assets.icons.svg.placesNewSaudiDay.icAdditional.keyName,
            foundingDay: Assets.icons.svg.placesNewFoundingDay.icDefault.keyName,
            foundingDayDark: Assets.icons.svg.placesNewFoundingDayDark.icDefault.keyName,
          ),
        MapMarkersType.stairs => _s(
            def: Assets.icons.svg.placesNew.old.icStairs.keyName,
            saudiDay: Assets.icons.svg.placesNewSaudiDay.icStairs.keyName,
            foundingDay: Assets.icons.svg.placesNewFoundingDay.icDefault.keyName,
            foundingDayDark: Assets.icons.svg.placesNewFoundingDayDark.icDefault.keyName,
          ),
      };

  static ({String def, String? dark, String? saudi, String? saudiDark, String? founding, String? foundingDark}) _s({
    required String def,
    String? defDark,
    String? saudiDay,
    String? saudiDayDark,
    String? foundingDay,
    String? foundingDayDark,
  }) =>
      (
        def: def,
        dark: defDark,
        saudi: saudiDay,
        saudiDark: saudiDayDark,
        founding: foundingDay,
        foundingDark: foundingDayDark,
      );
}

// ============================================================
// BIG ICON — derived from SMALL (NO unused variables)
// ============================================================

extension BigIconFromSmallPath on String {
  String toBigIcon({CityEventType? event, bool isDark = false}) {
    final candidate = replaceFirst('places_new/', 'places_big_new/')
        .replaceFirst('places_new_saudi_day/', 'places_new_saudi_day_big/')
        .replaceFirst('places_new_founding_day/', 'places_new_founding_day_big/')
        .replaceFirst('places_new_founding_day_dark/', 'places_new_founding_day_big_dark/');

    return candidate.isNotEmpty
        ? candidate
        : switch (event) {
            CityEventType.saudiNationalDay => Markers.defaultPinNewSaudiDay,
            CityEventType.foundingDay => isDark
                ? Assets.icons.svg.placesNewFoundingDayBigDark.icDefault.keyName
                : Markers.defaultPinNewFoundingDay,
            _ => Markers.defaultPinNew,
          };
  }
}
