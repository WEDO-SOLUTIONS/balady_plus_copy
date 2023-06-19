import 'package:equatable/equatable.dart';

class LicenseStatusEntity extends Equatable {
  final int id;
  final String name;

  const LicenseStatusEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
