import 'package:balady_plus/app/features/commercial_debts/data/models/commercial_debts_model.dart';
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

  const FieldCommercialDebtState({
    required this.errorMessage,
    required this.stepNumber,
  });

  @override
  List<Object?> get props {
    return [errorMessage];
  }
}

class SuccessCommercialDebtState extends CommercialDebtsState {
  final CommercialDebt commercialDebt;

  const SuccessCommercialDebtState({required this.commercialDebt});

  @override
  List<Object?> get props {
    return [commercialDebt];
  }
}

class NoDebtsCommercialDebtState extends CommercialDebtsState {
  const NoDebtsCommercialDebtState();
}
