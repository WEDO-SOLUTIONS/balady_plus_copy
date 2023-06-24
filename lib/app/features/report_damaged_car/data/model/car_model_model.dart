import '../../domain/entities/car_model.dart';

class CarModelModel extends CarModel {
  CarModelModel({super.id, super.carName});

  factory CarModelModel.fromJson(Map<String, dynamic> json) {
    return CarModelModel(
      id: json['ID'],
      carName: json['CarName'],
    );
  }

  Map<String, dynamic> toJson() => {
        'ID': id,
        'CarName': carName,
      };
}
