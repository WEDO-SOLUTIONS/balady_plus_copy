import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../notifications/data/model/notifications_settings_list/notifications_settings_list_response.dart';
import '../../../notifications/domain/entities/set_notifications_profile_params.dart';
import '../../../notifications/domain/repositories/notification_repository.dart';
part 'notifications_setting_state.dart';

class NotificationsSettingCubit extends Cubit<NotificationsSettingState> {
  NotificationsSettingsListRepository notificationsSettingsListRepository;
  final String notificationId;
  late NotificationsSettingsList notificationsSettingsList;

  NotificationsSettingCubit(
      {required this.notificationsSettingsListRepository,
      required this.notificationId})
      : super(InitialNotificationsSettingsState()) {
    getNotificationSetting(notificationId);
  }

  Future<void> getNotificationSetting(String notificationId) async {
    emit(LoadingEventsSettingsState());
    final failureOrSuccess = await notificationsSettingsListRepository
        .getNotificationsSettingsList(notificationChannelId: notificationId);
    failureOrSuccess.fold(
      (failure) {
        if (failure is NoDataFoundException) {
          emit(EmptyNotificationsSettingsState());
        } else if (failure is ServerFailure) {
          emit(FailureNotificationsSettingsState(
              errorMessage: failure.errorMessage));
        } else {
          emit(FailureNotificationsSettingsState(errorMessage: "error"));
        }
      },
      (notificationsSettingsList) {
        this.notificationsSettingsList = notificationsSettingsList;
        emit(SucceedEventsNotificationState(
          isChecked: notificationsSettingsList.enabled!,
        ));
      },
    );
  }

  Future<void> setNotificationsProfile(
      SetNotificationsProfileParams params, bool isChecked) async {
    emit(LoadingEventsSettingsState());
    final failureOrSuccess = await notificationsSettingsListRepository
        .setNotificationsProfile(params: params);
    failureOrSuccess.fold(
      (failure) {
        if (failure is NoDataFoundException) {
          emit(EmptyNotificationsSettingsState());
        } else if (failure is ServerFailure) {
          emit(FailureNotificationsSettingsState(
              errorMessage: failure.errorMessage));
        } else {
          emit(FailureNotificationsSettingsState(errorMessage: "error"));
        }
      },
      (responseStatusCode) {
        if (responseStatusCode) {
          emit(SucceedEventsNotificationState(isChecked: isChecked));
        }
      },
    );
  }
}
