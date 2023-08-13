import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/errors/errors_exports.dart' show ServerFailure;
import '../../../../../core/services/services_exports.dart' show NoParams;
import '../../../../../core/utils/utils_exports.dart'
    show BlocRequestStatus, Nullable;
import '../../delegators_exports.dart' show DelegatorEntity, GetDelegators;

part 'delegators_state.dart';

class DelegatorsCubit extends Cubit<DelegatorsState> {
  final GetDelegators _getDelegators;
  DelegatorsCubit(
    this._getDelegators,
  ) : super(const DelegatorsState());

  void getDelegators() async {
    if (state.delegators.isNotEmpty) return;

    emit(state.copyWith(status: BlocRequestStatus.submissionGetLoading));
    final failureOrSuccess = await _getDelegators(NoParams());

    failureOrSuccess.fold(
      (failure) {
        BlocRequestStatus status = (failure as ServerFailure).errorCode == "003"
            ? BlocRequestStatus.submissionGetSuccess
            : BlocRequestStatus.submissionGetFailure;

        emit(state.copyWith(
          status: status,
          errorMessage: failure.errorMessage,
        ));
      },
      (delegators) {
        emit(state.copyWith(
          status: BlocRequestStatus.submissionGetSuccess,
          delegators: delegators,
        ));
      },
    );
  }

  void selectDelegator(DelegatorEntity? delegator) {
    emit(state.copyWith(selectedDelegator: Nullable(delegator)));
  }
}
