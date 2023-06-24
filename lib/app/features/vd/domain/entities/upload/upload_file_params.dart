class UploadFileParams {
  String? pxAttachName;
  String? attachStream;
  String? pyMemo;
  String? category;
  String? filePath;
  int? index;
  String? caseId;

  UploadFileParams(
      {this.attachStream,
      this.category,
      this.pxAttachName,
      this.pyMemo,
      this.filePath,
      this.index,
      this.caseId});

  UploadFileParams copyWith(
      {String? pxAttachName,
      String? attachStream,
      String? pyMemo,
      String? category,
      String? filePath,
      int? index,
      String? caseId}) {
    return UploadFileParams(
        pxAttachName: pxAttachName ?? this.pxAttachName,
        attachStream: attachStream ?? this.attachStream,
        pyMemo: pyMemo ?? this.pyMemo,
        category: category ?? this.category,
        filePath: filePath ?? this.filePath,
        index: index ?? this.index,
        caseId: caseId ?? this.caseId);
  }

  Map<String, dynamic> toMap() => {
        "attributes": {
          //"guid": CommonFunctions.generateGUID(),
          "CASE_ID": caseId,
          "CATEGORY": category
        },
        "attachments": [
          {
            "documentName": pxAttachName,
            "base64Content": attachStream,
          }
        ],
      };

  Map<String, dynamic> toVDMap() {
    return {
      "pxAttachName": pxAttachName,
      "AttachStream": attachStream,
      "pyMemo": pyMemo,
      "Category": category,
    };
  }
}
