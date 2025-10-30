import 'package:equatable/equatable.dart';

import '../../../../core/utils/utils_exports.dart' show ServiceAction;

class ServiceActionEntity extends Equatable {
  final ServiceAction type;
  final String value;

  const ServiceActionEntity({
    required this.type,
    required this.value,
  });

  @override
  List<Object?> get props => [
        type,
        value,
      ];
}
