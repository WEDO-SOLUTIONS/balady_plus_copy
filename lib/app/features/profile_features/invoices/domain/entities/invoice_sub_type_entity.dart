import 'package:equatable/equatable.dart';

class InvoiceSubTypeEntity extends Equatable {
  final int id;
  final String name;

  const InvoiceSubTypeEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
