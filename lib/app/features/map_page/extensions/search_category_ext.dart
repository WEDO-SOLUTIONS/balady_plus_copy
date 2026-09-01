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
      //TODO: (scroollocker) Fix this leater
      SearchCategoryMessage.beaches => "الشواطئ",
    };
  }

  String iconName() {
    return switch (this) {
      //TODO: (scroollocker) Fix this leater
      SearchCategoryMessage.beaches => "assets/maps/icons/poi_beach_light.svg",
      SearchCategoryMessage.mousques => "assets/maps/icons/poi_mousques_light.svg",
      SearchCategoryMessage.gasStations => "assets/maps/icons/poi_gas_station_light.svg",
      SearchCategoryMessage.cafe => "assets/maps/icons/poi_cafe_light.svg",
      SearchCategoryMessage.restaurants => "assets/maps/icons/poi_eat_light.svg",
      SearchCategoryMessage.parks => "assets/maps/icons/poi_park_light.svg",
      SearchCategoryMessage.hospitals => "assets/maps/icons/hospital_category_icon.svg",
      SearchCategoryMessage.schools => "assets/maps/icons/school_category_icon.svg",
      SearchCategoryMessage.pharmacies => "assets/maps/icons/pahrmacy_poi.svg",
      SearchCategoryMessage.dentalCenters => "assets/maps/icons/dental_poi.svg",
      SearchCategoryMessage.hotels => "assets/maps/icons/school_category_icon.svg",
      SearchCategoryMessage.beautyCenters => "assets/maps/icons/school_category_icon.svg",
      SearchCategoryMessage.recreationCenters => "assets/maps/icons/school_category_icon.svg",
    };
  }

  String markerIconName() {
    return switch (this) {
      //TODO: (scroollocker) Fix this leater
      SearchCategoryMessage.beaches => "assets/maps/icons/ic_marker_beach.svg",
      SearchCategoryMessage.mousques => "assets/maps/icons/ic_marker_mosques.svg",
      SearchCategoryMessage.gasStations => "assets/maps/icons/ic_marker_gas_stations.svg",
      SearchCategoryMessage.cafe => "assets/maps/icons/poi_cafe_light.svg",
      SearchCategoryMessage.restaurants => "assets/maps/icons/ic_marker_restaurant.svg",
      SearchCategoryMessage.parks => "assets/maps/icons/ic_marker_gardens_parks.svg",
      SearchCategoryMessage.hospitals => "assets/maps/icons/hospital_pin.svg",
      SearchCategoryMessage.schools => "assets/maps/icons/school_pin.svg",
      SearchCategoryMessage.pharmacies => "assets/maps/icons/pharmacy_pin.svg",
      SearchCategoryMessage.dentalCenters => "assets/maps/icons/dental_pin.svg",
      SearchCategoryMessage.hotels => "assets/maps/icons/school_pin.svg",
      SearchCategoryMessage.beautyCenters => "assets/maps/icons/school_pin.svg",
      SearchCategoryMessage.recreationCenters => "assets/maps/icons/school_pin.svg",
    };
  }

  String cardIconName() {
    return switch (this) {
      SearchCategoryMessage.mousques => "assets/maps/icons/card_icon/mosque.webp",
      SearchCategoryMessage.gasStations => "assets/maps/icons/card_icon/station.webp",
      SearchCategoryMessage.cafe => "assets/maps/icons/card_icon/coffee.png",
      SearchCategoryMessage.restaurants => "assets/maps/icons/card_icon/resturant.webp",
      SearchCategoryMessage.parks => "assets/maps/icons/card_icon/park.webp",
      SearchCategoryMessage.hospitals => "assets/maps/icons/card_icon/hospital.webp",
      SearchCategoryMessage.schools => "assets/maps/icons/card_icon/school.webp",
      SearchCategoryMessage.pharmacies => "assets/maps/icons/card_icon/pharmacy.webp",
      SearchCategoryMessage.dentalCenters => "assets/maps/icons/card_icon/dental.webp",
      SearchCategoryMessage.hotels => "assets/maps/icons/card_icon/school.webp",
      SearchCategoryMessage.beautyCenters => "assets/maps/icons/card_icon/school.webp",
      SearchCategoryMessage.recreationCenters => "assets/maps/icons/card_icon/school.webp",
      //TODO: (scroollocker) Fix this leater
      SearchCategoryMessage.beaches => "assets/maps/icons/card_icon/beach.png",
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
      //TODO: (scroollocker) Fix this leater
      SearchCategoryMessage.beaches => Colors.amber,
    };
  }

  List<int> get rubrics => switch (this) {
    SearchCategoryMessage.mousques => const [13374],
    SearchCategoryMessage.gasStations => const [18547],
    SearchCategoryMessage.cafe => const [159, 162],
    SearchCategoryMessage.restaurants => const [161, 165, 161, 9786, 162, 469, 58871],
    SearchCategoryMessage.parks => const [168],
    SearchCategoryMessage.beaches => const [168],
    SearchCategoryMessage.hospitals => const [201],
    SearchCategoryMessage.schools => const [245],
    SearchCategoryMessage.pharmacies => const [207],
    SearchCategoryMessage.dentalCenters => const [222],
    SearchCategoryMessage.hotels => const [269],
    SearchCategoryMessage.beautyCenters => const [
      56759,
      110351,
      382,
      4521,
      4517,
      5603,
      651,
      58858,
      4518,
      652,
      13726,
      110355,
      13102,
      53986,
      110352,
    ],
    SearchCategoryMessage.recreationCenters => const [
      537,
      169,
      169,
      170,
      110358,
      51001,
      24472,
      173,
      110300,
      630,
      110388,
      110358,
      190,
      110358,
    ],
  };
}
