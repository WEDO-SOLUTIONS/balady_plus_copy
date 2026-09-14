import 'package:equatable/equatable.dart';

class DaemItem extends Equatable {
  final String? id;

  final String? name;

  const DaemItem({this.id, this.name});

  @override
  List<Object?> get props => [id];
}
