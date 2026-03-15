part of 'notifications_list_settings_cubit.dart';

class NotificationsListSettingsState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

final class InitialNotificationsSettingsState
    implements NotificationsListSettingsState {
  @override
  List<Object?> get props => throw UnimplementedError();

  @override
  bool? get stringify => throw UnimplementedError();
}

final class LoadingEventsSettingsState extends NotificationsListSettingsState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

final class EmptyNotificationsSettingsState
    extends NotificationsListSettingsState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

final class FailureNotificationsSettingsState
    extends NotificationsListSettingsState {
  final String errorMessage;

  FailureNotificationsSettingsState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

final class SucceedEventsNotificationState
    extends NotificationsListSettingsState {
  final bool isChecked;

  SucceedEventsNotificationState({required this.isChecked});

  @override
  List<Object?> get props => [isChecked];
}
