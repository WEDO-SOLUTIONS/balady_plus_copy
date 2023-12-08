import 'package:equatable/equatable.dart';

class AdsItem extends Equatable {
  AdsItem({
    this.mainDescription,
    this.subDescription,
    /*  this.imageLink,
    this.order,
    this.startShowDate,
    this.endShowDate,
    this.show,
    this.serviceId,*/
  });

  String? mainDescription;
  String? subDescription;
  /*String? imageLink;
  int? order;
  String? startShowDate;
  String? endShowDate;
  bool? show;
  String? serviceId;*/

  @override
  List<Object?> get props => [];
}
