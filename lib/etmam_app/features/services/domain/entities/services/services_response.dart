import 'package:balady_plus/etmam_app/features/services/services_exports.dart'
    show ServiceItems;

class ServiceResponse {
  ServiceResponse(
      {this.totalPageCount, this.totalItemCount, this.items, this.serviceId});

  int? totalPageCount;
  int? totalItemCount;
  List<ServiceItems>? items;
  String? serviceId;
  String? serviceName;
}
