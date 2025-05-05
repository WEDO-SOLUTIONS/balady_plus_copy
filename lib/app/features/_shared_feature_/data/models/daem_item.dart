import 'package:equatable/equatable.dart';

class DaemItem extends Equatable {
  String? id;

  String? name;

  DaemItem({this.id, this.name});

  @override
  List<Object?> get props => [id];
}
