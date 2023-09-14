import 'package:balady_plus/etmam_app/core/utils/constants/app_config.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/bidding_type/bidding_service_item.dart';
import 'package:balady_plus/etmam_app/features/services/services_exports.dart';

class BiddingTypeItem {
  BiddingTypeItem({
    this.id,
    this.name,
    this.orderTypeId,
    this.inputsRequired,
    this.service,
    this.mandatory,
    this.isSelected,
  });

  String? id;
  String? name;
  String? orderTypeId;
  bool? inputsRequired;
  BiddingServiceItem? service;
  bool? mandatory;
  bool? isSelected;

  String? get nameWithOptional =>
      mandatory == true ? "$name ${trans("manadatory")}" : name;
}
