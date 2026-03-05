part of 'notifications_setting_cubit.dart';

class NotificationsSettingState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

final class InitialNotificationsSettingsState implements NotificationsSettingState {
  @override
  List<Object?> get props => throw UnimplementedError();

  @override
  bool? get stringify => throw UnimplementedError();
}

final class LoadingEventsSettingsState extends NotificationsSettingState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

final class EmptyNotificationsSettingsState extends NotificationsSettingState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

final class FailureNotificationsSettingsState extends NotificationsSettingState {
  final String errorMessage;

  FailureNotificationsSettingsState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

final class SucceedEventsNotificationState extends NotificationsSettingState {
  final bool isChecked;

  SucceedEventsNotificationState({required this.isChecked});

  @override
  List<Object?> get props => [isChecked];
}
