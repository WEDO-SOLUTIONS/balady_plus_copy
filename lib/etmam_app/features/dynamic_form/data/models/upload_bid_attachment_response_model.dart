// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';

import '../../dynamic_forms_exports.dart';

class UploadBidAttachmentResponseModel extends UploadBidAttachmentResponse {
  const UploadBidAttachmentResponseModel(
      {super.attachmentId, super.uploadTransactionId});

  factory UploadBidAttachmentResponseModel.fromJson(
          Map<String, dynamic> json) =>
      UploadBidAttachmentResponseModel(
        attachmentId: json["attachmentId"],
        uploadTransactionId: json["uploadTransactionId"],
      );
}
