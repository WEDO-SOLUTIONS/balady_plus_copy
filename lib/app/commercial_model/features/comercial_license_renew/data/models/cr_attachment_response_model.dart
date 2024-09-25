import 'package:balady_plus/app/features/create_compliance/create_compliance_exports.dart';

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
