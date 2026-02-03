import 'package:equatable/equatable.dart';

class DashboardProductEntity extends Equatable {
  final int id;
  final String name;

  const DashboardProductEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
