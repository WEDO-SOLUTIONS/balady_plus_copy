import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/constants/paths/image_paths.dart';

class HomeServices {
  final MostUsedServiceModel mostUsedService;
  final List<Service> mostUsedServices;
  final List<ServicesCategory> servicesCategories;
  final List<Service> miniApps;

  HomeServices({
    required this.mostUsedService,
    required this.mostUsedServices,
    required this.servicesCategories,
    required this.miniApps,
  });

  HomeServices copyWith({
    MostUsedServiceModel? mostUsedService,
    List<Service>? mostUsedServices,
    List<Service>? miniApps,
    List<ServicesCategory>? servicesCategories,
  }) =>
      HomeServices(
        mostUsedService: mostUsedService ?? this.mostUsedService,
        mostUsedServices: mostUsedServices ?? this.mostUsedServices,
        servicesCategories: servicesCategories ?? this.servicesCategories,
        miniApps: miniApps ?? this.miniApps,
      );

  factory HomeServices.fromJson(Map<String, dynamic> json) {
    return HomeServices(
      mostUsedService: MostUsedServiceModel.fromJson(json["featuredService"]),
      mostUsedServices: json["mostUsedServices"] == null
          ? []
          : List<Service>.from(
              json["mostUsedServices"]!.map((x) => Service.fromJson(x)),
            ),
      miniApps: json["mainServices"] == null
          ? []
          : List<Service>.from(
              json["mainServices"]!.map((x) => Service.fromJson(x)),
            ),
      servicesCategories: json["servicesCategories"] == null
          ? []
          : List<ServicesCategory>.from(
              json["servicesCategories"]!.map(
                (x) => ServicesCategory.fromJson(x),
              ),
            ),
    );
  }

  Map<String, dynamic> toJson() => {
        "mostUsedService": mostUsedService.toJson(),
        "mostUsedServices": mostUsedServices.map((x) => x.toJson()).toList(),
        "servicesCategories":
            servicesCategories.map((x) => x.toJson()).toList(),
      };
}

class MostUsedServiceModel {
  final String title;
  final String label;
  final String color;
  final Service? service;

  MostUsedServiceModel({
    required this.title,
    required this.label,
    required this.color,
    required this.service,
  });

  MostUsedServiceModel copyWith({
    String? title,
    String? label,
    String? color,
    Service? service,
  }) =>
      MostUsedServiceModel(
        title: title ?? this.title,
        label: label ?? this.label,
        color: color ?? this.color,
        service: service ?? this.service,
      );

  factory MostUsedServiceModel.fromJson(Map<String, dynamic> json) {
    return MostUsedServiceModel(
      title: json["title"],
      label: json["label"],
      color: json["color"],
      service:
          json["service"] != null ? Service.fromJson(json["service"]) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "title": title,
        "label": label,
        "color": color,
        "service": service?.toJson(),
      };
}

class Service {
  final String id;
  final String title;
  final String label;
  final String icon;
  final String image;
  final int order;
  final bool isNew;
  final bool requireLogin;
  final LevelLogin levelLogin;
  final ActionType actionType;
  final String actionValue;
  final List<Service> subServices;
  final int? serviceId;
  final String? eventName;
  final bool requireSelectedDelegator;

  Service({
    required this.id,
    required this.title,
    required this.label,
    required this.icon,
    required this.image,
    required this.order,
    required this.isNew,
    required this.requireLogin,
    required this.levelLogin,
    required this.actionType,
    required this.actionValue,
    required this.subServices,
    required this.serviceId,
    required this.eventName,
    required this.requireSelectedDelegator,
  });

  Service copyWith({
    String? id,
    String? title,
    String? label,
    String? icon,
    String? image,
    int? order,
    bool? isNew,
    bool? requireLogin,
    LevelLogin? levelLogin,
    ActionType? actionType,
    String? actionValue,
    List<Service>? subServices,
    int? serviceId,
    String? eventName,
    bool? requireSelectedDelegator,
  }) =>
      Service(
        id: id ?? this.id,
        title: title ?? this.title,
        label: label ?? this.label,
        icon: icon ?? this.icon,
        image: image ?? this.image,
        order: order ?? this.order,
        isNew: isNew ?? this.isNew,
        requireLogin: requireLogin ?? this.requireLogin,
        levelLogin: levelLogin ?? this.levelLogin,
        actionType: actionType ?? this.actionType,
        actionValue: actionValue ?? this.actionValue,
        subServices: subServices ?? this.subServices,
        serviceId: serviceId ?? this.serviceId,
        eventName: eventName ?? this.eventName ?? "",
        requireSelectedDelegator:
            requireSelectedDelegator ?? this.requireSelectedDelegator,
      );

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json["id"].toString(),
      title: json["title"],
      label: json["label"] ?? "",
      icon: json["service_icon"] ?? IconPath.infoCircle,
      image: json["services_image"] ?? ImagePath.featureServiceImage,
      order: json["order"].isNotEmpty ? (int.tryParse(json["order"]) ?? 0) : 0,
      isNew: json["isnew"] == "1",
      requireLogin: json["require_login"] == "1",
      levelLogin: LevelLoginMap.fromString(json['level_login']),
      actionType: ActionTypeMap.fromString(json['actiontype']),
      actionValue: json["actionvalue"],
      subServices: json["subServices"] == null
          ? json["sub_services"] == null
              ? []
              : List<Service>.from(
                  json["sub_services"]!.map(
                    (x) => Service.fromJson(x),
                  ),
                )
          : List<Service>.from(
              json["subServices"]!.map(
                (x) => Service.fromJson(x),
              ),
            ),
      serviceId: int.tryParse(json["serviceId"] ?? ""),
      eventName: json["eventName"],
      requireSelectedDelegator: json["requireselecteddelegator"] == "1",
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "label": label,
        "icon": icon,
        "image": image,
        "order": order,
        "isNew": isNew,
        "requireLogin": requireLogin,
        "levelLogin": levelLogin,
        "actionType": actionType,
        "actionValue": actionValue,
        "subServices": subServices.map((x) => x?.toJson()).toList(),
        "serviceId": serviceId,
        "eventName": eventName,
        "requireselecteddelegator": requireSelectedDelegator,
      };
}

enum ActionType {
  page,
  openBaladyWebView,
}

extension ActionTypeMap on ActionType {
  static const valueMap = {
    ActionType.page: "page",
    ActionType.openBaladyWebView: "openBaladyWebView",
  };

  String? get value => valueMap[this];

  static ActionType fromString(String input) {
    final reverseValueMap =
        valueMap.map<String, ActionType>((key, value) => MapEntry(value, key));

    ActionType? output = reverseValueMap[input];
    if (output == null) {
      throw 'Invalid String Input';
    }

    return output;
  }
}

enum LevelLogin { guest, sso }

extension LevelLoginMap on LevelLogin {
  static const valueMap = {
    LevelLogin.guest: "guest",
    LevelLogin.sso: "sso",
  };

  String? get value => valueMap[this];

  static LevelLogin fromString(String input) {
    final reverseValueMap =
        valueMap.map<String, LevelLogin>((key, value) => MapEntry(value, key));

    LevelLogin? output = reverseValueMap[input];
    if (output == null) {
      throw 'Invalid String Input';
    }

    return output;
  }
}

class ServicesCategory {
  final String title;
  final String name;
  final String icon;
  final List<Service> listOfServices;

  ServicesCategory({
    required this.title,
    required this.name,
    required this.icon,
    required this.listOfServices,
  });

  ServicesCategory copyWith({
    String? title,
    String? name,
    String? icon,
    List<Service>? subServices,
    List<Service>? listOfServices,
  }) =>
      ServicesCategory(
        title: title ?? this.title,
        name: name ?? this.name,
        icon: icon ?? this.icon,
        listOfServices: listOfServices ?? this.listOfServices,
      );

  factory ServicesCategory.fromJson(Map<String, dynamic> json) {
    return ServicesCategory(
      title: json["title"] ?? "",
      name: json["name"] ?? "",
      icon: json["category_icon"] ?? IconPath.infoCircle,
      listOfServices: json["listOfServices"] == null
          ? []
          : List<Service>.from(
              json["listOfServices"]!.map((x) => Service.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "title": title,
        "name": name,
        "icon": icon,
        "listOfServices": listOfServices.map((x) => x?.toJson()).toList(),
      };
}
