import 'package:balady_plus/etmam_app/features/services/domain/entities/services/services_response.dart';

class ProviderRelationPageParams {
  String? selectedProviderId;
  ServiceResponse serviceProviders;

  ProviderRelationPageParams(
      {this.selectedProviderId, required this.serviceProviders});
}
