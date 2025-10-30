// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class UploadBidAttachment extends Equatable {
  final String requestTypeId;
  final String attachmentTypeId;
  final Uint8List base64;
  final String base64Str;
  final String fileName;
  final String mimeType;
  final String filePath;

  const UploadBidAttachment(
      {required this.requestTypeId,
      required this.attachmentTypeId,
      required this.base64,
      required this.base64Str,
      required this.fileName,
      required this.mimeType,
      required this.filePath});

  @override
  List<Object?> get props => [requestTypeId, fileName];

  Map<String, String> toMap() {
    return <String, String>{
      'request-type-id': requestTypeId,
      'attachment-type-id': attachmentTypeId,
    };
  }
}
