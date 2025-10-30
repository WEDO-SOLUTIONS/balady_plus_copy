import 'package:dgis_map/library.dart';
import 'package:equatable/equatable.dart';
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show SocialMediaTypes;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show Faq;


class ServiceDetailsResponse {
  Provider? provider;
  Service? service;

  ServiceDetailsResponse({this.provider, this.service});
}

class Provider {
  Provider({
    this.id,
    this.name,
    this.description,
    this.mainImageUrl,
    this.logoUrl,
    this.rating,
    this.ratingsCount,
    this.mainBranchAddress,
    this.mainBranchContact,
    this.email,
    this.website,
    this.mainBranchLocation,
    this.wrokDays,
    this.socialMediaAccounts,
    this.branches,
    this.projects,
  });

  String? id;
  String? name;
  String? description;
  String? mainImageUrl;
  String? logoUrl;
  double? rating;
  double? ratingsCount;
  String? mainBranchAddress;
  String? mainBranchContact;
  String? email;
  String? website;
  Location? mainBranchLocation;
  List<WorkDay>? wrokDays;
  List<SocialMediaAccount>? socialMediaAccounts;
  List<Branch>? branches;
  List<Project>? projects;
}

class Branch extends Equatable {
  Branch(
      {this.cityId,
      this.address,
      this.location,
      this.contact,
      this.email,
      this.name,
      this.id});

  String? id;
  String? cityId;
  String? address;
  Location? location;
  String? contact;
  String? email;
  String? name;

  LatLng? getLatLng() {
    double? lat = double.tryParse(location?.latitude ?? "");
    double? lon = double.tryParse(location?.longitude ?? "");

    if (lat != null && lon != null) return LatLng(latitude:lat, longitude:lon);
  }

  @override
  List<Object?> get props => [id];
}

class Location {
  Location({
    this.latitude,
    this.longitude,
  });

  String? latitude;
  String? longitude;

  LatLng? getLatLng() {
    double? lat = double.tryParse(latitude ?? "");
    double? lon = double.tryParse(longitude ?? "");

    if (lat != null && lon != null) return LatLng(latitude:lat, longitude:lon);
  }
}

class Project {
  Project({
    this.name,
    this.description,
    this.documentUrl,
    this.images,
  });

  String? name;
  String? description;
  String? documentUrl;
  List<String>? images;
}

class SocialMediaAccount {
  SocialMediaAccount({this.type, this.account, this.socialInfo});

  String? type;
  String? account;
  SocialMediaTypes? socialInfo;
}

class WorkDay {
  WorkDay({
    this.day,
    this.fullTime,
    this.closed,
    this.firstShift,
    this.secondShift,
  });

  String? day;
  bool? fullTime;
  bool? closed;
  Shift? firstShift;
  Shift? secondShift;
}

class Shift {
  Shift({
    this.from,
    this.to,
  });

  String? from;
  String? to;
}

class Service {
  Service({
    this.id,
    this.name,
    this.description,
    this.rating,
    this.ratingsCount,
    this.logoUrl,
    this.faqs,
  });

  String? id;
  String? name;
  String? description;
  double? rating;
  double? ratingsCount;
  String? logoUrl;
  List<Faq>? faqs;
}
