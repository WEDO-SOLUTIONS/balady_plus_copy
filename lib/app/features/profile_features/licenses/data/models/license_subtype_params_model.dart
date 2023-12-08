import 'package:equatable/equatable.dart';

class LicenseSubTypeParamsModel extends Equatable {
  final int id;

  const LicenseSubTypeParamsModel({
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
