
  class PermitApplyGroupResponse {
  PermitApplyGroupResponse({
  this.requestId,
  this.requestKey,
  this.appliedLicenses,
    this.posterViewConfigs,});

  PermitApplyGroupResponse.fromJson(dynamic json) {
  requestId = json['requestId'];
  requestKey = json['requestKey'];
  if (json['appliedLicenses'] != null) {
  appliedLicenses = [];
  json['appliedLicenses'].forEach((v) {
  appliedLicenses?.add(AppliedLicenses.fromJson(v));
  });

  posterViewConfigs = json['posterViewConfigs'] != null ? PosterViewConfigs.fromJson(json['posterViewConfigs']) : null;

  }
  }
  int? requestId;
  String? requestKey;
  List<AppliedLicenses>? appliedLicenses;

  PosterViewConfigs? posterViewConfigs;
  PermitApplyGroupResponse copyWith({  int? requestId,
  String? requestKey,
  List<AppliedLicenses>? appliedLicenses,
  }) => PermitApplyGroupResponse(  requestId: requestId ?? this.requestId,
  requestKey: requestKey ?? this.requestKey,
  appliedLicenses: appliedLicenses ?? this.appliedLicenses,
  );
  Map<String, dynamic> toJson() {
  final map = <String, dynamic>{};
  map['requestId'] = requestId;
  map['requestKey'] = requestKey;
  if (appliedLicenses != null) {
  map['appliedLicenses'] = appliedLicenses?.map((v) => v.toJson()).toList();
  }
  if (posterViewConfigs != null) {
    map['posterViewConfigs'] = posterViewConfigs?.toJson();
  }
  return map;
  }

  }

  class AppliedLicenses {
  AppliedLicenses({
  this.licenseId,
  this.status,
  this.municipality,
  this.subMunicipality,
  this.licenseExpiryDate,
 });

  AppliedLicenses.fromJson(dynamic json) {
  licenseId = json['licenseId'];
  status = json['status'] != null ? Status.fromJson(json['status']) : null;
  municipality = json['municipality'] != null ? Municipality.fromJson(json['municipality']) : null;
  subMunicipality = json['subMunicipality'] != null ? SubMunicipality.fromJson(json['subMunicipality']) : null;
  licenseExpiryDate = json['licenseExpiryDate'];
  }
  int? licenseId;
  Status? status;
  Municipality? municipality;
  SubMunicipality? subMunicipality;
  String? licenseExpiryDate;

  AppliedLicenses copyWith({  int? licenseId,
  Status? status,
  Municipality? municipality,
  SubMunicipality? subMunicipality,
  String? licenseExpiryDate,
  PosterViewConfigs? posterViewConfigs,
  }) => AppliedLicenses(  licenseId: licenseId ?? this.licenseId,
  status: status ?? this.status,
  municipality: municipality ?? this.municipality,
  subMunicipality: subMunicipality ?? this.subMunicipality,
  licenseExpiryDate: licenseExpiryDate ?? this.licenseExpiryDate,

  );
  Map<String, dynamic> toJson() {
  final map = <String, dynamic>{};
  map['licenseId'] = licenseId;
  if (status != null) {
  map['status'] = status?.toJson();
  }
  if (municipality != null) {
  map['municipality'] = municipality?.toJson();
  }
  if (subMunicipality != null) {
  map['subMunicipality'] = subMunicipality?.toJson();
  }
  map['licenseExpiryDate'] = licenseExpiryDate;

  return map;
  }

  }

  class PosterViewConfigs {
  PosterViewConfigs({
  this.message,
  this.posterTypes,});

  PosterViewConfigs.fromJson(dynamic json) {
  message = json['message'];
  if (json['posterTypes'] != null) {
  posterTypes = [];
  json['posterTypes'].forEach((v) {
  posterTypes?.add(PosterTypes.fromJson(v));
  });
  }
  }
  String? message;
  List<PosterTypes>? posterTypes;
  PosterViewConfigs copyWith({  String? message,
  List<PosterTypes>? posterTypes,
  }) => PosterViewConfigs(  message: message ?? this.message,
  posterTypes: posterTypes ?? this.posterTypes,
  );
  Map<String, dynamic> toJson() {
  final map = <String, dynamic>{};
  map['message'] = message;
  if (posterTypes != null) {
  map['posterTypes'] = posterTypes?.map((v) => v.toJson()).toList();
  }
  return map;
  }

  }

  class PosterTypes {
  PosterTypes({
  this.id,
  this.name,});

  PosterTypes.fromJson(dynamic json) {
  id = json['id'];
  name = json['name'];
  }
  int? id;
  String? name;
  PosterTypes copyWith({  int? id,
  String? name,
  }) => PosterTypes(  id: id ?? this.id,
  name: name ?? this.name,
  );
  Map<String, dynamic> toJson() {
  final map = <String, dynamic>{};
  map['id'] = id;
  map['name'] = name;
  return map;
  }

  }

  class SubMunicipality {
  SubMunicipality({
  this.id,
  this.name,});

  SubMunicipality.fromJson(dynamic json) {
  id = json['id'];
  name = json['name'];
  }
  String? id;
  String? name;
  SubMunicipality copyWith({  String? id,
  String? name,
  }) => SubMunicipality(  id: id ?? this.id,
  name: name ?? this.name,
  );
  Map<String, dynamic> toJson() {
  final map = <String, dynamic>{};
  map['id'] = id;
  map['name'] = name;
  return map;
  }

  }

  class Municipality {
  Municipality({
  this.id,
  this.name,});

  Municipality.fromJson(dynamic json) {
  id = json['id'];
  name = json['name'];
  }
  String? id;
  String? name;
  Municipality copyWith({  String? id,
  String? name,
  }) => Municipality(  id: id ?? this.id,
  name: name ?? this.name,
  );
  Map<String, dynamic> toJson() {
  final map = <String, dynamic>{};
  map['id'] = id;
  map['name'] = name;
  return map;
  }

  }

  class Status {
  Status({
  this.id,
  this.name,});

  Status.fromJson(dynamic json) {
  id = json['id'];
  name = json['name'];
  }
  String? id;
  String? name;
  Status copyWith({  String? id,
  String? name,
  }) => Status(  id: id ?? this.id,
  name: name ?? this.name,
  );
  Map<String, dynamic> toJson() {
  final map = <String, dynamic>{};
  map['id'] = id;
  map['name'] = name;
  return map;
  }

  }