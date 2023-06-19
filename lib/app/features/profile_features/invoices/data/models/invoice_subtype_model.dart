import '../../invoices_exports.dart' show InvoiceSubTypeEntity;

class InvoiceSubTypeModel extends InvoiceSubTypeEntity {
  const InvoiceSubTypeModel({
    required super.id,
    required super.name,
  });

  factory InvoiceSubTypeModel.fromMap(Map<String, dynamic> map) {
    return InvoiceSubTypeModel(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }
}
