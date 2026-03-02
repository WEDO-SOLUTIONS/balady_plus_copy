import 'package:balady_plus/app/features/events/data/models/events_category/events_category_item_model.dart';
import 'package:balady_plus/app/features/events/domain/entities/events_category/event_category_response.dart';
import 'package:balady_plus/app/features/events/domain/entities/events_category/events_category_item.dart';

class EventsCategoryResponseModel extends EventCategoryResponse {
  EventsCategoryResponseModel({super.items});

  factory EventsCategoryResponseModel.fromMap(Map<String, dynamic> json) => EventsCategoryResponseModel(
      items: json["result"] != null
          ? List<EventCategoryItem>.from(json["result"].map((x) => EventCategoryItemModel.fromMap(x)))
          : null);
}
