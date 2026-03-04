import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/features/notifications/domain/entities/set_notifications_profile_products_params.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/errors/exceptions.dart';
import '../../../domain/repositories/notification_repository.dart';
part 'notifications_list_settings_state.dart';

class NotificationsListSettingsCubit extends Cubit<NotificationsListSettingsState> {
  NotificationsSettingsListRepository notificationsSettingsListRepository;
  bool isChecked;
  NotificationsListSettingsCubit({required this.notificationsSettingsListRepository, required this.isChecked})
      : super(InitialNotificationsSettingsState());

  Future<void> setNotificationsProfileProducts(SetNotificationsProfileProductsParams params) async {
    emit(LoadingEventsSettingsState());
    final failureOrSuccess = await notificationsSettingsListRepository.setNotificationsProfileProducts(params: params);
    failureOrSuccess.fold(
      (failure) {
        if (failure is NoDataFoundException) {
          emit(EmptyNotificationsSettingsState());
        } else if (failure is ServerFailure) {
          emit(FailureNotificationsSettingsState(errorMessage: failure.errorMessage));
        } else {
          emit(FailureNotificationsSettingsState(errorMessage: "error"));
        }
      },
      (responseStatusCode) {
        if (responseStatusCode) {
          isChecked = params.enabled!;
          emit(SucceedEventsNotificationState(isChecked: isChecked));
        }
      },
    );
  }
}
