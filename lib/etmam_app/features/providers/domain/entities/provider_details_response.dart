import 'package:balady_plus/etmam_app/features/services/services_exports.dart'
    show Branch, Location, Project, SocialMediaAccount, WorkDay;

class ProviderDetailsResponse {
  ProviderDetailsResponse(
      {this.id,
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
      this.supportedServices});

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
  List<SupportedService>? supportedServices;
}

class SupportedService {
  SupportedService(
      {this.serviceId,
      this.rating,
      this.ratingsCount,
      this.logoImageUrl,
      this.serviceName});

  String? serviceId;
  double? rating;
  double? ratingsCount;
  String? serviceName;
  String? logoImageUrl;
}
