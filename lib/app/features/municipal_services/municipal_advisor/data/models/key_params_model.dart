import 'package:equatable/equatable.dart';

class KeyParamsModel extends Equatable {
  final String key;

  const KeyParamsModel({
    required this.key,
  });

  @override
  List<Object?> get props => [key];
}
