// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';


import 'package:balady_plus/app/features/create_compliance/data/models/comliance_request_details_model.dart';

import '../../domain/entities/cr_attachment_response.dart';

class CrAttachmentResponseModel extends CrAttachmentResponse {
  CrAttachmentResponseModel({
    super.items,
  });

  factory CrAttachmentResponseModel.fromMap(Map<String, dynamic> json) {
    return CrAttachmentResponseModel(
      items: json["result"] == null
          ? []
          : List<AttachmentModel>.from(
              json["result"]!.map((x) => AttachmentModel.fromJson(x))),
    );
  }
}
