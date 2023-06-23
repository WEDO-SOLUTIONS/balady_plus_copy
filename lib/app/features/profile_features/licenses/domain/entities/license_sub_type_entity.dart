import 'package:equatable/equatable.dart';

class LicenseSubTypeEntity extends Equatable {
  final int id;
  final String name;

  const LicenseSubTypeEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
