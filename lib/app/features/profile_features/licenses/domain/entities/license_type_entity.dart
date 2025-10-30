import 'package:equatable/equatable.dart';

class LicenseTypeEntity extends Equatable {
  final int id;
  final String name;

  const LicenseTypeEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
