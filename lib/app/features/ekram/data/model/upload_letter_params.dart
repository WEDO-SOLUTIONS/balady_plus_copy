import 'package:balady_plus/app/features/ekram/domain/entities/deceased_request_details/deceased_request_details.dart';
import 'package:equatable/equatable.dart';

class UploadAttachmentParamas extends Equatable {
  final int? id;
  final int attachTypeId;
  final String contentType;
  final String fileContent;
  final int? requestId;
  final String fileName;

  final List<TransportAttachResponseDto>? otherFiles;

  UploadAttachmentParamas(
      {required this.attachTypeId,
      required this.contentType,
      required this.fileContent,
      required this.id,
       this.requestId,
      required this.fileName,
       this.otherFiles});

  Map<String, dynamic> toMap() => {
        "deceasedTransportRequestAttach": [
          {
            // if (id != null) "id": id,
            "attachTypeId": attachTypeId,
            "contentType": contentType,
            "fileContent": fileContent,
            "fileName": fileName
          },
          if (otherFiles != null && otherFiles!.isNotEmpty)
            ...otherFiles!.map((e) {
              return {
                "id": e.id,
                "attachTypeId": e.attachmentType,
                "fileName": fileName
              };
            }).toList()
        ],
        "requestId": requestId
      };

  @override
  List<Object?> get props => [];
}
