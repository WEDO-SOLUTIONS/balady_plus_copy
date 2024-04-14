part of 'events_list_cubit.dart';

class EventsListState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

final class InitialEventsListState implements EventsListState {
  @override
  List<Object?> get props => throw UnimplementedError();

  @override
  bool? get stringify => throw UnimplementedError();
}

final class LoadingEventsListState extends EventsListState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

final class FailureEventsListState extends EventsListState {
  final String filerMessage;

  FailureEventsListState({required this.filerMessage});

  @override
  List<Object?> get props => [filerMessage];
}

final class SucceedEventsListState extends EventsListState {
  final Map<int, List<CalendarEventItem>> event;
  final List<MonthsEventsCount> listMonths;
  SucceedEventsListState({required this.event, required this.listMonths});

  @override
  List<Object?> get props => [event, listMonths, listMonths.length];
}

// final class SucceedWithLoadingEventsListState extends SucceedEventsListState {
//   SucceedWithLoadingEventsListState({required event, required listMonths})
//       : super(
//           event: event,
//           listMonths: listMonths,
//         );
//
//   @override
//   List<Object?> get props => [event];
// }

final class SucceedWithPaginationEventsListState
    extends SucceedEventsListState {
  // to get new state
  final int page;

  SucceedWithPaginationEventsListState(
      {required this.page, required event, required listMonths})
      : super(event: event, listMonths: listMonths);

  @override
  List<Object?> get props =>
      [page, event.length, listMonths, listMonths.length];
}
