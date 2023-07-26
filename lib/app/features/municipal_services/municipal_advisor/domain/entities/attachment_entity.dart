import 'package:equatable/equatable.dart';

class AttachmentEntity extends Equatable {
  final int id;
  final String name;
  final bool mandatory;

  const AttachmentEntity({
    required this.id,
    required this.name,
    required this.mandatory,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        mandatory,
      ];
}
