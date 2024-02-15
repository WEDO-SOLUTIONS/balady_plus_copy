import 'package:equatable/equatable.dart';

import 'main_type.dart';
import 'status.dart';
import 'type.dart';

class Metadata extends Equatable {
  final MainType? mainType;
  final Type? type;
  final Status? status;
  final String? licenseNumber;
  final String? time;
  final dynamic contentTypeId;

  const Metadata({
    this.mainType,
    this.type,
    this.status,
    this.time,
    this.licenseNumber,
    this.contentTypeId,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata(
        mainType: json['mainType'] == null
            ? null
            : MainType.fromJson(json['mainType'] as Map<String, dynamic>),
        type: json['type'] == null
            ? null
            : Type.fromJson(json['type'] as Map<String, dynamic>),
        status: json['status'] == null
            ? null
            : Status.fromJson(json['status'] as Map<String, dynamic>),
        licenseNumber: json['licenseNumber'] as String?,
        contentTypeId: json['contentTypeId'] as dynamic,
        time: json['time'],
      );

  Map<String, dynamic> toJson() => {
        'mainType': mainType?.toJson(),
        'type': type?.toJson(),
        'status': status?.toJson(),
        'licenseNumber': licenseNumber,
        'time': time,
        'contentTypeId': contentTypeId,
      };

  @override
  List<Object?> get props {
    return [
      mainType,
      type,
      status,
      licenseNumber,
      contentTypeId,
    ];
  }
}
