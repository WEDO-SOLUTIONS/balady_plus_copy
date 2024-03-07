import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/features/notifications/data/model/notifications_list/deleted_notifications_params.dart';
import 'package:balady_plus/app/features/notifications/data/model/notifications_list/mark_read_notifications_params.dart';
import 'package:balady_plus/app/features/notifications/data/model/notifications_list/notifications_list_response.dart';
import 'package:balady_plus/app/features/notifications/data/model/notifications_list/notifications_message_item.dart';
import 'package:balady_plus/app/features/notifications/data/model/notifications_list/search_notifications_params.dart';
import 'package:balady_plus/app/features/notifications/domain/repositories/notification_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

part 'notifications_list_state.dart';

class NotificationsListCubit extends Cubit<NotificationsListState> {
  final NotificationsListRepository baladyCalendarRepository;
  final SearchNotificationsParams params;

  NotificationsListCubit({
    required this.baladyCalendarRepository,
    required this.params,
  }) : super(InitialNotificationsListState()) {
    getNotificationsMessagesList(params);
  }

  Future<void> getNotificationsMessagesList(
    SearchNotificationsParams params,
  ) async {
    NotificationsListState stateType = state;
    if (stateType is InitialNotificationsListState ||
        stateType is SucceedWithPaginationNotificationsListState ||
        stateType is FailureNotificationsListState) {
      if (stateType is! SucceedWithPaginationNotificationsListState) {
        emit(LoadingEventsListState());
      }
      Either<Failure, NotificationsListResponse> failureOrSuccess =
          await baladyCalendarRepository.getNotificationsMessagesList(
        request: params,
      );
      failureOrSuccess.fold(
        (failure) {
          if (failure is NoDataFoundException) {
            emit(FailureNotificationsListState(
                filerMessage: "no_data_shown".tr()));
          } else if (failure is ServerFailure) {
            emit(FailureNotificationsListState(
                filerMessage: failure.errorMessage));
          }
        },
        (listMessages) {
          List<NotificationsMessageItem> type = [];
          if (stateType is SucceedWithPaginationNotificationsListState) {
            type = stateType.listMessages;
          }
          type += listMessages.listMessages;
          if ((listMessages.totalPageCount - 1) == params.page) {
            if(type.isEmpty){
              emit(EmptyNotificationsListState());
            } else {
              emit(SucceedEventsListState(listMessages: type));
            }
          } else {
            emit(
              SucceedWithPaginationNotificationsListState(
                page: params.page,
                listMonths: type,
              ),
            );
          }
          params.page++;
        },
      );
    }
  }

  Future<void> markReadNotificationsMessages(
    MarkReadNotificationsParams params,
  ) async {
    NotificationsListState stateType = state;
    if (stateType is InitialNotificationsListState ||
        stateType is SucceedWithPaginationNotificationsListState ||
        stateType is FailureNotificationsListState) {
      if (stateType is! SucceedWithPaginationNotificationsListState) {
        emit(LoadingEventsListState());
      }
      Either<Failure, bool> failureOrSuccess =
          await baladyCalendarRepository.markReadNotificationsMessages(
        request: params,
      );
      failureOrSuccess.fold(
        (failure) {
          // if (failure is NoDataFoundException) {
          //   emit(FailureNotificationsListState(
          //       filerMessage: "no_data_shown".tr()));
          // } else if (failure is ServerFailure) {
          //   emit(FailureNotificationsListState(
          //       filerMessage: failure.errorMessage));
          // }
        },
        (done) {
          getNotificationsMessagesList(this.params);
        },
      );
    }
  }

  Future<void> deletedNotificationsMessages(
    DeletedNotificationsParams params,
  ) async {
    NotificationsListState stateType = state;
    if (stateType is! LoadingEventsListState) {
      emit(LoadingEventsListState());
      Either<Failure, bool> failureOrSuccess =
          await baladyCalendarRepository.deletedNotificationsMessages(
        request: params,
      );
      failureOrSuccess.fold(
        (failure) {
          if (failure is NoDataFoundException) {
            emit(FailureNotificationsListState(
                filerMessage: "no_data_shown".tr()));
          } else if (failure is ServerFailure) {
            emit(FailureNotificationsListState(
                filerMessage: failure.errorMessage));
          }
        },
        (done) {
          emit(EmptyNotificationsListState());
        },
      );
    }
  }
}
