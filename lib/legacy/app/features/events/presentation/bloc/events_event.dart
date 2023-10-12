import 'package:equatable/equatable.dart';

import '../../domain/entities/events_category/events_category_item.dart';
import '../../domain/entities/search_events/search_events_params.dart';

abstract class EventsEvent extends Equatable {
  const EventsEvent();

  @override
  List<Object> get props => [];
}

class GetSearchEvent extends EventsEvent {
  final SearchEventsParams? params;
  const GetSearchEvent({this.params});
}

class GetEventsDetails extends EventsEvent {
  final String id;
  const GetEventsDetails({required this.id});
}

class GetCategoriesEvent extends EventsEvent {
  const GetCategoriesEvent();
}

class GetAudienceEvent extends EventsEvent {
  const GetAudienceEvent();
}

class GetSeasonsEvent extends EventsEvent {
  const GetSeasonsEvent();
}

class GetCitiesEvent extends EventsEvent {
  const GetCitiesEvent();
}

class GetFeesEvent extends EventsEvent {
  const GetFeesEvent();
}

class UpdateSearchParamsEvent extends EventsEvent {
  final String? searchKeyword;

  final EventCategoryItem? selectedCity;
  final EventCategoryItem? selectedSeason;
  final EventCategoryItem? selectedCategory;
  final EventCategoryItem? selectedAudince;
  final DateTime? fromDate;
  final DateTime? toDate;
  final String? sortBy;

  const UpdateSearchParamsEvent(
      this.selectedCity,
      this.selectedSeason,
      this.selectedCategory,
      this.selectedAudince,
      this.fromDate,
      this.toDate,
      this.sortBy,
      this.searchKeyword);
}

class GetMoreSearchEvent extends EventsEvent {
  const GetMoreSearchEvent();
}
