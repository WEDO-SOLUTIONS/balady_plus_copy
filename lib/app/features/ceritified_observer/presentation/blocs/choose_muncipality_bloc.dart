import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/dependency_injection/injection_container.dart';
import '../../domain/entity/observer_status_entity.dart';
import '../../domain/use_cases/get_registered_observer_status.dart';
part  'choose_muncipality_state.dart';


class ChooseMuncipalityBloc extends Cubit<ChooseMuncipalityState> {
  final GetRegisteredObserverStatus _getRegisteredObserverStatus;




  ChooseMuncipalityBloc()
      :
        _getRegisteredObserverStatus=GetRegisteredObserverStatus(repository: sl()),
        super(const ChooseMuncipalityState()) {
    getObserverStatus("1006966525");
  }

  Future<void> getObserverStatus(String identityNumber) async {



    emit(
      state.copyWith(status: BlocRequestStatus.submissionGetLoading),
    );
    final failureOrSuccess = await _getRegisteredObserverStatus(identityNumber);
    failureOrSuccess.fold(
          (failure) {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetFailure,
            errorMessage:
            failure is ServerFailure ? (failure).errorMessage : "",
          ),
        );
      },
          (response) {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetSuccess,
            observerStatusEntity:
            (response.data!.result) as ObserverStatusEntity,
          ),
        );
      },
    );


  }
}
