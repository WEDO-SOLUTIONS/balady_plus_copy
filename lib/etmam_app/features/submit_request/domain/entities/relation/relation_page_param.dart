import 'package:balady_plus/etmam_app/core/utils/enums/page_type.dart';
import 'package:balady_plus/etmam_app/features/services/services_exports.dart'
    show RelationResponse;

class RelationPageParam {
  RelationResponse? relationResponse;
  String? serviceProviderId;
  String? serviceProviderName;
  String? subServiceId;
  String? subServiceName;
  bool? changeProvider;
  String? orderId;
  Function? callBack;
  PageTypes? pageType;
  bool? inputsRequired;
  RelationPageParam(
      {this.relationResponse,
      this.serviceProviderId,
      this.serviceProviderName,
      this.subServiceId,
      this.subServiceName,
      this.changeProvider,
      this.orderId,
      this.callBack,
      this.pageType,
      this.inputsRequired});
}
