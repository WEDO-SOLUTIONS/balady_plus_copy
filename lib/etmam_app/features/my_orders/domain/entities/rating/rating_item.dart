import 'package:equatable/equatable.dart';

class RatingItem extends Equatable {
  String? id;
  String? name;
  bool? active;
  int? value;

  RatingItem({this.active, this.id, this.name, this.value});

  @override
  List<Object?> get props => [id];
}
