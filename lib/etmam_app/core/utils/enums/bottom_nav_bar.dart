import '../utils_exports.dart' show IconPath;

enum BottomNavBarI {
  home,
  orders,
  favorite,
  profile,
}

enum BottomNavBar {
  home(
      icon: IconPath.bottomNavigationOrdersIcon,
      label: "home_bottom_navigation"),
  orders(
      icon: IconPath.bottomNavigationOrdersIcon,
      label: "orders_bottom_navigation"),
  favorite(
      icon: IconPath.bottomNavigationFavoriteIcon,
      label: "favorite_bottom_navigation"),
  profile(
      icon: IconPath.bottomNavigationProfileIcon,
      label: "profile_bottom_navigation");

  const BottomNavBar({required this.icon, required this.label});
  final Object icon;
  final String label;
}
