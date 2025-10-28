class MiniAppModel {
  MiniAppModel(
      {this.id,
      this.serviceName,
      this.description,
      this.entity,
      this.requirements,
      this.serviceKey,
      this.cdnLogoRef,
      this.portNumber,
      this.logoKey,
      this.latestVersion,
      this.path});

  MiniAppModel.fromJson(dynamic json) {
    id = json['id'];
    serviceName = json['serviceName'];
    serviceKey = json['serviceKey'];
    description = json['description'];
    cdnLogoRef = json['cdnLogoRef'];
    portNumber =
        json['portNumber'] != null ? int.tryParse(json['portNumber']) : null;
    entity = json['entity'];
    logoKey = json['logoKey'];
    latestVersion = json['latestVersion'] != null
        ? LatestVersion.fromJson(json['latestVersion'])
        : null;
    path = json['path'] ?? "";
    if (json['requirements'] != null) {
      requirements = [];
      json['requirements'].forEach((v) {
        requirements?.add(Requirements.fromJson(v));
      });
    }
  }

  String? id;
  String? serviceName;
  List<Requirements>? requirements;
  String? serviceKey;
  String? cdnLogoRef;
  int? portNumber;
  String? description;
  String? entity;
  String? logoKey;
  LatestVersion? latestVersion;
  String? path;

  MiniAppModel copyWith(
          {String? id,
          String? serviceName,
          String? description,
          String? cdnLogoRef,
          int? portNumber,
          String? serviceKey,
          String? entity,
          String? logoKey,
          List<Requirements>? requirements,
          LatestVersion? latestVersion,
          String? path}) =>
      MiniAppModel(
          id: id ?? this.id,
          serviceKey: serviceKey ?? this.serviceKey,
          serviceName: serviceName ?? this.serviceName,
          description: description ?? this.description,
          entity: entity ?? this.entity,
          cdnLogoRef: cdnLogoRef ?? this.cdnLogoRef,
          portNumber: portNumber ?? this.portNumber,
          requirements: requirements ?? this.requirements,
          logoKey: logoKey ?? this.logoKey,
          latestVersion: latestVersion ?? this.latestVersion,
          path: path ?? this.path);
}

class LatestVersion {
  LatestVersion(
      {this.id,
      this.versionDescription,
      this.versionNumber,
      this.serviceUrl,
      this.nafathLogin,
      this.otpLogin,
      this.forceUpdate,
      this.packageMetaDataDto,
      this.status,
      this.type,
      this.deepLinkModel});

  LatestVersion.fromJson(dynamic json) {
    id = json['id'];
    versionDescription = json['versionDescription'];
    versionNumber = json['versionNumber'];
    serviceUrl = json['serviceUrl'];
    nafathLogin = json['nafathLogin'];
    otpLogin = json['otpLogin'];
    forceUpdate = json['forceUpdate'];
    packageMetaDataDto = json['packageMetaDataDto'] != null
        ? PackageMetaDataDto.fromJson(json['packageMetaDataDto'])
        : null;
    status = json['status'];
    type = json['type'];
    deepLinkModel = json['deepLinkDto'] != null
        ? DeepLinkModel.fromJson(json['deepLinkDto'])
        : null;
  }

  String? id;
  String? versionDescription;
  String? versionNumber;
  dynamic serviceUrl;
  bool? nafathLogin;
  bool? otpLogin;
  bool? forceUpdate;
  PackageMetaDataDto? packageMetaDataDto;
  int? status;
  int? type;
  DeepLinkModel? deepLinkModel;

  LatestVersion copyWith({
    String? id,
    String? versionDescription,
    String? versionNumber,
    dynamic serviceUrl,
    bool? nafathLogin,
    bool? otpLogin,
    bool? forceUpdate,
    PackageMetaDataDto? packageMetaDataDto,
    int? status,
    int? type,
  }) =>
      LatestVersion(
        id: id ?? this.id,
        versionDescription: versionDescription ?? this.versionDescription,
        versionNumber: versionNumber ?? this.versionNumber,
        serviceUrl: serviceUrl ?? this.serviceUrl,
        nafathLogin: nafathLogin ?? this.nafathLogin,
        otpLogin: otpLogin ?? this.otpLogin,
        forceUpdate: forceUpdate ?? this.forceUpdate,
        packageMetaDataDto: packageMetaDataDto ?? this.packageMetaDataDto,
        status: status ?? this.status,
        type: type ?? this.type,
      );
}

class PackageMetaDataDto {
  PackageMetaDataDto({
    required this.id,
    this.extension,
    this.size,
    this.name,
  });

  factory PackageMetaDataDto.fromJson(dynamic json) => PackageMetaDataDto(
        id: json['id'] ?? "",
        extension: json['extension'],
        size: json['size'],
        name: json['name'],
      );

  String id;
  String? extension;
  String? size;
  String? name;

  PackageMetaDataDto copyWith({
    String? id,
    String? extension,
    String? size,
    String? name,
  }) =>
      PackageMetaDataDto(
        id: id ?? this.id,
        extension: extension ?? this.extension,
        size: size ?? this.size,
        name: name ?? this.name,
      );
}

class Requirements {
  Requirements({
    this.requirementKey,
    this.name,
  });

  Requirements.fromJson(dynamic json) {
    requirementKey = json['requirementKey'];
    name = json['name'];
  }

  String? requirementKey;
  String? name;

  Requirements copyWith({
    String? requirementKey,
    String? name,
  }) =>
      Requirements(
        requirementKey: requirementKey ?? this.requirementKey,
        name: name ?? this.name,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['requirementKey'] = requirementKey;
    map['name'] = name;
    return map;
  }
}

class DeepLinkModel {
  final String? androidPackageName;
  final String? iosUrlScheme;
  final String? appStoreId;
  final String? playStoreId;
  final String? deepLinkAndroid;
  final String? deepLinkIos;

  DeepLinkModel({
    this.androidPackageName,
    this.iosUrlScheme,
    this.appStoreId,
    this.playStoreId,
    this.deepLinkAndroid,
    this.deepLinkIos,
  });

  factory DeepLinkModel.fromJson(Map<String, dynamic> json) => DeepLinkModel(
        androidPackageName: json["androidPackageName"],
        iosUrlScheme: json["iosUrlScheme"],
        appStoreId: json["appStoreId"],
        playStoreId: json["playStoreId"],
        deepLinkAndroid: json["deepLinkAndroid"],
        deepLinkIos: json["deepLinkIOS"],
      );
}
