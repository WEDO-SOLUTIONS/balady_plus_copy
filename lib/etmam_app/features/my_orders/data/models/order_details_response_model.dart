import 'package:balady_plus/etmam_app/features/my_orders/domain/entities/order_details/order_details_response.dart';
import 'package:balady_plus/etmam_app/features/my_orders/my_orders_exports.dart'
    show ActionModel;

class OrderDetailsResponseModel extends OrderDetailsResponse {
  OrderDetailsResponseModel(
      {super.id,
      super.number,
      super.cityId,
      super.relationId,
      super.serviceId,
      super.type,
      super.providerId,
      super.mandatory,
      super.independent,
      super.status,
      super.allowedActions,
      super.createDate,
      super.subOrders,
      super.pendingCancelRequest,
      super.cityName,
      super.serviceDetails,
      super.providerName,
      super.parent,
      super.providerLogoUrl,
      super.serviceName,
      super.actionsOnOrder,
      super.platformReferenceNumber,
      super.formId});

  factory OrderDetailsResponseModel.fromMap(Map<String, dynamic> json) {
    OrderDetailsResponseModel model = OrderDetailsResponseModel(
      id: json["id"],
      number: json["number"],
      cityId: json["cityId"],
      relationId: json["relationId"],
      serviceId: json["serviceId"],
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
      formId: json["formId"],
      subOrders: json["subOrders"] != null
          ? List<OrderDetailsResponseModel>.from(json["subOrders"]
              .map((x) => OrderDetailsResponseModel.fromMap(x)))
          : null,
      pendingCancelRequest: json["pendingCancelRequest"] == null
          ? null
          : PendingCancelRequestModel.fromMap(json["pendingCancelRequest"]),
      cityName: json["cityName"],
      serviceDetails: json["serviceDetails"] == null
          ? null
          : ServiceDetailsModel.fromMap(json["serviceDetails"]),
      providerName: json["providerName"],
      providerLogoUrl: json["providerLogoUrl"],
      serviceName: json["serviceName"],
      platformReferenceNumber: json["platformReferenceNumber"],
      parent:
          json["parent"] == null ? null : ParentModel.fromMap(json["parent"]),
    );
    model.actionsOnOrder = model.getAllowedActions();
    // print("actionsOnOrder ${model.actionsOnOrder}");
    return model;
  }
}

class StatusModel extends Status {
  StatusModel({
    super.id,
    super.name,
    super.active,
  });

  factory StatusModel.fromMap(Map<String, dynamic> json) => StatusModel(
        id: json["id"],
        name: json["name"],
        active: json["active"],
      );
}

class ParentModel extends Parent {
  ParentModel({
    super.id,
    super.number,
    super.cityId,
    super.relationId,
    super.serviceId,
    super.type,
    super.providerId,
    super.mandatory,
    super.independent,
    super.status,
    super.createDate,
    super.pendingCancelRequest,
  });

  factory ParentModel.fromMap(Map<String, dynamic> json) => ParentModel(
        id: json["id"],
        number: json["number"],
        cityId: json["cityId"],
        relationId: json["relationId"],
        serviceId: json["serviceId"],
        type: json["type"] != null ? StatusModel.fromMap(json["type"]) : null,
        providerId: json["providerId"],
        mandatory: json["mandatory"],
        independent: json["independent"],
        status:
            json["status"] != null ? StatusModel.fromMap(json["status"]) : null,
        createDate: json["createDate"],
        pendingCancelRequest: json["pendingCancelRequest"] != null
            ? PendingCancelRequestModel.fromMap(json["pendingCancelRequest"])
            : null,
      );
}

class PendingCancelRequestModel extends PendingCancelRequest {
  PendingCancelRequestModel({
    super.id,
    super.number,
    super.status,
    super.creationTime,
    super.requestReason,
  });

  factory PendingCancelRequestModel.fromMap(Map<String, dynamic> json) =>
      PendingCancelRequestModel(
          id: json["id"],
          number: json["number"],
          status: json["status"] != null
              ? StatusModel.fromMap(json["status"])
              : null,
          creationTime: json["creationTime"],
          requestReason: json["requestReason"]);
}

class ServiceDetailsModel extends ServiceDetails {
  ServiceDetailsModel({
    super.id,
    super.name,
    super.logoUrl,
    super.independent,
    super.ordersCount,
    super.category,
    super.description,
    super.notAvailableInCity,
  });

  factory ServiceDetailsModel.fromMap(Map<String, dynamic> json) =>
      ServiceDetailsModel(
        id: json["id"],
        name: json["name"],
        logoUrl: json["logoUrl"],
        independent: json["independent"],
        ordersCount: json["ordersCount"],
        category: json["category"] != null
            ? StatusModel.fromMap(json["category"])
            : null,
        description: json["description"],
        notAvailableInCity: json["notAvailableInCity"],
      );
}
