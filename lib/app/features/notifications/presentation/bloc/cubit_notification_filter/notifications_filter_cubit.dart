import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/features/notifications/data/model/notifications_list/notifications_message_item.dart';
import 'package:balady_plus/app/features/notifications/domain/repositories/notification_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'notifications_filter_state.dart';

class NotificationsFilterCubit extends Cubit<NotificationsFilterState> {
  final NotificationsFilterRepository filterRepository;

  NotificationsFilterCubit({required this.filterRepository}) : super(InitialNotificationsFilterState()) {
    getNotificationsProducts();
  }

  Future<void> getNotificationsProducts() async {
    NotificationsFilterState stateType = state;
    if (stateType is InitialNotificationsFilterState || stateType is FailureNotificationsFilterState) {
      emit(LoadingNotificationsFilterState());
      Either<Failure, List<NotificationType>> failureOrSuccess = await filterRepository.getNotificationsProducts();
      failureOrSuccess.fold(
        (failure) {
          if (failure is NoDataFoundException) {
            emit(SucceedServicesFilterState(listProducts: const [], listServices: []));
          } else if (failure is ServerFailure) {
            emit(FailureNotificationsFilterState(errorMessage: failure.errorMessage));
          } else {
            emit(FailureNotificationsFilterState(errorMessage: "error"));
          }
        },
        (listProducts) {
          emit(SucceedServicesFilterState(listProducts: listProducts, listServices: []));
        },
      );
    }
  }

  Future<void> getNotificationsServicesProducts({required NotificationType product}) async {
    SucceedServicesFilterState states = state as SucceedServicesFilterState;
    emit(states.copyWith(selectedProduct: product));
    Either<Failure, List<NotificationType>> failureOrSuccess = await filterRepository.getNotificationsServicesProducts(
      productId: product.id,
    );
    failureOrSuccess.fold(
      (failure) {
        emit(states.copyWith(selectedProduct: product, listServices: []));
      },
      (listMessages) {
        emit(states.copyWith(selectedProduct: product, listServices: listMessages, selectedServices: null));
      },
    );
  }

  void selectedServices({required NotificationType service}) {
    SucceedServicesFilterState states = state as SucceedServicesFilterState;
    emit(states.copyWith(selectedServices: service));
  }
}
