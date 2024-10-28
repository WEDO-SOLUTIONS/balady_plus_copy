class DeceasedAttachment {
  DeceasedAttachment({
      this.id, 
      this.uuid, 
      this.name, 
      this.allowedFilesExtension, 
      this.attached, 
      this.approved, 
      this.attachUrl, 
      this.updatable, 
      this.maxSize, 
      this.contentType, 
      this.path, 
      this.fileName, 
      this.attachmentTypeId, 
      this.mandatory,});

  DeceasedAttachment.fromJson(dynamic json) {
    id = json['id'];
    uuid = json['uuid'];
    name = json['name'];
    allowedFilesExtension = json['allowedFilesExtension'];
    attached = json['attached'];
    approved = json['approved'];
    attachUrl = json['attachUrl'];
    updatable = json['updatable'];
    maxSize = json['maxSize'];
    contentType = json['contentType'];
    path = json['path'];
    fileName = json['fileName'];
    attachmentTypeId = json['attachmentTypeId'];
    mandatory = json['mandatory'];
  }
  int? id;
  String? uuid;
  String? name;
  String? allowedFilesExtension;
  bool? attached;
  bool? approved;
  String? attachUrl;
  bool? updatable;
  int? maxSize;
  String? contentType;
  String? path;
  String? fileName;
  int? attachmentTypeId;
  bool? mandatory;
DeceasedAttachment copyWith({  int? id,
  String? uuid,
  String? name,
  String? allowedFilesExtension,
  bool? attached,
  bool? approved,
  String? attachUrl,
  bool? updatable,
  int? maxSize,
  String? contentType,
  String? path,
  String? fileName,
  int? attachmentTypeId,
  bool? mandatory,
}) => DeceasedAttachment(  id: id ?? this.id,
  uuid: uuid ?? this.uuid,
  name: name ?? this.name,
  allowedFilesExtension: allowedFilesExtension ?? this.allowedFilesExtension,
  attached: attached ?? this.attached,
  approved: approved ?? this.approved,
  attachUrl: attachUrl ?? this.attachUrl,
  updatable: updatable ?? this.updatable,
  maxSize: maxSize ?? this.maxSize,
  contentType: contentType ?? this.contentType,
  path: path ?? this.path,
  fileName: fileName ?? this.fileName,
  attachmentTypeId: attachmentTypeId ?? this.attachmentTypeId,
  mandatory: mandatory ?? this.mandatory,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['uuid'] = uuid;
    map['name'] = name;
    map['allowedFilesExtension'] = allowedFilesExtension;
    map['attached'] = attached;
    map['approved'] = approved;
    map['attachUrl'] = attachUrl;
    map['updatable'] = updatable;
    map['maxSize'] = maxSize;
    map['contentType'] = contentType;
    map['path'] = path;
    map['fileName'] = fileName;
    map['attachmentTypeId'] = attachmentTypeId;
    map['mandatory'] = mandatory;
    return map;
  }

}