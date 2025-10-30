import '../../violations_exports.dart' show InvoiceStatusesEntity;

class InvoiceStatusesModel extends InvoiceStatusesEntity {
  const InvoiceStatusesModel({
    required super.id,
    required super.name,
  });

  factory InvoiceStatusesModel.fromMap(Map<String, dynamic> map) {
    return InvoiceStatusesModel(
      id: map['id'] as int,
      name: map['name'] as String,
    );
  }
}
