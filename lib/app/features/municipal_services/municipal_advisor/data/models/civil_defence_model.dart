import 'package:equatable/equatable.dart';

import '../../domain/entities/civil_defence_entity.dart';

class CivilDefenceModel extends CivilDefenceEntity {
  const CivilDefenceModel({
    required super.id,
    required super.name,
  });

  factory CivilDefenceModel.fromMap(Map<String, dynamic> map) {
    return CivilDefenceModel(
      id: map['id'] as String,
      name: map['name'] as String,
    );
  }

  @override
  List<Object?> get props => [id, name];
}
