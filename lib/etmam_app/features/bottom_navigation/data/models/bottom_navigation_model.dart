class BottomNavigationModel {
  final int? id;
  final String? labelKey;
  final String? label;
  final String? icon;
  final String? activeIcon;

  const BottomNavigationModel(
      {required this.id,
      required this.labelKey,
      required this.label,
      required this.icon,
      required this.activeIcon});

  factory BottomNavigationModel.fromJson(Map<String, dynamic> json) =>
      BottomNavigationModel(
          id: json['id'],
          labelKey: json['labelKey'],
          label: json['label'],
          icon: json['icon'],
          activeIcon: json['activeIcon']);

  static List<BottomNavigationModel> getListOfBottomNavigationsFromListOfJsons(
          List<dynamic> json) =>
      List.generate(
        json.length,
        (index) => BottomNavigationModel.fromJson(json[index]),
      );
}
