import '../utils_exports.dart' show IconPath;

enum WeathherConditions {
  clear(icon: IconPath.partlyClouded, label: "clear"),
  partlyClouded(icon: IconPath.partlyClouded, label: "partlyClouded"),
  cloudy(icon: IconPath.partlyClouded, label: "cloudy"),
  rainy(icon: IconPath.partlyClouded, label: "rainy"),
  snowy(icon: IconPath.partlyClouded, label: "snowy"),
  thunderstorm(icon: IconPath.partlyClouded, label: "thunderstorm"),
  windy(icon: IconPath.partlyClouded, label: "windy"),
  foggy(icon: IconPath.partlyClouded, label: "foggy");

  const WeathherConditions({required this.icon, required this.label});
  final Object icon;
  final String label;
}
