class CVUploadResponse {
  final List<FileIdValue>? fid;
  final List<UuidValue>? uuid;
  final List<StringValue>? langcode;
  final List<UserValue>? uid;
  final List<StringValue>? filename;
  final List<UriValue>? uri;
  final List<StringValue>? filemime;
  final List<IntValue>? filesize;
  final List<BoolValue>? status;
  final List<DateValue>? created;
  final List<DateValue>? changed;

  CVUploadResponse({
    this.fid,
    this.uuid,
    this.langcode,
    this.uid,
    this.filename,
    this.uri,
    this.filemime,
    this.filesize,
    this.status,
    this.created,
    this.changed,
  });

  factory CVUploadResponse.fromJson(Map<String, dynamic> json) =>
      CVUploadResponse(
        fid: json['fid'] != null
            ? (json['fid'] as List).map((e) => FileIdValue.fromJson(e)).toList()
            : null,
        uuid: json['uuid'] != null
            ? (json['uuid'] as List).map((e) => UuidValue.fromJson(e)).toList()
            : null,
        langcode: json['langcode'] != null
            ? (json['langcode'] as List)
                .map((e) => StringValue.fromJson(e))
                .toList()
            : null,
        uid: json['uid'] != null
            ? (json['uid'] as List).map((e) => UserValue.fromJson(e)).toList()
            : null,
        filename: json['filename'] != null
            ? (json['filename'] as List)
                .map((e) => StringValue.fromJson(e))
                .toList()
            : null,
        uri: json['uri'] != null
            ? (json['uri'] as List).map((e) => UriValue.fromJson(e)).toList()
            : null,
        filemime: json['filemime'] != null
            ? (json['filemime'] as List)
                .map((e) => StringValue.fromJson(e))
                .toList()
            : null,
        filesize: json['filesize'] != null
            ? (json['filesize'] as List)
                .map((e) => IntValue.fromJson(e))
                .toList()
            : null,
        status: json['status'] != null
            ? (json['status'] as List)
                .map((e) => BoolValue.fromJson(e))
                .toList()
            : null,
        created: json['created'] != null
            ? (json['created'] as List)
                .map((e) => DateValue.fromJson(e))
                .toList()
            : null,
        changed: json['changed'] != null
            ? (json['changed'] as List)
                .map((e) => DateValue.fromJson(e))
                .toList()
            : null,
      );

  Map<String, dynamic> toJson() => {
        'fid': fid?.map((e) => e.toJson()).toList(),
        'uuid': uuid?.map((e) => e.toJson()).toList(),
        'langcode': langcode?.map((e) => e.toJson()).toList(),
        'uid': uid?.map((e) => e.toJson()).toList(),
        'filename': filename?.map((e) => e.toJson()).toList(),
        'uri': uri?.map((e) => e.toJson()).toList(),
        'filemime': filemime?.map((e) => e.toJson()).toList(),
        'filesize': filesize?.map((e) => e.toJson()).toList(),
        'status': status?.map((e) => e.toJson()).toList(),
        'created': created?.map((e) => e.toJson()).toList(),
        'changed': changed?.map((e) => e.toJson()).toList(),
      };

  // Helper getters to easily access common values
  String? get fileName =>
      filename?.isNotEmpty == true ? filename!.first.value : null;

  String? get fileUrl => uri?.isNotEmpty == true ? uri!.first.url : null;

  int? get fileId => fid?.isNotEmpty == true ? fid!.first.value : null;

  String? get fileUuid => uuid?.isNotEmpty == true ? uuid!.first.value : null;
}

class FileIdValue {
  final int? value;

  FileIdValue({this.value});

  factory FileIdValue.fromJson(Map<String, dynamic> json) => FileIdValue(
        value: json['value'] as int?,
      );

  Map<String, dynamic> toJson() => {'value': value};
}

class UuidValue {
  final String? value;

  UuidValue({this.value});

  factory UuidValue.fromJson(Map<String, dynamic> json) => UuidValue(
        value: json['value'] as String?,
      );

  Map<String, dynamic> toJson() => {'value': value};
}

class StringValue {
  final String? value;

  StringValue({this.value});

  factory StringValue.fromJson(Map<String, dynamic> json) => StringValue(
        value: json['value'] as String?,
      );

  Map<String, dynamic> toJson() => {'value': value};
}

class IntValue {
  final int? value;

  IntValue({this.value});

  factory IntValue.fromJson(Map<String, dynamic> json) => IntValue(
        value: json['value'] as int?,
      );

  Map<String, dynamic> toJson() => {'value': value};
}

class BoolValue {
  final bool? value;

  BoolValue({this.value});

  factory BoolValue.fromJson(Map<String, dynamic> json) => BoolValue(
        value: json['value'] as bool?,
      );

  Map<String, dynamic> toJson() => {'value': value};
}

class UriValue {
  final String? value;
  final String? url;

  UriValue({this.value, this.url});

  factory UriValue.fromJson(Map<String, dynamic> json) => UriValue(
        value: json['value'] as String?,
        url: json['url'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'value': value,
        'url': url,
      };
}

class UserValue {
  final int? targetId;
  final String? targetType;
  final String? targetUuid;
  final String? url;

  UserValue({this.targetId, this.targetType, this.targetUuid, this.url});

  factory UserValue.fromJson(Map<String, dynamic> json) => UserValue(
        targetId: json['target_id'] as int?,
        targetType: json['target_type'] as String?,
        targetUuid: json['target_uuid'] as String?,
        url: json['url'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'target_id': targetId,
        'target_type': targetType,
        'target_uuid': targetUuid,
        'url': url,
      };
}

class DateValue {
  final String? value;
  final String? format;

  DateValue({this.value, this.format});

  factory DateValue.fromJson(Map<String, dynamic> json) => DateValue(
        value: json['value'] as String?,
        format: json['format'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'value': value,
        'format': format,
      };
}
