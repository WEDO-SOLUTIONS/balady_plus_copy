import 'package:equatable/equatable.dart';

class SubMunicipalityParamsModel extends Equatable {
  final String id;

  const SubMunicipalityParamsModel({
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
