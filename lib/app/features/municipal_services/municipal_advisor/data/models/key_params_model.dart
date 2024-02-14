import 'package:equatable/equatable.dart';

class KeyParamsModel extends Equatable {
  final String key;

  final List<(int, double?)>? civilDefenseActivityRequestDtoList;

  const KeyParamsModel(
      {required this.key, this.civilDefenseActivityRequestDtoList});

  @override
  List<Object?> get props => [key, civilDefenseActivityRequestDtoList];
}
