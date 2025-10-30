import '../../invoices_exports.dart' show InvoiceStatusEntity;

class InvoiceStatusModel extends InvoiceStatusEntity {
  const InvoiceStatusModel({
    required super.id,
    required super.name,
  });

  factory InvoiceStatusModel.fromMap(Map<String, dynamic> map) {
    return InvoiceStatusModel(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }
}
