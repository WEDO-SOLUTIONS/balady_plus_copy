import 'package:equatable/equatable.dart';

class IsicSubActivityParamsModel extends Equatable {
  final int id;

  const IsicSubActivityParamsModel({required this.id});

  Map<String, dynamic> toMap() => {'isicNumber': id};

  @override
  List<Object?> get props => [id];
}
