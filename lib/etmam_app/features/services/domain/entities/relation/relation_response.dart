import 'package:balady_plus/etmam_app/features/services/services_exports.dart'
    show RelationItem;

class RelationResponse {
  RelationResponse({
    this.id,
    this.name,
    this.orderTypeId,
    this.serviceId,
    this.serviceName,
    this.subRelations,
    this.serviceLogoUrl,
  });

  String? id;
  String? name;
  String? orderTypeId;
  String? serviceId;
  String? serviceName;
  String? serviceLogoUrl;
  List<RelationItem>? subRelations;
}
