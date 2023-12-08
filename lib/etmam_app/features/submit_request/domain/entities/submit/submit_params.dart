import 'package:balady_plus/etmam_app/core/utils/enums/page_type.dart';

class SubmitParams {
  String? cityId;
  String? providerId;
  String? relationId;

  List<subOrder>? subOrders;
  bool? changeProvider;
  PageTypes? pageType;
  String? orderId;

  String? formId;
  Map<String, dynamic>? fields;

  SubmitParams(
      {this.cityId,
      this.providerId,
      this.subOrders,
      this.relationId,
      this.changeProvider,
      this.orderId,
      this.pageType,
      this.formId,
      this.fields});
}

class subOrder {
  String? providerId;
  String? subRelationId;

  subOrder({this.providerId, this.subRelationId});
}
