import 'package:equatable/equatable.dart';

import 'metadata.dart';

class CalendarEventItem extends Equatable {
  final String? id;
  final String? entityId;
  final String? entityType;
  final DateTime? eventDate;
  final String? eventDateHijri;
  final int? year;
  final int month;
  final int? yearHijri;
  final int monthHijri;
  final String? ownerIdentityNo;
  final String? ownerIdentityType;
  final String? ownerName;
  final Metadata? metadata;
  final String? eventDisplayMessage;
  final String? serviceUrl;
  final String? redirectUrl;
  final String? appRedirectUrl;
  final String? hashingEntityId;

  factory CalendarEventItem.fromJson(Map<String, dynamic> json) =>
      CalendarEventItem(
        id: json['id'] as String?,
        entityId: json['entityId'] as String?,
        entityType: json['entityType'] as String?,
        eventDate: json['eventDate'] == null
            ? null
            : DateTime.parse(json['eventDate'] as String),
        eventDateHijri: json['eventDateHijri'] as String?,
        year: json['year'] as int?,
        month: json['month'] ?? 0,
        yearHijri: json['yearHijri'] as int?,
        monthHijri: json['monthHijri'] ?? 0,
        ownerIdentityNo: json['ownerIdentityNo'] as String?,
        ownerIdentityType: json['ownerIdentityType'] as String?,
        ownerName: json['ownerName'] as String?,
        metadata: json['metadata'] == null
            ? null
            : Metadata.fromJson(json['metadata'] as Map<String, dynamic>),
        eventDisplayMessage: json['eventDisplayMessage'] as String?,
        serviceUrl: json['serviceUrl'] as String?,
        redirectUrl: json['redirectUrl'] as String?,
        appRedirectUrl: json['appRedirectUrl'] as String?,
        hashingEntityId: json['hashingEntityId'] as String?,
      );

  const CalendarEventItem({
    this.id,
    this.entityId,
    this.entityType,
    this.eventDate,
    this.eventDateHijri,
    this.year,
    this.yearHijri,
    required this.month,
    required this.monthHijri,
    this.ownerIdentityNo,
    this.ownerIdentityType,
    this.ownerName,
    this.metadata,
    this.eventDisplayMessage,
    this.serviceUrl,
    this.redirectUrl,
    this.appRedirectUrl,
    this.hashingEntityId,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'entityId': entityId,
        'entityType': entityType,
        'eventDate': eventDate?.toIso8601String(),
        'eventDateHijri': eventDateHijri,
        'year': year,
        'month': month,
        'yearHijri': yearHijri,
        'monthHijri': monthHijri,
        'ownerIdentityNo': ownerIdentityNo,
        'ownerIdentityType': ownerIdentityType,
        'ownerName': ownerName,
        'metadata': metadata?.toJson(),
        'eventDisplayMessage': eventDisplayMessage,
        'serviceUrl': serviceUrl,
        'redirectUrl': redirectUrl,
        'hashingEntityId': hashingEntityId,
      };

  @override
  List<Object?> get props {
    return [
      id,
      entityId,
      entityType,
      eventDate,
      eventDateHijri,
      year,
      month,
      yearHijri,
      monthHijri,
      ownerIdentityNo,
      ownerIdentityType,
      ownerName,
      metadata,
      eventDisplayMessage,
      serviceUrl,
      redirectUrl,
      hashingEntityId,
    ];
  }
}
