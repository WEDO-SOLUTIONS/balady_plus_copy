import 'package:balady_plus/app/features/events/domain/entities/events_category/events_category_item.dart';

class EventCategoryItemModel extends EventCategoryItem {
  EventCategoryItemModel({
    super.id,
    super.name,
    super.nameEn,
  });
  factory EventCategoryItemModel.fromMap(Map<String, dynamic> json) => EventCategoryItemModel(
        id: json["id"],
        name: json["name"],
        nameEn: json["nameEn"],
      );
}
