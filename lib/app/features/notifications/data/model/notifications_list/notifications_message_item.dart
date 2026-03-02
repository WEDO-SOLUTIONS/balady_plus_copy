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
  final DateTime updateTime;
  final bool deleted;
  final NotificationType status;
  final NotificationType eventType;

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
    required this.updateTime,
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
        updateTime: DateTime.parse(json["updateTime"]),
        deleted: json["deleted"],
        status: NotificationType.fromJson(json["status"]),
        eventType: NotificationType.fromJson(json["eventType"]),
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

  NotificationsMessageItem copyWith({
    NotificationType? status,
  }) {
    return NotificationsMessageItem(
      status: status ?? this.status,
      id: id,
      eventId: eventId,
      eventTime: eventTime,
      transactionId: transactionId,
      transactionNumber: transactionNumber,
      subject: subject,
      body: body,
      createTime: createTime,
      updateTime: updateTime,
      deleted: deleted,
      eventType: eventType,
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      eventId,
      eventTime,
      transactionId,
      transactionNumber,
      status.id,
      status.text,
      deleted,
      eventType,
    ];
  }
}

class NotificationType {
  final String id;
  final String text;

  NotificationType({
    required this.id,
    required this.text,
  });

  factory NotificationType.fromJson(Map<String, dynamic> json) => NotificationType(
        id: json["id"],
        text: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": text,
      };
}
