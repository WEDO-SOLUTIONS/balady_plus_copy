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
      SearchCategoryMessage.mousques => "assets/maps/icons/mosque.svg",
      SearchCategoryMessage.gasStations => "assets/maps/icons/gas-station.svg",
      SearchCategoryMessage.cafe => "assets/maps/icons/cafe.svg",
      SearchCategoryMessage.restaurants => "assets/maps/icons/eat.svg",
      SearchCategoryMessage.parks => "assets/maps/icons/parks.svg"
    };
  }
}
