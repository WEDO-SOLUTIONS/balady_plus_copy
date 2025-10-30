import 'package:equatable/equatable.dart';

class InvoiceSubTypeParamsModel extends Equatable {
  final int id;

  const InvoiceSubTypeParamsModel({
    required this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
    };
  }

  @override
  List<Object?> get props => [id];
}
