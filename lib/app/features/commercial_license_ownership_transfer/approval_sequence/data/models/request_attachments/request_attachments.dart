class RequestAttachments {
  int? id;
  String? name;
  String? allowedFilesExtension;
  bool? isMandatory;
  bool? attached;
  bool? approved;
  String? attachUrl;
  dynamic postObservationAttachUrl;
  int? maxSize;
  dynamic notes;
  String? attachDescription;
  String? originFileName;

  RequestAttachments({
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

  factory RequestAttachments.fromJson(Map<String, dynamic> json) {
    return RequestAttachments(
      id: json['id'] as int?,
      name: json['name'] as String?,
      allowedFilesExtension: json['allowedFilesExtension'] as String?,
      isMandatory: json['isMandatory'] as bool?,
      attached: json['attached'] as bool?,
      approved: json['approved'] as bool?,
      attachUrl: json['attachUrl'] as String?,
      postObservationAttachUrl: json['postObservationAttachUrl'] as dynamic,
      maxSize: json['maxSize'] as int?,
      notes: json['notes'] as dynamic,
      attachDescription: json['attachDescription'] as String?,
      originFileName: json['originFileName'] as String?,
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
