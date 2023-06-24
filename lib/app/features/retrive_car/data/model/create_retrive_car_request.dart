class CreateRetriveCarRequest {
  String? id;
  String incidentID;
  String expectionVechileDate;
  String applicantNote;
  String attachmentID;

  CreateRetriveCarRequest(
      {required this.applicantNote,
      required this.attachmentID,
      required this.expectionVechileDate,
      required this.incidentID});

  Map<String, dynamic> toMap() => {
        "IncidentID": incidentID,
        "ExpectionVechileDate": expectionVechileDate,
        "ApplicantNote": applicantNote,
        if (attachmentID.isNotEmpty)
          "Attachments": [
            {"AttachmentID": attachmentID}
          ]
      };
}
