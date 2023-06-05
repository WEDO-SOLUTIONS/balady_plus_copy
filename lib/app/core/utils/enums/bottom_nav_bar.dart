import '../utils_exports.dart' show IconPath;

enum BottomNavBar {
  home(icon: IconPath.home, label: "home"),
  services(icon: IconPath.services, label: "services"),
  activities(icon: IconPath.activities, label: "activities"),
  more(icon: IconPath.more, label: "more"),
  ;

  const BottomNavBar({required this.icon, required this.label});
  final Object icon;
  final String label;
}
