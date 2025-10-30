// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class UploadBidAttachmentResponse extends Equatable {
  final String? uploadTransactionId;
  final String? attachmentId;

  const UploadBidAttachmentResponse({
    this.uploadTransactionId,
    this.attachmentId,
  });

  @override
  List<Object?> get props => [uploadTransactionId, attachmentId];
}
