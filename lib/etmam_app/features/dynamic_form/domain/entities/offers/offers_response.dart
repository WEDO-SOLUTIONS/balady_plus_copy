import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/offers/offers_item.dart';
import 'package:equatable/equatable.dart';

class OffersResponse extends Equatable {
  OffersResponse({
    this.totalPageCount,
    this.totalItemCount,
    this.items,
  });

  final int? totalPageCount;
  final int? totalItemCount;
  final List<OfferItem>? items;

  @override
  List<Object?> get props => [];
}
