// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class AthkarEntity extends Equatable {
  final String name;
  final String content;
  final int quantity;
  final String description;
  final String quantityText;

  const AthkarEntity({
    required this.name,
    required this.content,
    required this.quantity,
    required this.description,
    required this.quantityText,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
        name,
        quantity,
        content,
        description,
        quantityText,
      ];
}
