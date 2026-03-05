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
import 'package:jiffy/jiffy.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
part 'notifications_list_state.dart';

class NotificationsListCubit extends Cubit<NotificationsListState> {
  final NotificationsListRepository listRepository;
  SearchNotificationsParams params;

  NotificationsListCubit({
    required this.listRepository,
    required this.params,
  }) : super(InitialNotificationsListState()) {
    Jiffy.setLocale("locale".tr());
    getNotificationsMessagesList();
  }

  Future<void> getNotificationsMessagesList({bool loadMore = false}) async {
    if (!loadMore) {
      params.page = 0;
      emit(InitialNotificationsListState());
    }

    NotificationsListState stateType = state;
    // if (stateType is InitialNotificationsListState ||
    //     stateType is SucceedWithPaginationNotificationsListState ||
    //     stateType is FailureNotificationsListState) {
    if (stateType is! SucceedWithPaginationNotificationsListState) {
      emit(LoadingEventsListState());
    }
    Either<Failure, NotificationsListResponse> failureOrSuccess = await listRepository.getNotificationsMessagesList(
      request: params,
    );
    failureOrSuccess.fold(
      (failure) {
        if (failure is NoDataFoundException || failure is NoDataFoundFailure) {
          emit(EmptyNotificationsListState());
        } else if (failure is ServerFailure) {
          emit(FailureNotificationsListState(filerMessage: failure.errorMessage));
        } else {
          emit(FailureNotificationsListState(filerMessage: "error"));
        }
      },
      (listMessages) {
        List<NotificationsMessageItem> type = [];
        if (stateType is SucceedWithPaginationNotificationsListState) {
          type = stateType.listMessages;
        }
        type += listMessages.listMessages;
        if ((listMessages.totalPageCount - 1) == params.page) {
          if (type.isEmpty) {
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
    // }
  }

  Future<void> markReadNotificationsMessages() async {
    NotificationsListState stateType = state;
    if (stateType is! LoadingEventsListState) {
      emit(LoadingEventsListState());
      Either<Failure, bool> failureOrSuccess = await listRepository.markReadNotificationsMessages(
        request: MarkReadNotificationsParams(
          productId: params.productId,
          serviceId: params.serviceId,
          all: true,
          read: true,
          persoana: params.persoana,
        ),
      );
      failureOrSuccess.fold(
        (failure) {
          if (failure is NoDataFoundException || failure is NoDataFoundFailure) {
            emit(FailureNotificationsListState(filerMessage: "no_data_shown".tr()));
          } else if (failure is ServerFailure) {
            emit(FailureNotificationsListState(filerMessage: failure.errorMessage));
          } else {
            emit(FailureNotificationsListState(filerMessage: "error"));
          }
        },
        (done) async {
          emit(InitialNotificationsListState());
          await Future.delayed(const Duration(seconds: 4));
          getNotificationsMessagesList();
        },
      );
    }
  }

  Future<void> deletedNotificationsMessages() async {
    NotificationsListState stateType = state;
    if (stateType is! LoadingEventsListState) {
      emit(LoadingEventsListState());
      Either<Failure, bool> failureOrSuccess = await listRepository.deletedNotificationsMessages(
        request: DeletedNotificationsParams(
          productId: params.productId,
          serviceId: params.serviceId,
          all: true,
          persoana: params.persoana,
        ),
      );
      failureOrSuccess.fold(
        (failure) {
          if (failure is NoDataFoundException || failure is NoDataFoundFailure) {
            emit(EmptyNotificationsListState());
          } else if (failure is ServerFailure) {
            emit(FailureNotificationsListState(filerMessage: failure.errorMessage));
          } else {
            emit(FailureNotificationsListState(filerMessage: "error"));
          }
        },
        (done) {
          emit(EmptyNotificationsListState());
        },
      );
    }
  }
}
