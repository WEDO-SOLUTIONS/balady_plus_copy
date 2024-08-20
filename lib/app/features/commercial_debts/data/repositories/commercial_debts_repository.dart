import 'dart:async';

import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/features/commercial_debts/data/data_sources/commercial_debts_data_sources.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:balady_plus/app/features/commercial_debts/data/models/commercial_debts_model.dart';
import 'package:balady_plus/app/features/commercial_debts/data/models/commercial_debts_steps.dart';

///////////////////////////////////////////////////

class CommercialDebtRepository {
  final CommercialDebtsDataSources remoteDataSource;

  CommercialDebtRepository(this.remoteDataSource);

  Future<CommercialDebt> getDebts({
    required TransactionType transactionType,
    required int transactionId,
    required String stepId,
  }) async {
    try {
      final data = await remoteDataSource.getDebts(
        transactionType: transactionType,
        transactionId: transactionId,
        stepId: stepId  ,
      );
      return data;
    } on ServerException catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      rethrow;
    }
  }
}
