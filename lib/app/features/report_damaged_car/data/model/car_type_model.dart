import '../../domain/entities/car_type.dart';

class CarTypeModel extends CarType {
  CarTypeModel({super.brandName, super.originName, super.modelName});

  factory CarTypeModel.fromJson(Map<String, dynamic> json) {
    return CarTypeModel(
      brandName: json['BrandName'] as String,
      originName: json['OriginName'] as String,
      modelName: json['ModelName'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'BrandName': brandName,
        'OriginName': originName,
        'ModelName': modelName,
      };
}
