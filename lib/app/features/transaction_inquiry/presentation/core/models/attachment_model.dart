// ignore_for_file: public_member_api_docs, sort_constructors_first
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

  AttachmentData copyWith({
    String? id,
    String? title,
    String? memo,
    String? filePath,
    String? fileName,
    String? base64,
    bool? isRequired,
    bool? isUploaded,
    String? hint,
  }) {
    return AttachmentData(
      id: id ?? this.id,
      title: title ?? this.title,
      memo: memo ?? this.memo,
      filePath: filePath ?? this.filePath,
      fileName: fileName ?? this.fileName,
      base64: base64 ?? this.base64,
      isRequired: isRequired ?? this.isRequired,
      isUploaded: isUploaded ?? this.isUploaded,
      hint: hint ?? this.hint,
    );
  }
}
