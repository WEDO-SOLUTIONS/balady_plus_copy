import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/features/notifications/data/model/notifications_list/deleted_notifications_params.dart';
import 'package:balady_plus/app/features/notifications/data/model/notifications_list/mark_read_notifications_params.dart';
import 'package:balady_plus/app/features/notifications/data/model/notifications_list/notifications_message_item.dart';
import 'package:balady_plus/app/features/notifications/domain/repositories/notification_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'notifications_item_state.dart';

class NotificationsItemCubit extends Cubit<SucceedMessageState> {
  final NotificationsListRepository itemRepository;

  NotificationsItemCubit({
    required this.itemRepository,
    required NotificationsMessageItem message,
  }) : super(SucceedMessageState(message: message));

  Future<void> markReadNotificationsMessages() async {
    emit(
      SucceedMessageState(
        message: state.message.copyWith(
            status: NotificationType(
          id: 'not-red',
          text: 'not-red',
        )),
      ),
    );
    Either<Failure, bool> failureOrSuccess =
        await itemRepository.markReadNotificationsMessages(
      request: MarkReadNotificationsParams(
        all: true,
        read: true,
      ),
    );
    failureOrSuccess.fold(
      (failure) {
        emit(
          SucceedMessageState(
            message: state.message.copyWith(
                status: NotificationType(
              id: 'not-red',
              text: 'not-red',
            )),
          ),
        );
      },
      (done) {
        emit(
          SucceedMessageState(
            message: state.message.copyWith(
                status: NotificationType(
              id: 'not-red',
              text: 'not-red',
            )),
          ),
        );
      },
    );
  }

  // Future<void> deletedNotificationsMessages() async {
  //   NotificationsItemState stateType = state;
  //   if (stateType is! LoadingEventsListState) {
  //     emit(LoadingEventsListState());
  //     Either<Failure, bool> failureOrSuccess =
  //         await itemRepository.deletedNotificationsMessages(
  //       request: DeletedNotificationsParams(
  //         all: true,
  //       ),
  //     );
  //     failureOrSuccess.fold(
  //       (failure) {
  //         if (failure is NoDataFoundException ||
  //             failure is NoDataFoundException) {
  //           emit(EmptyNotificationsListState());
  //         } else if (failure is ServerFailure) {
  //           emit(FailureNotificationsListState(
  //               filerMessage: failure.errorMessage));
  //         } else {
  //           emit(FailureNotificationsListState(filerMessage: "error"));
  //         }
  //       },
  //       (done) {
  //         emit(EmptyNotificationsListState());
  //       },
  //     );
  //   }
  // }
}
