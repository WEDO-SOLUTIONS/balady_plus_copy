// To parse this JSON data, do
//
//     final miniAppModel = miniAppModelFromJson(jsonString);

class MiniAppModel {
  String id;
  String serviceName;
  String description;
  String entity;
  String logoKey;
  LatestVersion latestVersion;

  MiniAppModel({
    required this.id,
    required this.serviceName,
    required this.description,
    required this.entity,
    required this.logoKey,
    required this.latestVersion,
  });

  factory MiniAppModel.fromJson(Map<String, dynamic> json) => MiniAppModel(
    id: json["id"],
    serviceName: json["serviceName"],
    description: json["description"],
    entity: json["entity"],
    logoKey: json["logoKey"],
    latestVersion: LatestVersion.fromJson(json["latestVersion"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "serviceName": serviceName,
    "description": description,
    "entity": entity,
    "logoKey": logoKey,
    "latestVersion": latestVersion.toJson(),
  };
}

class LatestVersion {
  String id;
  String versionDescription;
  String versionNumber;
  String serviceUrl;
  bool needLogin;
  bool forceUpdate;
  PackageMetaDataDto packageMetaDataDto;
  int status;
  int type;

  LatestVersion({
    required this.id,
    required this.versionDescription,
    required this.versionNumber,
    required this.serviceUrl,
    required this.needLogin,
    required this.forceUpdate,
    required this.packageMetaDataDto,
    required this.status,
    required this.type,
  });

  factory LatestVersion.fromJson(Map<String, dynamic> json) => LatestVersion(
    id: json["id"],
    versionDescription: json["versionDescription"],
    versionNumber: json["versionNumber"],
    serviceUrl: json["serviceUrl"],
    needLogin: json["needLogin"],
    forceUpdate: json["forceUpdate"],
    packageMetaDataDto: PackageMetaDataDto.fromJson(json["packageMetaDataDto"]),
    status: json["status"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "versionDescription": versionDescription,
    "versionNumber": versionNumber,
    "serviceUrl": serviceUrl,
    "needLogin": needLogin,
    "forceUpdate": forceUpdate,
    "packageMetaDataDto": packageMetaDataDto.toJson(),
    "status": status,
    "type": type,
  };
}

class PackageMetaDataDto {
  String key;
  String id;
  String extension;
  String size;
  String name;

  PackageMetaDataDto({
    required this.key,
    required this.id,
    required this.extension,
    required this.size,
    required this.name,
  });

  factory PackageMetaDataDto.fromJson(Map<String, dynamic> json) => PackageMetaDataDto(
    key: json["key"],
    id: json["id"],
    extension: json["extension"],
    size: json["size"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "key": key,
    "id": id,
    "extension": extension,
    "size": size,
    "name": name,
  };
}
