import '../utils_exports.dart' show IconPath;

enum Prayers {
  fajr(icon: IconPath.fajr, label: "fajr"),
  dhuhr(icon: IconPath.dhuhr, label: "dhuhr"),
  asr(icon: IconPath.asr, label: "asr"),
  maghrib(icon: IconPath.maghrib, label: "maghrib"),
  isha(icon: IconPath.isha, label: "isha");

  const Prayers({required this.icon, required this.label});
  final Object icon;
  final String label;
}
