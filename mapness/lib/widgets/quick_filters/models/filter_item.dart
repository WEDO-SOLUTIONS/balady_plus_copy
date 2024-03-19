class FilterItem {
  FilterItem({
    required this.filterType, required this.icon, required this.onTap, this.title,
    this.index,
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
