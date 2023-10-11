class EventCategoryItem {
  final int? id;
  final String? nameEn;
  final String? name;

  EventCategoryItem({
    this.id,
    this.name,
    this.nameEn,
  });

  String? get text => name;
}
