import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/offers/offers_item.dart';
import 'package:balady_plus/etmam_app/features/my_orders/my_orders_exports.dart'
    show ActionModel;
import 'package:equatable/equatable.dart';

class OfferItemModel extends OfferItem {
  OfferItemModel(
      {super.id,
      super.number,
      super.providerId,
      super.value,
      super.notes,
      super.status,
      super.allowedActions,
      super.providerName,
      super.providerLogo,
      super.rating,
      super.financialAttachmentId,
      super.technicalAttachmentId});

  factory OfferItemModel.fromJson(Map<String, dynamic> json) => OfferItemModel(
      id: json["id"],
      number: json["number"],
      providerId: json["providerId"],
      value: json["value"],
      notes: json["notes"],
      status:
          json["status"] == null ? null : StatusModel.fromJson(json["status"]),
      allowedActions: json["allowedActions"] != null
          ? List<ActionModel>.from(
              json["allowedActions"].map((x) => ActionModel.fromMap(x)))
          : null,
      providerName: json["providerName"],
      providerLogo: json["providerLogo"],
      technicalAttachmentId: json["technicalAttachmentId"],
      financialAttachmentId: json["financialAttachmentId"],
      rating: json["rating"] != null ? json["rating"].toDouble() : null);
}

class StatusModel extends Status {
  StatusModel({
    super.id,
    super.name,
    super.closed,
  });

  factory StatusModel.fromJson(Map<String, dynamic> json) => StatusModel(
        id: json["id"],
        name: json["name"],
        closed: json["closed"],
      );
}
