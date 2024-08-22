import 'package:balady_plus/app/commercial_model/features/commercial_debts/data/models/commercial_debts_model.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/data/models/commercial_debts_steps.dart';
import 'package:equatable/equatable.dart';

class CommercialDebtsState extends Equatable {
  const CommercialDebtsState();

  @override
  List<Object?> get props => throw UnimplementedError();
}

class LoadingCommercialDebtState extends CommercialDebtsState {
  const LoadingCommercialDebtState();
}

class FieldCommercialDebtState extends CommercialDebtsState {
  final String errorMessage;
  final int stepNumber;
  final int transactionId;

  const FieldCommercialDebtState({
    required this.errorMessage,
    required this.stepNumber,
    required this.transactionId,
  });

  @override
  List<Object?> get props {
    return [errorMessage, transactionId, stepNumber];
  }
}

class SuccessCommercialDebtState extends CommercialDebtsState {
  final CommercialDebt commercialDebt;
  final TransactionType transactionType;
  final int transactionId;
  final bool isBlocked;

  const SuccessCommercialDebtState({
    required this.commercialDebt,
    required this.transactionId,
    required this.transactionType,
    required this.isBlocked,
  });

  @override
  List<Object?> get props {
    return [commercialDebt];
  }
}

class NoDebtsCommercialDebtState extends CommercialDebtsState {
  const NoDebtsCommercialDebtState();
}
