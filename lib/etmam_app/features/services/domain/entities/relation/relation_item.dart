import 'package:balady_plus/etmam_app/features/services/services_exports.dart';

class RelationItem {
  RelationItem(
      {this.id,
      this.name,
      this.orderTypeId,
      this.serviceId,
      this.serviceName,
      this.serviceLogoUrl,
      this.mandatory,
      this.isChecked,
      this.selectedServiceProvider});

  String? id;
  String? name;
  String? orderTypeId;
  String? serviceId;
  String? serviceName;
  String? serviceLogoUrl;
  bool? mandatory;
  bool? isChecked;
  //bool? isServiceProviderSelected;
  //String? serviceProviderId;
  ServiceItems? selectedServiceProvider;

  ServiceResponse? reletedServicesProviders;

  bool isCheckedORManadatory() {
    return (isChecked ?? false) || (mandatory ?? false);
  }
}
