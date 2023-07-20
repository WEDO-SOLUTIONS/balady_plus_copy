import 'package:equatable/equatable.dart';

class TestEntity extends Equatable {
  final int? id;
  final String? name;

  const TestEntity({this.id, this.name});

  @override
  List<Object?> get props => [id, name];
}
