import 'package:dgis_map/library.dart';

extension SearchCategoryData on SearchCategoryMessage {
  String displayName() {
    return switch (this) {
      SearchCategoryMessage.mousques => "مساجد",
      SearchCategoryMessage.gasStations => "محطات",
      SearchCategoryMessage.cafe => "مقاهي",
      SearchCategoryMessage.restaurants => "مطاعم",
      SearchCategoryMessage.parks => "حدائق"
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
        "assets/maps/icons/card_icon/mosque.svg",
      SearchCategoryMessage.gasStations =>
        "assets/maps/icons/card_icon/restaurant.svg",
      SearchCategoryMessage.cafe => "assets/maps/icons/card_icon/coffee.svg",
      SearchCategoryMessage.restaurants =>
        "assets/maps/icons/card_icon/restaurant.svg",
      SearchCategoryMessage.parks =>
        "assets/maps/icons/card_icon/restaurant.svg"
    };
  }
}
