import 'dart:ui';

import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:dgis_map/library.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

extension SearchCategoryData on SearchCategoryMessage {
  String displayName() {
    return switch (this) {
      SearchCategoryMessage.mousques => "mosques".tr(),
      SearchCategoryMessage.gasStations => "stations".tr(),
      SearchCategoryMessage.cafe => "cafe".tr(),
      SearchCategoryMessage.restaurants => "restaurants".tr(),
      SearchCategoryMessage.parks => "park".tr()
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
      SearchCategoryMessage.parks => "assets/maps/icons/poi_park_light.svg"
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
        "assets/maps/icons/ic_marker_gardens_parks.svg"
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
        "assets/maps/icons/card_icon/restaurant.png",
      SearchCategoryMessage.parks => "assets/maps/icons/card_icon/park.png"
    };
  }

  Color cardIconColor() {
    return switch (this) {
      SearchCategoryMessage.mousques => Color(0xFFC8A83A),
      SearchCategoryMessage.gasStations => Color(0xFF2E88F6),
      SearchCategoryMessage.cafe => AppColor.secondary200Light,
      SearchCategoryMessage.restaurants => Color(0xFFC8A83A),
      SearchCategoryMessage.parks => AppColor.secondary200Light,
    };
  }
}
