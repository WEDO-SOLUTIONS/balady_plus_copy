import 'package:balady_plus/etmam_app/core/utils/constants/constans.dart';
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show SocialMediaTypes;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/data/models/faq_model.dart';
import 'package:balady_plus/etmam_app/features/services/services_exports.dart'
    show
        Branch,
        Location,
        Project,
        Provider,
        Service,
        ServiceDetailsResponse,
        Shift,
        SocialMediaAccount,
        WorkDay;

class ServiceDetailsResponseModel extends ServiceDetailsResponse {
  ServiceDetailsResponseModel({
    super.provider,
    super.service,
  });

  factory ServiceDetailsResponseModel.fromMap(Map<String, dynamic> json) =>
      ServiceDetailsResponseModel(
        provider: json["provider"] != null
            ? ProviderModel.fromMap(json["provider"])
            : null,
        service: json["service"] != null
            ? ServiceModel.fromMap(json["service"])
            : null,
      );
}

class ProviderModel extends Provider {
  ProviderModel({
    super.id,
    super.name,
    super.description,
    super.mainImageUrl,
    super.logoUrl,
    super.rating,
    super.ratingsCount,
    super.mainBranchAddress,
    super.mainBranchContact,
    super.email,
    super.website,
    super.mainBranchLocation,
    super.wrokDays,
    super.socialMediaAccounts,
    super.branches,
    super.projects,
  });

  factory ProviderModel.fromMap(Map<String, dynamic> json) => ProviderModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        mainImageUrl: json["mainImageUrl"],
        logoUrl: json["logoUrl"],
        rating: json["rating"] != null ? json["rating"].toDouble() : null,
        ratingsCount: json["ratingsCount"] != null
            ? json["ratingsCount"].toDouble()
            : null,
        mainBranchAddress: json["mainBranchAddress"],
        mainBranchContact: json["mainBranchContact"],
        email: json["email"],
        website: json["website"],
        mainBranchLocation: json["mainBranchLocation"] != null
            ? LocationModel.fromMap(json["mainBranchLocation"])
            : null,
        wrokDays: json["wrokDays"] != null
            ? List<WrokDayModel>.from(
                json["wrokDays"].map((x) => WrokDayModel.fromMap(x)))
            : null,
        socialMediaAccounts: json["socialMediaAccounts"] != null
            ? List<SocialMediaAccountModel>.from(json["socialMediaAccounts"]
                .map((x) => SocialMediaAccountModel.fromMap(x)))
            : null,
        branches: json["branches"] != null
            ? List<BranchModel>.from(
                json["branches"].map((x) => BranchModel.fromMap(x)))
            : null,
        projects: json["projects"] != null
            ? List<ProjectModel>.from(
                json["projects"].map((x) => ProjectModel.fromMap(x)))
            : null,
      );
}

class BranchModel extends Branch {
  BranchModel({
    super.cityId,
    super.address,
    super.location,
    super.contact,
    super.email,
    super.name,
  });

  factory BranchModel.fromMap(Map<String, dynamic> json) => BranchModel(
        cityId: json["cityId"],
        address: json["address"],
        location: json["location"] != null
            ? LocationModel.fromMap(json["location"])
            : null,
        contact: json["contact"],
        email: json["email"],
        name: json["name"],
      );
}

class LocationModel extends Location {
  LocationModel({
    super.latitude,
    super.longitude,
  });

  factory LocationModel.fromMap(Map<String, dynamic> json) => LocationModel(
        latitude: json["latitude"],
        longitude: json["longitude"],
      );
}

class ProjectModel extends Project {
  ProjectModel({
    super.name,
    super.description,
    super.documentUrl,
    super.images,
  });

  factory ProjectModel.fromMap(Map<String, dynamic> json) => ProjectModel(
        name: json["name"],
        description: json["description"],
        documentUrl: json["documentUrl"],
        images: json["images"] != null
            ? List<String>.from(json["images"].map((x) => x))
            : null,
      );
}

class SocialMediaAccountModel extends SocialMediaAccount {
  SocialMediaAccountModel({super.type, super.account, super.socialInfo});

  factory SocialMediaAccountModel.fromMap(Map<String, dynamic> json) {
    SocialMediaAccountModel account = SocialMediaAccountModel(
      type: json["type"],
      account: json["account"],
    );
    account.socialInfo = getSocialMediaType(account.type ?? "");
    return account;
  }

  static SocialMediaTypes getSocialMediaType(String type) {
    switch (type.toLowerCase()) {
      case Constants.whatsapp:
        return SocialMediaTypes.whatsapp;
      case Constants.snapchat:
        return SocialMediaTypes.snapchat;
      case Constants.facebook:
        return SocialMediaTypes.facebook;
      case Constants.twitter:
        return SocialMediaTypes.twitter;
      case Constants.instagram:
        return SocialMediaTypes.instagram;
      default:
        return SocialMediaTypes.none;
    }
  }
}

class WrokDayModel extends WorkDay {
  WrokDayModel({
    super.day,
    super.fullTime,
    super.closed,
    super.firstShift,
    super.secondShift,
  });

  factory WrokDayModel.fromMap(Map<String, dynamic> json) => WrokDayModel(
        day: json["day"],
        fullTime: json["fullTime"],
        closed: json["closed"],
        firstShift: json["firstShift"] != null
            ? ShiftModel.fromMap(json["firstShift"])
            : null,
        secondShift: json["secondShift"] != null
            ? ShiftModel.fromMap(json["secondShift"])
            : null,
      );
}

class ShiftModel extends Shift {
  ShiftModel({
    super.from,
    super.to,
  });

  factory ShiftModel.fromMap(Map<String, dynamic> json) => ShiftModel(
        from: json["from"],
        to: json["to"],
      );
}

class ServiceModel extends Service {
  ServiceModel({
    super.id,
    super.name,
    super.description,
    super.rating,
    super.ratingsCount,
    super.logoUrl,
    super.faqs,
  });
  factory ServiceModel.fromMap(Map<String, dynamic> json) => ServiceModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        rating: json["rating"] != null ? json["rating"].toDouble() : null,
        ratingsCount: json["ratingsCount"] != null
            ? json["ratingsCount"].toDouble()
            : null,
        logoUrl: json["logoUrl"],
        faqs: json["faqs"] != null
            ? List<FaqModel>.from(json["faqs"].map((x) => FaqModel.fromMap(x)))
            : null,
      );
}
