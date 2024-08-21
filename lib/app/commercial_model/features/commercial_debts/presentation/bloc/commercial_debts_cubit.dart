import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/data/models/commercial_debts_model.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/data/models/commercial_debts_steps.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/data/repositories/commercial_debts_repository.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/presentation/bloc/commercial_debts_state.dart';
import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommercialDebtsCubit extends Cubit<CommercialDebtsState> {
  final CommercialDebtRepository repository;

  final TransactionType transactionType;
  final int transactionId;
  final List<String> steps;

  ////////////////////////////////////////////////////////////////////////////
  CommercialDebtsCubit({
    required this.transactionType,
    required this.transactionId,
    required this.steps,
  })  : repository = sl(),
        super(const CommercialDebtsState()) {
    getBoardsContracts(0);
  }

  void getBoardsContracts(int stepNumber) async {
    try {
      emit(const LoadingCommercialDebtState());
      CommercialDebt debt = await repository.getDebts(
        transactionType: transactionType,
        transactionId: transactionId,
        stepId: steps[stepNumber],
      );
      switch (debt.status) {
        case CommercialDebtRenewStates.warning:
        case CommercialDebtRenewStates.blocked:
          emit(SuccessCommercialDebtState(commercialDebt: debt));
          break;
        case CommercialDebtRenewStates.noDebts:
          emit(const NoDebtsCommercialDebtState());
          break;
      }
    } on ServerException catch (error) {
      emit(
        FieldCommercialDebtState(
          errorMessage: error.errorMessage,
          stepNumber: stepNumber,
        ),
      );
    } catch (error, stackTrace) {
      emit(
        FieldCommercialDebtState(
          errorMessage: error.toString(),
          stepNumber: stepNumber,
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
