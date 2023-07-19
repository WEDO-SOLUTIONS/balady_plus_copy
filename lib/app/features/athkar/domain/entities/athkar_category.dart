// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'athkar_entity.dart';

class AthkarCategory extends Equatable {
  final String name;
  final String icon;
  final List<AthkarEntity> athkarEntities; //   <----- Here
  const AthkarCategory({
    required this.name,
    required this.icon,
    required this.athkarEntities,
  });

  @override
  List<Object?> get props => [name, icon, athkarEntities];
}
