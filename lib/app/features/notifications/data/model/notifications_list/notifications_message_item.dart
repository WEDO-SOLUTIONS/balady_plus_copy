import 'package:equatable/equatable.dart';


class NotificationsMessageItem extends Equatable {
  final String id;
  final String eventId;
  final DateTime eventTime;
  final String transactionId;
  final String transactionNumber;
  final String subject;
  final String body;
  final DateTime createTime;
  final bool deleted;
  final Type status;
  final Type eventType;
  // final Type product;
  // final Type service;


  const NotificationsMessageItem({
    required this.id,
    required this.eventId,
    required this.eventTime,
    required this.transactionId,
    required this.transactionNumber,
    required this.subject,
    required this.body,
    required this.createTime,
    required this.deleted,
    required this.status,
    required this.eventType,
    // required this.product,
    // required this.service,
  });


  factory NotificationsMessageItem.fromJson(Map<String, dynamic> json) => NotificationsMessageItem(
    id: json["id"],
    eventId: json["eventId"],
    eventTime: DateTime.parse(json["eventTime"]),
    transactionId: json["transactionId"],
    transactionNumber: json["transactionNumber"],
    subject: json["subject"] ?? '',
    body: json["body"] ?? '',
    createTime: DateTime.parse(json["createTime"]),
    deleted: json["deleted"],
    status: Type.fromJson(json["status"]),
    eventType: Type.fromJson(json["eventType"]),
    // product: Type.fromJson(json["product"]),
    // service: Type.fromJson(json["service"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "eventId": eventId,
    "eventTime": eventTime.toIso8601String(),
    "transactionId": transactionId,
    "transactionNumber": transactionNumber,
    "subject": subject,
    "body": body,
    "createTime": createTime.toIso8601String(),
    "deleted": deleted,
    "status": status.toJson(),
    "eventType": eventType.toJson(),
    // "product": product.toJson(),
    // "service": service.toJson(),
  };

  @override
  List<Object?> get props {
    return [
      id,
    ];
  }
}


class Type {
  final String id;
  final String name;

  Type({
    required this.id,
    required this.name,
  });

  factory Type.fromJson(Map<String, dynamic> json) => Type(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
