class FilterItem {
  FilterItem({
    this.title,
    required this.filterType,
    required this.icon,
    this.index,
    required this.onTap,
  });

  final String? title;
  final String icon;
  FilterType filterType;
  final int? index;
  void Function() onTap;
}

enum FilterType {
  custom,
  home,
  work,
  favourites,
  quick,
}
