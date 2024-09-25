import 'package:balady_plus/app/commercial_model/features/commercial_debts/data/models/commercial_debts_model.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/data/models/commercial_debts_steps.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/data/models/commercial_list_debts_model.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/data/repositories/commercial_list_debts_repository.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/presentation/bloc/commercial_list_debts/commercial_list_debts_state.dart';
import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommercialListDebtsCubit extends Cubit<ListDebtsState> {
  final CommercialListDebtRepository repository;

  final String referenceId;
  final TransactionType transactionType;
  final int transactionId;

  ////////////////////////////////////////////////////////////////////////////
  CommercialListDebtsCubit({
    required this.referenceId,
    required this.transactionType,
    required this.transactionId,
  })  : repository = sl(),
        super(const ListDebtsState()) {
    getListDebts(
      // referenceId: referenceId,
      // transactionType: transactionType,
      // transactionId: transactionId,
      pageNumber: 1,
    );
  }

  void getListDebts({
    // required String referenceId,
    // required int transactionId,
    // required TransactionType transactionType,
    required int pageNumber,
  }) async {
    try {
      ListDebtsState stateType = state;
      if (stateType is! SucceedWithPaginationListDebtState) {
        emit(const LoadingListDebtState());
      }
      CommercialListDebt listDebts = await repository.getListDebts(
        transactionType: TransactionType.REQUEST,
        transactionId: transactionId,
        referenceId: referenceId,
        pageNumber: pageNumber,
      );
      List<Debt> type = [];
      if (stateType is SucceedWithPaginationListDebtState) {
        type = stateType.listDebts;
      }
      type += listDebts.listMessages;
      if ((listDebts.totalPageCount - 1) == pageNumber) {
        if (type.isEmpty) {
          emit(const NoListDebtsDebtState());
        } else {
          emit(SuccessListDebtState(listDebts: listDebts.listMessages));
        }
      } else {
        emit(
          SucceedWithPaginationListDebtState(
            page: pageNumber++,
            listDebts: type,
          ),
        );
      }
    } on ServerException catch (error) {
      emit(FieldListDebtState(
        errorMessage: error.errorMessage,
        pageNumber: pageNumber,
      ));
    } catch (error, stackTrace) {
      emit(FieldListDebtState(
        errorMessage: error.toString(),
        pageNumber: pageNumber,
      ));
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
