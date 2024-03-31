import 'package:equatable/equatable.dart';

class InvoiceStatusesEntity extends Equatable {
  final int id;
  final String name;

  const InvoiceStatusesEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
