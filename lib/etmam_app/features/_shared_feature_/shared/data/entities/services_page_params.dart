import 'package:balady_plus/etmam_app/core/utils/enums/page_type.dart';
import 'package:balady_plus/etmam_app/features/services/services_exports.dart';

class ServicePageParams {
  String? orderId;
  bool? changeProvider;
  ServiceResponse? response;
  final Function? callBack;
  PageTypes? pageType;
  final bool? inputsRequired;

  ServicePageParams(
      {this.changeProvider,
      this.orderId,
      this.response,
      this.callBack,
      this.pageType,
      this.inputsRequired});
}
