class ComplianceCertificateItemRequest {
  int? requestId;
  final String? attachmentId;
  final int? itemAnswer;
  final String? itemId;
  final String? note;

  ComplianceCertificateItemRequest(
      {this.requestId,
      this.attachmentId,
      this.itemAnswer,
      this.itemId,
      this.note});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "attachmentId": attachmentId,
      "itemAnswer": itemAnswer,
      "itemId": itemId,
      "note": note
    };
  }
}
