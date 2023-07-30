import 'package:balady_plus/etmam_app/features/providers/domain/entities/provider_details_response.dart';
import 'package:balady_plus/etmam_app/features/services/data/models/service_details/service_details_response_model.dart';

class ProviderDetailsResponseModel extends ProviderDetailsResponse {
  ProviderDetailsResponseModel(
      {super.id,
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
      super.supportedServices});

  factory ProviderDetailsResponseModel.fromMap(Map<String, dynamic> json) =>
      ProviderDetailsResponseModel(
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
        supportedServices: json["supportedServices"] != null
            ? List<SupportedServiceModel>.from(json["supportedServices"]
                .map((x) => SupportedServiceModel.fromMap(x)))
            : null,
      );
}

class SupportedServiceModel extends SupportedService {
  SupportedServiceModel(
      {super.ratingsCount,
      super.rating,
      super.serviceId,
      super.logoImageUrl,
      super.serviceName});

  factory SupportedServiceModel.fromMap(Map<String, dynamic> json) =>
      SupportedServiceModel(
        serviceId: json["serviceId"],
        logoImageUrl: json["logoImageUrl"],
        serviceName: json["serviceName"],
        rating: json["rating"] != null ? json["rating"].toDouble() : null,
        ratingsCount: json["ratingsCount"] != null
            ? json["ratingsCount"].toDouble()
            : null,
      );
}
