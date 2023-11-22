import 'package:equatable/equatable.dart';

class BiddingServiceItem extends Equatable {
  final String? id;
  final String? name;
  final String? logoUrl;
  BiddingServiceItem({this.id, this.logoUrl, this.name});
  @override
  List<Object?> get props => [id, name];
}
