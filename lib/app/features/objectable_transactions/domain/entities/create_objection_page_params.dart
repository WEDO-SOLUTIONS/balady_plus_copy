import 'objectable_transaction_entity.dart';
import 'transaction_details.dart';

class CreateObjectionPageParams {
  ObjectableTransactionsEntity? item;
  TransactionDetails? details;

  CreateObjectionPageParams({this.details, this.item});
}
