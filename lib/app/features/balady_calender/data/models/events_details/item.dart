import 'package:equatable/equatable.dart';

import 'metadata.dart';

class Item extends Equatable {
  final dynamic id;
  final String? entityId;
  final String? entityType;
  final String? eventDate;
  final String? eventDateHijri;
  final int? year;
  final int? month;
  final int? yearHijri;
  final int? monthHijri;
  final String? ownerIdentityNo;
  final String? ownerIdentityType;
  final String? ownerName;
  final Metadata? metadata;
  final dynamic eventDisplayMessage;
  final dynamic serviceUrl;
  final String? hashingEntityId;

  const Item({
    this.id,
    this.entityId,
    this.entityType,
    this.eventDate,
    this.eventDateHijri,
    this.year,
    this.month,
    this.yearHijri,
    this.monthHijri,
    this.ownerIdentityNo,
    this.ownerIdentityType,
    this.ownerName,
    this.metadata,
    this.eventDisplayMessage,
    this.serviceUrl,
    this.hashingEntityId,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json['id'] as dynamic,
        entityId: json['entityId'] as String?,
        entityType: json['entityType'] as String?,
        eventDate: json['eventDate'] as String?,
        eventDateHijri: json['eventDateHijri'] as String?,
        year: json['year'] as int?,
        month: json['month'] as int?,
        yearHijri: json['yearHijri'] as int?,
        monthHijri: json['monthHijri'] as int?,
        ownerIdentityNo: json['ownerIdentityNo'] as String?,
        ownerIdentityType: json['ownerIdentityType'] as String?,
        ownerName: json['ownerName'] as String?,
        metadata: json['metadata'] == null
            ? null
            : Metadata.fromJson(json['metadata'] as Map<String, dynamic>),
        eventDisplayMessage: json['eventDisplayMessage'] as dynamic,
        serviceUrl: json['serviceUrl'] as dynamic,
        hashingEntityId: json['hashingEntityId'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'entityId': entityId,
        'entityType': entityType,
        'eventDate': eventDate,
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
      hashingEntityId,
    ];
  }
}
