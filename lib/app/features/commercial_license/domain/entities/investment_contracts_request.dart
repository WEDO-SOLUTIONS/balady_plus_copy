import 'package:equatable/equatable.dart';

class InvestmentContractRequest extends Equatable {
  final int requestId;

  const InvestmentContractRequest({required this.requestId});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{};
  }

  @override
  List<Object?> get props => [requestId];
}
