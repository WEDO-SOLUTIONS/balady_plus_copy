import 'package:balady_plus/etmam_app/core/utils/enums/page_type.dart';

class SubmitParams {
  String? cityId;
  String? providerId;
  String? relationId;

  List<subOrder>? subOrders;
  bool? changeProvider;
  PageTypes? pageType;
  String? orderId;

  SubmitParams(
      {this.cityId,
      this.providerId,
      this.subOrders,
      this.relationId,
      this.changeProvider,
      this.orderId,
      this.pageType});
}

class subOrder {
  String? providerId;
  String? subRelationId;

  subOrder({this.providerId, this.subRelationId});
}
