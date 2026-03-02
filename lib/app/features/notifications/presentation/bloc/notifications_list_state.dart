part of 'notifications_list_cubit.dart';

class NotificationsListState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

final class InitialNotificationsListState implements NotificationsListState {
  @override
  List<Object?> get props => throw UnimplementedError();

  @override
  bool? get stringify => throw UnimplementedError();
}

final class LoadingEventsListState extends NotificationsListState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

final class EmptyNotificationsListState extends NotificationsListState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

final class FailureNotificationsListState extends NotificationsListState {
  final String filerMessage;

  FailureNotificationsListState({required this.filerMessage});

  @override
  List<Object?> get props => [filerMessage];
}

final class SucceedEventsListState extends NotificationsListState {
  final List<NotificationsMessageItem> listMessages;

  SucceedEventsListState({required this.listMessages});

  @override
  List<Object?> get props => [listMessages, listMessages.length];
}

final class SucceedWithPaginationNotificationsListState extends SucceedEventsListState {
  final int page;

  SucceedWithPaginationNotificationsListState({
    required this.page,
    required listMonths,
  }) : super(listMessages: listMonths);

  @override
  List<Object?> get props => [page, listMessages, listMessages.length];
}
