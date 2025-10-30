import 'package:balady_plus/etmam_app/core/utils/enums/order_actions.dart';
import 'package:balady_plus/etmam_app/features/my_orders/domain/entities/order_item.dart';

class OrderItemModel extends OrderItem {
  OrderItemModel(
      {super.id,
      super.number,
      super.relationId,
      super.subServiceId,
      super.subServiceName,
      super.mainServiceId,
      super.mainServiceName,
      super.type,
      super.providerId,
      super.mandatory,
      super.independent,
      super.status,
      super.allowedActions,
      super.createDate,
      super.hasPendingCancelRequest,
      super.cityId,
      super.actionsOnOrder});

  factory OrderItemModel.fromMap(Map<String, dynamic> json) {
    OrderItemModel model = OrderItemModel(
      id: json["id"],
      number: json["number"],
      relationId: json["relationId"],
      subServiceId: json["subServiceId"],
      subServiceName: json["subServiceName"],
      mainServiceId: json["mainServiceId"],
      mainServiceName: json["mainServiceName"],
      type: json["type"] != null ? StatusModel.fromMap(json["type"]) : null,
      providerId: json["providerId"],
      mandatory: json["mandatory"],
      independent: json["independent"],
      status:
          json["status"] != null ? StatusModel.fromMap(json["status"]) : null,
      allowedActions: json["allowedActions"] != null
          ? List<ActionModel>.from(
              json["allowedActions"].map((x) => ActionModel.fromMap(x)))
          : null,
      createDate: json["createDate"],
      hasPendingCancelRequest: json["hasPendingCancelRequest"],
      cityId: json["cityId"],
    );

    model.actionsOnOrder = model.getAllowedActions();
    return model;
  }
}

class StatusModel extends Status {
  StatusModel({
    super.id,
    super.name,
  });

  factory StatusModel.fromMap(Map<String, dynamic> json) => StatusModel(
        id: json["id"],
        name: json["name"],
      );
}

class ActionModel extends Action {
  ActionModel({
    super.id,
    super.name,
  });

  factory ActionModel.fromMap(Map<String, dynamic> json) {
    ActionModel model = ActionModel(
      id: json["id"],
      name: json["name"],
    );
    model.action = OrderAction.getAction(model.id ?? "");
    return model;
  }
}
