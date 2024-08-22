import 'package:balady_plus/app/commercial_model/features/commercial_debts/data/models/commercial_debts_model.dart';
import 'package:equatable/equatable.dart';

class ListDebtsState extends Equatable {
  const ListDebtsState();

  @override
  List<Object?> get props => throw UnimplementedError();
}

class LoadingListDebtState extends ListDebtsState {
  const LoadingListDebtState();
}

class FieldListDebtState extends ListDebtsState {
  final String errorMessage;
  final int pageNumber;
  const FieldListDebtState({
    required this.errorMessage,
    required this.pageNumber,
  });

  @override
  List<Object?> get props {
    return [errorMessage];
  }
}

class SuccessListDebtState extends ListDebtsState {
  final List<Debt> listDebts;
  const SuccessListDebtState({required this.listDebts});
  @override
  List<Object?> get props {
    return [listDebts,listDebts.length];
  }
}

final class SucceedWithPaginationListDebtState extends SuccessListDebtState {
  final int page;

  const SucceedWithPaginationListDebtState({
    required this.page,
    required listDebts,
  }) : super(listDebts: listDebts);

  @override
  List<Object?> get props => [page, listDebts, listDebts.length];
}

class NoListDebtsDebtState extends ListDebtsState {
  const NoListDebtsDebtState();
}
