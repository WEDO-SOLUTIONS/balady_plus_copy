import 'objectable_transaction_entity.dart';

class TransactionDetailsParams {
  String id;
  String applicationId;
  ObjectableTransactionsEntity? item;

  TransactionDetailsParams(
      {required this.applicationId, required this.id, this.item});
}
