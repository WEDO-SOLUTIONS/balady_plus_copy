import 'dart:ui';

class FavouriteSearchItem {
  FavouriteSearchItem({
    required this.distance,
    required this.name,
    required this.address,
    required this.workingHours,
    required this.workingHoursColor,
  });
  final String distance;
  final String name;
  final String address;
  final String workingHours;
  final Color workingHoursColor;
}
