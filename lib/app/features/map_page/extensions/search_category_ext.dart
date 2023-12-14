import 'dart:ui';

import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';

extension SearchCategoryData on SearchCategoryMessage {
  String displayName() {
    return switch (this) {
      SearchCategoryMessage.mousques => "مساجد",
      SearchCategoryMessage.gasStations => "محطات",
      SearchCategoryMessage.cafe => "مقاهي",
      SearchCategoryMessage.restaurants => "مطاعم",
      SearchCategoryMessage.parks => "حدائق",
      SearchCategoryMessage.hospitals => "المستشفيات",
      SearchCategoryMessage.schools => "المدارس",
      SearchCategoryMessage.pharmacies => "صيدليات",
      SearchCategoryMessage.dentalCenters => "مراكز الأسنان",
      SearchCategoryMessage.hotels => "الفنادق والشقق المفروشه",
      SearchCategoryMessage.beautyCenters => "مراكز التزيين",
      SearchCategoryMessage.recreationCenters => "الأنشطة الترفيهية",
    };
  }

  String iconName() {
    return switch (this) {
      SearchCategoryMessage.mousques =>
        "assets/maps/icons/poi_mousques_light.svg",
      SearchCategoryMessage.gasStations =>
        "assets/maps/icons/poi_gas_station_light.svg",
      SearchCategoryMessage.cafe => "assets/maps/icons/poi_cafe_light.svg",
      SearchCategoryMessage.restaurants =>
        "assets/maps/icons/poi_eat_light.svg",
      SearchCategoryMessage.parks => "assets/maps/icons/poi_park_light.svg",
      SearchCategoryMessage.hospitals =>
        "assets/maps/icons/hospital_category_icon.svg",
      SearchCategoryMessage.schools =>
        "assets/maps/icons/school_category_icon.svg",
      SearchCategoryMessage.pharmacies => "assets/maps/icons/pahrmacy_poi.svg",
      SearchCategoryMessage.dentalCenters => "assets/maps/icons/dental_poi.svg",
      SearchCategoryMessage.hotels =>
        "assets/maps/icons/school_category_icon.svg",
      SearchCategoryMessage.beautyCenters =>
        "assets/maps/icons/school_category_icon.svg",
      SearchCategoryMessage.recreationCenters =>
        "assets/maps/icons/school_category_icon.svg",
    };
  }

  String markerIconName() {
    return switch (this) {
      SearchCategoryMessage.mousques =>
        "assets/maps/icons/ic_marker_mosques.svg",
      SearchCategoryMessage.gasStations =>
        "assets/maps/icons/ic_marker_gas_stations.svg",
      SearchCategoryMessage.cafe => "assets/maps/icons/poi_cafe_light.svg",
      SearchCategoryMessage.restaurants =>
        "assets/maps/icons/ic_marker_restaurant.svg",
      SearchCategoryMessage.parks =>
        "assets/maps/icons/ic_marker_gardens_parks.svg",
      SearchCategoryMessage.hospitals => "assets/maps/icons/hospital_pin.svg",
      SearchCategoryMessage.schools => "assets/maps/icons/school_pin.svg",
      SearchCategoryMessage.pharmacies => "assets/maps/icons/pharmacy_pin.svg",
      SearchCategoryMessage.dentalCenters => "assets/maps/icons/dental_pin.svg",
      SearchCategoryMessage.hotels => "assets/maps/icons/school_pin.svg",
      SearchCategoryMessage.beautyCenters => "assets/maps/icons/school_pin.svg",
      SearchCategoryMessage.recreationCenters =>
        "assets/maps/icons/school_pin.svg",
    };
  }

  String cardIconName() {
    return switch (this) {
      SearchCategoryMessage.mousques =>
        "assets/maps/icons/card_icon/mosque.png",
      SearchCategoryMessage.gasStations =>
        "assets/maps/icons/card_icon/station.png",
      SearchCategoryMessage.cafe => "assets/maps/icons/card_icon/coffee.png",
      SearchCategoryMessage.restaurants =>
        "assets/maps/icons/card_icon/resturant.png",
      SearchCategoryMessage.parks => "assets/maps/icons/card_icon/park.png",
      SearchCategoryMessage.hospitals =>
        "assets/maps/icons/card_icon/hospital.png",
      SearchCategoryMessage.schools => "assets/maps/icons/card_icon/school.png",
      SearchCategoryMessage.pharmacies =>
        "assets/maps/icons/card_icon/pharmacy.png",
      SearchCategoryMessage.dentalCenters =>
        "assets/maps/icons/card_icon/dental.png",
      SearchCategoryMessage.hotels => "assets/maps/icons/card_icon/school.png",
      SearchCategoryMessage.beautyCenters =>
        "assets/maps/icons/card_icon/school.png",
      SearchCategoryMessage.recreationCenters =>
        "assets/maps/icons/card_icon/school.png",
    };
  }

  Color cardIconColor() {
    return switch (this) {
      SearchCategoryMessage.mousques => Color(0xFFC8A83A),
      SearchCategoryMessage.gasStations => Color(0xFF2E88F6),
      SearchCategoryMessage.cafe => AppColor.secondary200Light,
      SearchCategoryMessage.restaurants => Color(0xFFC8A83A),
      SearchCategoryMessage.parks => AppColor.secondary200Light,
      SearchCategoryMessage.hospitals => Color(0xff50A99E),
      SearchCategoryMessage.schools => Color(0xff976403),
      SearchCategoryMessage.dentalCenters => Color(0xff036197),
      SearchCategoryMessage.pharmacies => Color(0xff5F9703),
      SearchCategoryMessage.hotels => Colors.yellow,
      SearchCategoryMessage.beautyCenters => Colors.amber,
      SearchCategoryMessage.recreationCenters => Colors.amber,
    };
  }
}
