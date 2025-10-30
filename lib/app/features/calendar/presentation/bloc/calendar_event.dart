import 'package:equatable/equatable.dart';

import '../../../events/domain/entities/events_category/events_category_item.dart';
import '../../domain/entities/search_calendar/search_calendar_params.dart';

abstract class CalendarEvent extends Equatable {
  const CalendarEvent();

  @override
  List<Object> get props => [];
}

class GetSearchEvent extends CalendarEvent {
  final SearchCalendarParams? params;
  final bool update;
  const GetSearchEvent({this.params, this.update = true});
}

class GetSeasonsEvent extends CalendarEvent {
  const GetSeasonsEvent();
}

class UpdateSearchParamsEvent extends CalendarEvent {
  final String? searchKeyword;

  final EventCategoryItem? selectedSeason;
  final DateTime? fromDate;
  final DateTime? toDate;

  const UpdateSearchParamsEvent(
      this.selectedSeason, this.fromDate, this.toDate, this.searchKeyword);
}

class GetMoreSearchEvent extends CalendarEvent {
  const GetMoreSearchEvent();
}

class GetCalendarDetailsEvent extends CalendarEvent {
  final String id;
  const GetCalendarDetailsEvent({required this.id});
}
