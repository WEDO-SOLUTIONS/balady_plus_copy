import 'package:balady_plus/etmam_app/core/utils/enums/order_actions.dart';
import 'package:balady_plus/etmam_app/features/my_orders/domain/entities/request_item.dart';

class RequestItemModel extends RequestItem {
  RequestItemModel(
      {super.requestId,
      super.requestNumber,
      super.requestTypeId,
      super.subServiceId,
      super.subServiceName,
      super.mainServiceId,
      super.mainServiceName,
      super.cityName,
      super.providerId,
      super.closureFlag,
      super.orderStatus,
      super.providerName,
      super.requestTypeName,
      super.createDate,
      super.cityId,
      super.internalId,
      super.statusName,
      super.tags});

  factory RequestItemModel.fromMap(Map<String, dynamic> json) {
    RequestItemModel model = RequestItemModel(
        requestId: json["requestId"],
        requestNumber: json["requestNumber"],
        cityName: json["cityName"],
        subServiceId: json["subServiceId"],
        subServiceName: json["subServiceName"],
        mainServiceId: json["mainServiceId"],
        mainServiceName: json["mainServiceName"],
        closureFlag: json["closureFlag"],
        orderStatus: json["orderStatus"],
        providerName: json["providerName"],
        requestTypeId: json["requestTypeId"],
        requestTypeName: json["requestTypeName"],
        providerId: json["providerId"],
        createDate: json["createDate"],
        cityId: json["cityId"],
        statusName: json["statusName"],
        internalId: json["internalId"],
        tags: json["tags"] != null
            ? List<TagModel>.from(json["tags"]!.map((x) => TagModel.fromMap(x)))
            : []);

    return model;
  }
}

class TagModel extends Tag {
  TagModel({super.id, super.value});

  factory TagModel.fromMap(Map<String, dynamic> json) =>
      TagModel(value: json["value"], id: json["id"]);
}
