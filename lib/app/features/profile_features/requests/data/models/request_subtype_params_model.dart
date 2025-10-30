import 'package:equatable/equatable.dart';

class RequestSubTypeParamsModel extends Equatable {
  final int id;

  const RequestSubTypeParamsModel({
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
