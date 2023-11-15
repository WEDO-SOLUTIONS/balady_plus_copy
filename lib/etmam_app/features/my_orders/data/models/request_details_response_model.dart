import 'package:balady_plus/etmam_app/features/my_orders/data/models/order_details_response_model.dart';
import 'package:balady_plus/etmam_app/features/my_orders/domain/entities/order_details/request_details_response.dart';
import 'package:balady_plus/etmam_app/features/my_orders/my_orders_exports.dart'
    show ActionModel;

class RequestDetailsResponseModel extends RequestDetailsResponse {
  RequestDetailsResponseModel(
      {super.requestId,
      super.requestNumber,
      super.relationId,
      super.formId,
      super.requestStatusId,
      super.requestStatusName,
      super.closureFlag,
      super.allowedActions,
      super.createdOffersCount,
      super.submittedOffersCount,
      super.processedOffersCount,
      super.acceptedOffer,
      super.creationDate,
      super.subServiceId,
      super.subServiceName,
      super.mainServiceId,
      super.mainServiceName,
      super.cityId,
      super.cityName,
      super.services,
      super.calculatedStatus,
      super.allReplies});

  factory RequestDetailsResponseModel.fromMap(Map<String, dynamic> json) {
    RequestDetailsResponseModel model = RequestDetailsResponseModel(
      requestId: json["requestId"],
      requestNumber: json["requestNumber"],
      relationId: json["relationId"],
      formId: json["formId"],
      requestStatusId: json["requestStatusId"],
      requestStatusName: json["requestStatusName"],
      closureFlag: json["closureFlag"],
      allowedActions: json["allowedActions"] != null
          ? List<ActionModel>.from(
              json["allowedActions"].map((x) => ActionModel.fromMap(x)))
          : null,
      createdOffersCount: json["createdOffersCount"],
      creationDate: json["creationDate"],
      submittedOffersCount: json["submittedOffersCount"],
      processedOffersCount: json["processedOffersCount"],
      acceptedOffer: json["acceptedOffer"] != null
          ? AcceptedOfferModel.fromJson(json["acceptedOffer"])
          : null,
      subServiceId: json["subServiceId"],
      subServiceName: json["subServiceName"],
      mainServiceId: json["mainServiceId"],
      mainServiceName: json["mainServiceName"],
      cityId: json["cityId"],
      cityName: json["cityName"],
      calculatedStatus: json["calculatedStatus"] != null
          ? StatusModel.fromMap(json["calculatedStatus"])
          : null,
      services: json["services"] == null
          ? []
          : List<RequestServiceModel>.from(
              json["services"]!.map((x) => RequestServiceModel.fromJson(x))),
    );
    model.actionsOnOrder = model.getAllowedActions();
    model.allReplies = model.getRequestReplies();
    // print("actionsOnOrder ${model.actionsOnOrder}");
    return model;
  }
}

class AcceptedOfferModel extends AcceptedOffer {
  AcceptedOfferModel(
      {super.id,
      super.number,
      super.providerId,
      super.value,
      super.notes,
      super.status,
      super.providerName,
      super.providerLogo,
      super.financialAttachmentId,
      super.technicalAttachmentId});

  factory AcceptedOfferModel.fromJson(Map<String, dynamic> json) =>
      AcceptedOfferModel(
          id: json["id"],
          number: json["number"],
          providerId: json["providerId"],
          value: json["value"],
          notes: json["notes"],
          status: json["status"] != null
              ? StatusModel.fromMap(json["status"])
              : null,
          providerName: json["providerName"],
          providerLogo: json["providerLogo"],
          financialAttachmentId: json["financialAttachmentId"],
          technicalAttachmentId: json["technicalAttachmentId"]);
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

class RequestServiceModel extends RequestService {
  RequestServiceModel(
      {super.relationId,
      super.targetRequestTypeId,
      super.cityId,
      super.createdOffersCount,
      super.submittedOffersCount,
      super.processedOffersCount,
      //  this.allowedActions,
      // this.subBiddings,
      super.subServiceId,
      super.subServiceName,
      super.mainServiceId,
      super.mainServiceName,
      super.requestId,
      super.requestNumber,
      super.requestStatusId,
      super.requestStatusName,
      super.closureFlag,
      super.acceptedOffer});

  factory RequestServiceModel.fromJson(Map<String, dynamic> json) =>
      RequestServiceModel(
        relationId: json["relationId"],
        targetRequestTypeId: json["targetRequestTypeId"],
        cityId: json["cityId"],
        createdOffersCount: json["createdOffersCount"],
        submittedOffersCount: json["submittedOffersCount"],
        processedOffersCount: json["processedOffersCount"],
        /* allowedActions: json["allowedActions"] == null
            ? []
            : List<dynamic>.from(json["allowedActions"]!.map((x) => x)),
        subBiddings: json["subBiddings"] == null
            ? []
            : List<dynamic>.from(json["subBiddings"]!.map((x) => x)),*/
        acceptedOffer: json["acceptedOffer"] != null
            ? AcceptedOfferModel.fromJson(json["acceptedOffer"])
            : null,
        subServiceId: json["subServiceId"],
        subServiceName: json["subServiceName"],
        mainServiceId: json["mainServiceId"],
        mainServiceName: json["mainServiceName"],
        requestId: json["requestId"],
        requestNumber: json["requestNumber"],
        requestStatusId: json["requestStatusId"],
        requestStatusName: json["requestStatusName"],
        closureFlag: json["closureFlag"],
      );
}
