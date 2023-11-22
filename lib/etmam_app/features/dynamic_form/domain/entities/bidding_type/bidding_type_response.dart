import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/bidding_type/bidding_service_item.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/bidding_type/bidding_type_item.dart';
import 'package:balady_plus/etmam_app/features/services/services_exports.dart'
    show RelationItem;
import 'package:equatable/equatable.dart';

class BiddingTypeResponse extends Equatable {
  BiddingTypeResponse(
      {this.id,
      this.name,
      this.orderTypeId,
      this.inputsRequired,
      this.service,
      this.subRelations});

  String? id;
  String? name;
  String? orderTypeId;
  bool? inputsRequired;
  BiddingServiceItem? service;
  List<BiddingTypeItem>? subRelations;

  @override
  List<Object?> get props => [id, name];
}
