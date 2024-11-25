// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';


import 'package:balady_plus/app/features/create_compliance/data/models/comliance_request_details_model.dart';
import 'package:equatable/equatable.dart';


import 'package:balady_plus/app/features/create_compliance/create_compliance_exports.dart';
class AttachmentResponseEntity extends Equatable{
  List<Attachment>? items;
  AttachmentResponseEntity({
    this.items,
  });

  factory AttachmentResponseEntity.fromMap(Map<String, dynamic> json) {
    return AttachmentResponseEntity(
      items: json["result"] == null
          ? []
          : List<AttachmentModel>.from(
              json["result"]!.map((x) => AttachmentModel.fromJson(x))),
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props  => [];
}
