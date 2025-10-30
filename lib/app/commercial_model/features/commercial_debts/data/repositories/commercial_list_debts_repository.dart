import 'dart:async';

import 'package:balady_plus/app/commercial_model/features/commercial_debts/data/models/commercial_list_debts_model.dart';
import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/data/data_sources/commercial_debts_data_sources.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/data/models/commercial_debts_model.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/data/models/commercial_debts_steps.dart';

///////////////////////////////////////////////////

class CommercialListDebtRepository {
  final CommercialDebtsDataSources remoteDataSource;

  CommercialListDebtRepository(this.remoteDataSource);

  Future<CommercialListDebt> getListDebts({
    required String referenceId,
    required int transactionId,
    required TransactionType transactionType,
    required int pageNumber,
  }) async {
    try {
      final data = await remoteDataSource.getListDebts(
        transactionType: transactionType,
        transactionId: transactionId,
        referenceId: referenceId,
        pageNumber:pageNumber,
      );
      return data;
    } on ServerException catch (error, stackTrace) {
      rethrow;
    }
  }
}
