import 'package:equatable/equatable.dart';

class InvoiceStatusEntity extends Equatable {
  final int id;
  final String name;

  const InvoiceStatusEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
