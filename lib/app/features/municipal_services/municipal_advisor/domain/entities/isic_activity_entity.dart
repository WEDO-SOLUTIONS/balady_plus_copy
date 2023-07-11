import 'package:equatable/equatable.dart';

class IsicActivityEntity extends Equatable {
  final int id;
  final String name;

  const IsicActivityEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [
        id,
        name,
      ];
}
