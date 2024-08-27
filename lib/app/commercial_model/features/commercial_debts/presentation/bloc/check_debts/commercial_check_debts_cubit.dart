import 'package:balady_plus/app/commercial_model/features/commercial_debts/presentation/bloc/check_debts/commercial_check_debts_state.dart';
import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/data/models/commercial_debts_model.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/data/models/commercial_debts_steps.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/data/repositories/commercial_debts_repository.dart';
import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommercialDebtsCubit extends Cubit<CommercialDebtsState> {
  final CommercialDebtRepository repository;

  final TransactionType transactionType;

  final List<String> steps;

  final CommercialLicenseServiceId serviceId;

  ////////////////////////////////////////////////////////////////////////////
  CommercialDebtsCubit({
    required this.transactionType,
    int? transactionId,
    required this.steps,
    required this.serviceId,
  })  : repository = sl(),
        super(const CommercialDebtsState()) {
    if (transactionId != null) {
      checkDebts(0, transactionId);
    }
  }

  void checkDebts(int stepNumber, int transactionId) async {
    try {
      // check if have Fake Step to agnore the action
      // and check on index of step
      if (steps[stepNumber].isNotEmpty &&
          (stepNumber >= 0 && stepNumber < steps.length)) {
        emit(const LoadingCommercialDebtState());
        CommercialDebt debt = await repository.checkDebts(
          transactionType: transactionType,
          transactionId: transactionId,
          stepId: steps[stepNumber],
          serviceId: serviceId,
        );
        switch (debt.status) {
          case CommercialDebtRenewStates.warning:
          case CommercialDebtRenewStates.blocked:
            emit(
              SuccessCommercialDebtState(
                commercialDebt: debt,
                transactionType: transactionType,
                transactionId: transactionId,
                isBlocked: CommercialDebtRenewStates.blocked == debt.status,
              ),
            );
            break;
          case CommercialDebtRenewStates.noDebts:
            emit(const NoDebtsCommercialDebtState());
            break;
        }
      }
    } on ServerException catch (error) {
      emit(
        FieldCommercialDebtState(
          errorMessage: error.errorMessage,
          stepNumber: stepNumber,
          transactionId: transactionId,
        ),
      );
    } catch (error, stackTrace) {
      emit(
        FieldCommercialDebtState(
          errorMessage: error.toString(),
          stepNumber: stepNumber,
          transactionId: transactionId,
        ),
      );
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
  }
}
