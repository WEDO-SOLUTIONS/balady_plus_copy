import 'package:equatable/equatable.dart';
import 'package:balady_plus/etmam_app/features/home/domain/entities/ads/ads_item.dart';

class AdsResponse extends Equatable {
  AdsResponse({
    this.totalPageCount,
    this.totalItemCount,
    this.items,
  });

  int? totalPageCount;
  int? totalItemCount;
  List<AdsItem>? items;

  @override
  List<Object?> get props => [];
}
