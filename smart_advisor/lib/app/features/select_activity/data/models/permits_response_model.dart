import '../../domain/entities/permits_activites_response.dart';

class PermitItemModel extends PermitItem {
  PermitItemModel({
    super.permitTypeId,
    super.name,
    super.maxCount,
    super.calculatorServiceId,
    super.detailedActivityId,
    super.detailedActivityName,
    super.municipalityId,
    super.municipalityName,
    super.isFreeOfCharge,
  });

  factory PermitItemModel.fromJson(Map<String, dynamic> json) =>
      PermitItemModel(
        permitTypeId: json["permitTypeId"],
        name: json["name"],
        maxCount: json["maxCount"],
        calculatorServiceId: json["calculatorServiceId"],
        detailedActivityId: json["detailedActivityId"],
        detailedActivityName: json["detailedActivityName"],
        municipalityId: json["municipalityId"],
        municipalityName: json["municipalityName"],
        isFreeOfCharge: json["isFreeOfCharge"],
      );

  Map<String, dynamic> toJson() => {
        "permitTypeId": permitTypeId,
        "name": name,
        "maxCount": maxCount,
        "calculatorServiceId": calculatorServiceId,
        "detailedActivityId": detailedActivityId,
        "detailedActivityName": detailedActivityName,
        "municipalityId": municipalityId,
        "municipalityName": municipalityName,
        "isFreeOfCharge": isFreeOfCharge,
      };
}
