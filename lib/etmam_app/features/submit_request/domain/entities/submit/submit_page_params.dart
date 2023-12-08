import 'package:balady_plus/etmam_app/core/utils/enums/page_type.dart';
import 'package:balady_plus/etmam_app/features/services/services_exports.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubmitPageParams {
  List<RelationItem>? subRelations;
  String? relationId;

  String? serviceProviderName;
  String? subServiceName;
  String? serviceProviderId;
  String? subServiceId;
  bool? changeProvider;
  String? orderId;
  Function? callBack;
  PageTypes? pageType;
  Bloc? releationBloc;
  bool? inputsRequired;
  SubmitPageParams(
      {this.serviceProviderId,
      this.relationId,
      this.serviceProviderName,
      this.subRelations,
      this.subServiceId,
      this.subServiceName,
      this.changeProvider = false,
      this.orderId,
      this.callBack,
      this.pageType,
      this.releationBloc,
      this.inputsRequired});
}
