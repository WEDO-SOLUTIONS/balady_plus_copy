import '../../invoices_exports.dart' show InvoiceTypeEntity;

class InvoiceTypeModel extends InvoiceTypeEntity {
  const InvoiceTypeModel({
    required super.id,
    required super.name,
  });

  factory InvoiceTypeModel.fromMap(Map<String, dynamic> map) {
    return InvoiceTypeModel(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }
}
