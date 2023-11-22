import 'package:balady_plus/etmam_app/features/my_orders/my_orders_exports.dart';
import 'package:equatable/equatable.dart';
import 'package:collection/collection.dart';

class OfferItem extends Equatable {
  OfferItem(
      {this.id,
      this.number,
      this.providerId,
      this.value,
      this.notes,
      this.status,
      this.allowedActions,
      this.providerName,
      this.providerLogo,
      this.rating,
      this.technicalAttachmentId,
      this.financialAttachmentId});

  final String? id;
  final String? number;
  final String? providerId;
  final int? value;
  final String? notes;
  final Status? status;
  final List<Action>? allowedActions;
  final String? providerName;
  final String? providerLogo;
  final double? rating;
  final String? financialAttachmentId;
  final String? technicalAttachmentId;

  Action? get getAccept =>
      allowedActions?.firstWhereOrNull((element) => element.id == "accept");
  Action? get getReject =>
      allowedActions?.firstWhereOrNull((element) => element.id == "reject");

  @override
  List<Object?> get props => [];
}

class Status {
  Status({
    this.id,
    this.name,
    this.closed,
  });

  final String? id;
  final String? name;
  final bool? closed;
}
