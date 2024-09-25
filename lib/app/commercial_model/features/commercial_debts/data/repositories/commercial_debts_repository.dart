import 'dart:async';

import 'package:balady_plus/app/core/errors/exceptions.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/data/data_sources/commercial_debts_data_sources.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/data/models/commercial_debts_model.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/data/models/commercial_debts_steps.dart';

///////////////////////////////////////////////////

class CommercialDebtRepository {
  final CommercialDebtsDataSources remoteDataSource;

  CommercialDebtRepository(this.remoteDataSource);

  Future<CommercialDebt> checkDebts({
    required TransactionType transactionType,
    required int transactionId,
    required String stepId,
    required CommercialLicenseServiceId serviceId,
  }) async {
    try {
      final data = await remoteDataSource.checkDebts(
        transactionType: transactionType,
        transactionId: transactionId,
        stepId: stepId,
        serviceId: serviceId
      );
      return data;
    } on ServerException catch (error, stackTrace) {
      rethrow;
    }
  }
}
