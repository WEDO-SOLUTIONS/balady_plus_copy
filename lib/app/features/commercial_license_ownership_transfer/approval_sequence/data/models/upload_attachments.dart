class UploadAttachments {
  int? id;
  dynamic name;
  dynamic allowedFilesExtension;
  bool? isMandatory;
  bool? attached;
  bool? approved;
  String? attachUrl;
  dynamic postObservationAttachUrl;
  dynamic maxSize;
  dynamic notes;
  dynamic attachDescription;
  dynamic originFileName;

  UploadAttachments({
    this.id,
    this.name,
    this.allowedFilesExtension,
    this.isMandatory,
    this.attached,
    this.approved,
    this.attachUrl,
    this.postObservationAttachUrl,
    this.maxSize,
    this.notes,
    this.attachDescription,
    this.originFileName,
  });

  factory UploadAttachments.fromJson(Map<String, dynamic> json) {
    return UploadAttachments(
      id: json['id'] as int?,
      name: json['name'] as dynamic,
      allowedFilesExtension: json['allowedFilesExtension'] as dynamic,
      isMandatory: json['isMandatory'] as bool?,
      attached: json['attached'] as bool?,
      approved: json['approved'] as bool?,
      attachUrl: json['attachUrl'] as String?,
      postObservationAttachUrl: json['postObservationAttachUrl'] as dynamic,
      maxSize: json['maxSize'] as dynamic,
      notes: json['notes'] as dynamic,
      attachDescription: json['attachDescription'] as dynamic,
      originFileName: json['originFileName'] as dynamic,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'allowedFilesExtension': allowedFilesExtension,
        'isMandatory': isMandatory,
        'attached': attached,
        'approved': approved,
        'attachUrl': attachUrl,
        'postObservationAttachUrl': postObservationAttachUrl,
        'maxSize': maxSize,
        'notes': notes,
        'attachDescription': attachDescription,
        'originFileName': originFileName,
      };
}
