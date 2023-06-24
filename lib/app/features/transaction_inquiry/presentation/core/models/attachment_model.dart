class AttachmentData {
  String id;
  String title;
  String memo;
  String? filePath;
  String? fileName;
  String? base64;
  bool isRequired;
  bool isUploaded;
  String hint;

  AttachmentData(
      {this.fileName,
      this.filePath,
      this.base64,
      required this.id,
      required this.memo,
      required this.title,
      required this.isRequired,
      required this.isUploaded,
      this.hint = ""});
}
