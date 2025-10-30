import 'package:equatable/equatable.dart';

class ReplyRetriveCarParams extends Equatable {
  final String pzInsKey;
  final String applicantNote;
  final String? attachmentID;

  ReplyRetriveCarParams(
      {required this.pzInsKey, required this.applicantNote, this.attachmentID});

  Map<String, dynamic> toMap() => {
        "pzInsKey": pzInsKey,
        "ApplicantNote": applicantNote,
        if (attachmentID?.isNotEmpty ?? false)
          "Attachments": [
            {"AttachmentID": attachmentID}
          ]
      };

  @override
  List<Object?> get props => [];
}
