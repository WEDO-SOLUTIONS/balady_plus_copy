import 'package:equatable/equatable.dart';

class BoardsParamsModel extends Equatable {
  final int? typeId;
  final num? area;

  const BoardsParamsModel({
    this.typeId,
    this.area,
  });

  Map<String, dynamic> toMap() {
    return {
      'typeId': typeId,
      'area': area,
    };
  }

  @override
  List<Object?> get props => [
        typeId,
        area,
      ];
}
