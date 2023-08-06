import '../utils_exports.dart' show IconPath;

enum BottomNavBar {
  home(icon: IconPath.home, label: "home"),
  // nearby(icon: IconPath.nearby, label: "nearby"),
  services(icon: IconPath.services, label: "services"),
  profile(icon: IconPath.profile, label: "profile");

  const BottomNavBar({required this.icon, required this.label});
  final Object icon;
  final String label;
}
