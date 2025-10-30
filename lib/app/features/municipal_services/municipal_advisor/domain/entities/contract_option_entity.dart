import 'package:equatable/equatable.dart';

class ContractOptionEntity extends Equatable {
  final String id;
  final String name;

  const ContractOptionEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object> get props => [
        id,
        name,
      ];
}
