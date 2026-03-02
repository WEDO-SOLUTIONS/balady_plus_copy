import 'dart:convert';

import 'package:balady_plus/mini_apps_engine/data/models/mini_app_model.dart';

class NewMiniAppLogicResponseModel {
  final StatusDetails statusDetails;
  final NewMiniAppsData data;

  NewMiniAppLogicResponseModel({
    required this.statusDetails,
    required this.data,
  });

  factory NewMiniAppLogicResponseModel.fromJson(Map<String, dynamic> json) {
    return NewMiniAppLogicResponseModel(
      statusDetails: StatusDetails.fromJson(
        json['statusDetails'] as Map<String, dynamic>,
      ),
      data: NewMiniAppsData.fromJson(
        json['data'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusDetails': statusDetails.toJson(),
      'data': data.toJson(),
    };
  }

  static NewMiniAppLogicResponseModel fromJsonString(String source) {
    return NewMiniAppLogicResponseModel.fromJson(
      json.decode(source) as Map<String, dynamic>,
    );
  }
}

class StatusDetails {
  final int code;
  final String message;

  StatusDetails({
    required this.code,
    required this.message,
  });

  factory StatusDetails.fromJson(Map<String, dynamic> json) {
    return StatusDetails(
      code: json['code'] as int,
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
    };
  }
}

class NewMiniAppsData {
  final String responseCode;
  final String responseMessage;
  final String responseId;
  final Data result;

  NewMiniAppsData({
    required this.responseCode,
    required this.responseMessage,
    required this.responseId,
    required this.result,
  });

  factory NewMiniAppsData.fromJson(Map<String, dynamic> json) {
    return NewMiniAppsData(
      responseCode: json['responseCode'] as String,
      responseMessage: json['responseMessage'] as String,
      responseId: json['responseId'] as String,
      result: Data.fromJson(json['result'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'responseCode': responseCode,
      'responseMessage': responseMessage,
      'responseId': responseId,
      'result': result.toJson(),
    };
  }
}

class Data {
  final List<MiniApp> miniApps;
  final List<DataCategory> categories;
  final List<DataEntryPoint> entryPoints;

  Data({
    required this.miniApps,
    required this.categories,
    required this.entryPoints,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      miniApps: (json['miniApps'] as List<dynamic>).map((e) => MiniApp.fromJson(e as Map<String, dynamic>)).toList(),
      categories:
          (json['categories'] as List<dynamic>).map((e) => DataCategory.fromJson(e as Map<String, dynamic>)).toList(),
      entryPoints: (json['entryPoints'] as List<dynamic>)
          .map((e) => DataEntryPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'miniApps': miniApps.map((e) => e.toJson()).toList(),
      'categories': categories.map((e) => e.toJson()).toList(),
      'entryPoints': entryPoints.map((e) => e.toJson()).toList(),
    };
  }
}

/// ================= CATEGORIES & ENTRY POINTS =================

class DataCategory {
  final String id;
  final String arName;
  final String enName;
  final String arDescription;
  final String enDescription;
  final String createdBy;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? updatedBy;
  final int? order;
  final bool isActive;

  DataCategory({
    required this.id,
    required this.arName,
    required this.enName,
    required this.arDescription,
    required this.enDescription,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.updatedBy,
    required this.order,
    required this.isActive,
  });

  factory DataCategory.fromJson(Map<String, dynamic> json) {
    return DataCategory(
      id: json['id'] as String,
      arName: json['arName'] as String,
      enName: json['enName'] as String,
      arDescription: json['arDescription'] as String,
      enDescription: json['enDescription'] as String,
      createdBy: json['createdBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null ? null : DateTime.parse(json['updatedAt'] as String),
      updatedBy: json['updatedBy'] as String?,
      order: json['order'] as int?,
      isActive: json['isActive'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'arName': arName,
      'enName': enName,
      'arDescription': arDescription,
      'enDescription': enDescription,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'updatedBy': updatedBy,
      'order': order,
      'isActive': isActive,
    };
  }
}

class DataEntryPoint {
  final String id;
  final String entryPointKey;
  final String arName;
  final String enName;
  final String createdBy;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? updatedBy;
  final bool isActive;

  DataEntryPoint({
    required this.id,
    required this.entryPointKey,
    required this.arName,
    required this.enName,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.updatedBy,
    required this.isActive,
  });

  factory DataEntryPoint.fromJson(Map<String, dynamic> json) {
    return DataEntryPoint(
      id: json['id'] as String,
      entryPointKey: json['entryPointKey'] as String,
      arName: json['arName'] as String,
      enName: json['enName'] as String,
      createdBy: json['createdBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null ? null : DateTime.parse(json['updatedAt'] as String),
      updatedBy: json['updatedBy'] as String?,
      isActive: json['isActive'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'entryPointKey': entryPointKey,
      'arName': arName,
      'enName': enName,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'updatedBy': updatedBy,
      'isActive': isActive,
    };
  }
}

/// ================= MINI APP & RELATED MODELS =================

class MiniApp {
  final String id;
  final String name;
  final String description;
  final String entity;
  final String iconPath;
  final String serviceKey;
  final String? parentServiceKey;
  final String cdnLogoRef;
  final String attachmentConfiguration;
  final int? serviceOrder;
  final int? portNumber;
  final bool haveChilds;
  final bool isChild;
  final bool nafathLogin;
  final bool otpLogin;
  final List<Requirement> requirements;
  final List<MiniAppEntryPoint> entryPoints;
  final List<MiniAppCategory> categories;
  final String? childDeepLinkUrl;
  final LatestVersion? latestVersion;
  final List<MiniApp>? childServices;
  final dynamic parentService;
  final int serviceCategoryOrder;
  final int serviceEntryPointOrder;

  final String? path;

  MiniApp({
    required this.id,
    required this.name,
    required this.description,
    required this.entity,
    required this.iconPath,
    required this.serviceKey,
    required this.parentServiceKey,
    required this.cdnLogoRef,
    required this.attachmentConfiguration,
    required this.serviceOrder,
    required this.portNumber,
    required this.haveChilds,
    required this.isChild,
    required this.nafathLogin,
    required this.otpLogin,
    required this.requirements,
    required this.entryPoints,
    required this.categories,
    required this.childDeepLinkUrl,
    required this.latestVersion,
    required this.childServices,
    required this.parentService,
    required this.serviceCategoryOrder,
    required this.serviceEntryPointOrder,
    this.path,
  });

  factory MiniApp.fromJson(Map<String, dynamic> json) {
    return MiniApp(
      id: json['id'] as String,
      name: json['serviceName'] as String,
      description: json['description'] as String,
      entity: json['entity'] as String,
      iconPath: json['logoKey'] as String,
      serviceKey: json['serviceKey'] as String,
      parentServiceKey: json['parentServiceKey'] as String?,
      cdnLogoRef: json['cdnLogoRef'] as String,
      attachmentConfiguration: json['attachmentConfiguration'] as String,
      serviceOrder: json['serviceOrder'] as int?,
      portNumber: json['portNumber'] is String ? int.tryParse(json['portNumber']) : json['portNumber'],
      haveChilds: json['haveChilds'] as bool,
      isChild: json['isChild'] as bool,
      nafathLogin: json['nafathLogin'] as bool,
      otpLogin: json['otpLogin'] as bool,
      requirements:
          (json['requirements'] as List<dynamic>).map((e) => Requirement.fromJson(e as Map<String, dynamic>)).toList(),
      entryPoints: (json['entryPoints'] as List<dynamic>)
          .map((e) => MiniAppEntryPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      categories: (json['categories'] as List<dynamic>)
          .map((e) => MiniAppCategory.fromJson(e as Map<String, dynamic>))
          .toList(),
      childDeepLinkUrl: json['childDeepLinkUrl'] as String?,
      latestVersion: json['latestVersion'] == null
          ? null
          : LatestVersion.fromJson(
              json['latestVersion'] as Map<String, dynamic>,
            ),
      childServices: json['childServices'] == null
          ? null
          : (json['childServices'] as List<dynamic>).map((e) => MiniApp.fromJson(e as Map<String, dynamic>)).toList(),
      parentService: json['parentService'],
      serviceCategoryOrder: json['serviceCategoryOrder'] as int,
      serviceEntryPointOrder: json['serviceEntryPointOrder'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serviceName': name,
      'description': description,
      'entity': entity,
      'logoKey': iconPath,
      'serviceKey': serviceKey,
      'parentServiceKey': parentServiceKey,
      'cdnLogoRef': cdnLogoRef,
      'attachmentConfiguration': attachmentConfiguration,
      'serviceOrder': serviceOrder,
      'portNumber': portNumber,
      'haveChilds': haveChilds,
      'isChild': isChild,
      'requirements': requirements.map((e) => e.toJson()).toList(),
      'entryPoints': entryPoints.map((e) => e.toJson()).toList(),
      'categories': categories.map((e) => e.toJson()).toList(),
      'childDeepLinkUrl': childDeepLinkUrl,
      'latestVersion': latestVersion?.toJson(),
      'childServices': childServices?.map((e) => e.toJson()).toList(),
      'parentService': parentService,
      'serviceCategoryOrder': serviceCategoryOrder,
      'serviceEntryPointOrder': serviceEntryPointOrder,
      'nafathLogin': nafathLogin,
      'otpLogin': otpLogin,
    };
  }

  MiniApp copyWith({
    String? id,
    String? name,
    String? description,
    String? entity,
    String? iconPath,
    String? serviceKey,
    String? parentServiceKey,
    String? cdnLogoRef,
    String? attachmentConfiguration,
    int? serviceOrder,
    int? portNumber,
    bool? haveChilds,
    bool? isChild,
    List<Requirement>? requirements,
    List<MiniAppEntryPoint>? entryPoints,
    List<MiniAppCategory>? categories,
    String? childDeepLinkUrl,
    LatestVersion? latestVersion,
    List<MiniApp>? childServices,
    dynamic parentService,
    int? serviceCategoryOrder,
    int? serviceEntryPointOrder,
    String? path,
    bool? nafathLogin,
    bool? otpLogin,
  }) {
    return MiniApp(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      entity: entity ?? this.entity,
      iconPath: iconPath ?? this.iconPath,
      serviceKey: serviceKey ?? this.serviceKey,
      parentServiceKey: parentServiceKey ?? this.parentServiceKey,
      cdnLogoRef: cdnLogoRef ?? this.cdnLogoRef,
      attachmentConfiguration: attachmentConfiguration ?? this.attachmentConfiguration,
      serviceOrder: serviceOrder ?? this.serviceOrder,
      portNumber: portNumber ?? this.portNumber,
      haveChilds: haveChilds ?? this.haveChilds,
      isChild: isChild ?? this.isChild,
      requirements: requirements ?? this.requirements,
      entryPoints: entryPoints ?? this.entryPoints,
      categories: categories ?? this.categories,
      childDeepLinkUrl: childDeepLinkUrl ?? this.childDeepLinkUrl,
      latestVersion: latestVersion ?? this.latestVersion,
      childServices: childServices ?? this.childServices,
      parentService: parentService ?? this.parentService,
      serviceCategoryOrder: serviceCategoryOrder ?? this.serviceCategoryOrder,
      serviceEntryPointOrder: serviceEntryPointOrder ?? this.serviceEntryPointOrder,
      path: path ?? this.path,
      nafathLogin: nafathLogin ?? this.nafathLogin,
      otpLogin: otpLogin ?? this.otpLogin,
    );
  }
}

class MiniAppCategory {
  final String id;
  final String name;
  final int? categoryOrder;
  final int? serviceOrderByCategory;

  MiniAppCategory({
    required this.id,
    required this.name,
    required this.categoryOrder,
    required this.serviceOrderByCategory,
  });

  factory MiniAppCategory.fromJson(Map<String, dynamic> json) {
    return MiniAppCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      categoryOrder: json['categoryOrder'] as int?,
      serviceOrderByCategory: json['serviceOrderByCategory'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'categoryOrder': categoryOrder,
      'serviceOrderByCategory': serviceOrderByCategory,
    };
  }
}

class MiniAppEntryPoint {
  final String entryPointKey;
  final String name;
  final int? serviceOrderByEntryPoint;

  MiniAppEntryPoint({
    required this.entryPointKey,
    required this.name,
    required this.serviceOrderByEntryPoint,
  });

  factory MiniAppEntryPoint.fromJson(Map<String, dynamic> json) {
    return MiniAppEntryPoint(
      entryPointKey: json['entryPointKey'] as String,
      name: json['name'] as String,
      serviceOrderByEntryPoint: json['serviceOrderByEntryPoint'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'entryPointKey': entryPointKey,
      'name': name,
      'serviceOrderByEntryPoint': serviceOrderByEntryPoint,
    };
  }
}

class LatestVersion {
  final String id;
  final String versionDescription;
  final String versionNumber;
  final String? serviceUrl;
  final bool nafathLogin;
  final bool otpLogin;
  final bool forceUpdate;
  final int status;
  final PackageMetaDataDto? packageMetaDataDto;
  final PackageMetaDataDto? webPackageMetaDataDto;
  final dynamic androidPackageMetaDataDto;
  final dynamic iosPackageMetaDataDto;

  // final DeepLinkDto? deepLinkDto;

  final DeepLinkModel? deepLinkDto;
  final int type;
  final dynamic notes;

  LatestVersion({
    required this.id,
    required this.versionDescription,
    required this.versionNumber,
    required this.serviceUrl,
    required this.nafathLogin,
    required this.otpLogin,
    required this.forceUpdate,
    required this.status,
    required this.packageMetaDataDto,
    required this.webPackageMetaDataDto,
    required this.androidPackageMetaDataDto,
    required this.iosPackageMetaDataDto,
    required this.deepLinkDto,
    required this.type,
    required this.notes,
  });

  factory LatestVersion.fromJson(Map<String, dynamic> json) {
    return LatestVersion(
      id: json['id'] as String,
      versionDescription: json['versionDescription'] as String,
      versionNumber: json['versionNumber'] as String,
      serviceUrl: json['serviceUrl'] as String?,
      nafathLogin: json['nafathLogin'] as bool,
      otpLogin: json['otpLogin'] as bool,
      forceUpdate: json['forceUpdate'] as bool,
      status: json['status'] as int,
      packageMetaDataDto: json['packageMetaDataDto'] == null
          ? null
          : PackageMetaDataDto.fromJson(
              json['packageMetaDataDto'] as Map<String, dynamic>,
            ),
      webPackageMetaDataDto: json['webPackageMetaDataDto'] == null
          ? null
          : PackageMetaDataDto.fromJson(
              json['webPackageMetaDataDto'] as Map<String, dynamic>,
            ),
      androidPackageMetaDataDto: json['androidPackageMetaDataDto'],
      iosPackageMetaDataDto: json['iosPackageMetaDataDto'],
      deepLinkDto:
          json['deepLinkDto'] == null ? null : DeepLinkModel.fromJson(json['deepLinkDto'] as Map<String, dynamic>),
      type: json['type'] as int,
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'versionDescription': versionDescription,
      'versionNumber': versionNumber,
      'serviceUrl': serviceUrl,
      'nafathLogin': nafathLogin,
      'otpLogin': otpLogin,
      'forceUpdate': forceUpdate,
      'status': status,
      'packageMetaDataDto': packageMetaDataDto?.toJson(),
      'webPackageMetaDataDto': webPackageMetaDataDto?.toJson(),
      'androidPackageMetaDataDto': androidPackageMetaDataDto,
      'iosPackageMetaDataDto': iosPackageMetaDataDto,
      'deepLinkDto': deepLinkDto,
      'type': type,
      'notes': notes,
    };
  }
}

/*
class DeepLinkDto {
  final String androidPackageName;
  final String iosUrlScheme;
  final String appStoreId;
  final String playStoreId;
  final String deepLinkAndroid;
  final String deepLinkIos;
  final bool isUniversal;

  DeepLinkDto({
    required this.androidPackageName,
    required this.iosUrlScheme,
    required this.appStoreId,
    required this.playStoreId,
    required this.deepLinkAndroid,
    required this.deepLinkIos,
    required this.isUniversal,
  });

  factory DeepLinkDto.fromJson(Map<String, dynamic> json) {
    return DeepLinkDto(
      androidPackageName: json['androidPackageName'] as String,
      iosUrlScheme: json['iosUrlScheme'] as String,
      appStoreId: json['appStoreId'] as String,
      playStoreId: json['playStoreId'] as String,
      deepLinkAndroid: json['deepLinkAndroid'] as String,
      deepLinkIos: json['deepLinkIOS'] as String,
      isUniversal: json['isUniversal'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'androidPackageName': androidPackageName,
      'iosUrlScheme': iosUrlScheme,
      'appStoreId': appStoreId,
      'playStoreId': playStoreId,
      'deepLinkAndroid': deepLinkAndroid,
      'deepLinkIOS': deepLinkIos,
      'isUniversal': isUniversal,
    };
  }
}
*/
class PackageMetaDataDto {
  final String id;
  final String extension;
  final String size;
  final String name;
  final String? cdnFileRef;
  final String type;

  PackageMetaDataDto({
    required this.id,
    required this.extension,
    required this.size,
    required this.name,
    required this.cdnFileRef,
    required this.type,
  });

  factory PackageMetaDataDto.fromJson(Map<String, dynamic> json) {
    return PackageMetaDataDto(
      id: json['id'] as String,
      extension: json['extension'] as String,
      size: json['size'] as String,
      name: json['name'] as String,
      cdnFileRef: json['cdnFileRef'] as String?,
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'extension': extension,
      'size': size,
      'name': name,
      'cdnFileRef': cdnFileRef,
      'type': type,
    };
  }
}

class Requirement {
  final String requirementKey;
  final String name;

  Requirement({
    required this.requirementKey,
    required this.name,
  });

  factory Requirement.fromJson(Map<String, dynamic> json) {
    return Requirement(
      requirementKey: json['requirementKey'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'requirementKey': requirementKey,
      'name': name,
    };
  }
}
