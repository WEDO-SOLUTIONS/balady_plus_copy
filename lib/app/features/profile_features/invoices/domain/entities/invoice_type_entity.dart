import 'package:equatable/equatable.dart';

class InvoiceTypeEntity extends Equatable {
  final int id;
  final String name;

  const InvoiceTypeEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
