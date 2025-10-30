import 'package:balady_plus/etmam_app/core/utils/enums/order_actions.dart';
import 'package:balady_plus/etmam_app/features/my_orders/my_orders_exports.dart';

class ActionParams {
  List<Action>? allowedActions;
  OrderAction? selectedAction;
  String? orderId;
  String? subServiceId;
  String? subServiceName;

  ActionParams(
      {this.allowedActions,
      this.orderId,
      this.selectedAction,
      this.subServiceId,
      this.subServiceName});
}
