/*class AddetionalActivitesResponse {
  List<AddetionalActivityItem> result;

  AddetionalActivitesResponse({
    required this.result,
  });

  AddetionalActivitesResponse copyWith({
    List<AddetionalActivityItem>? result,
  }) =>
      AddetionalActivitesResponse(
        result: result ?? this.result,
      );
}*/

class PermitItem {
  int? permitTypeId;
  String? name;
  int? maxCount;
  int? calculatorServiceId;
  int? detailedActivityId;
  String? detailedActivityName;
  int? municipalityId;
  String? municipalityName;
  bool? isFreeOfCharge;
  bool? isSelected;
  int? order;
  double? length;
  double? width;
  int? days;
  int? nonFoodVehicleCount;

  PermitItem(
      {this.permitTypeId,
      this.name,
      this.maxCount,
      this.calculatorServiceId,
      this.detailedActivityId,
      this.detailedActivityName,
      this.municipalityId,
      this.municipalityName,
      this.isFreeOfCharge,
      this.isSelected,
      this.order,
      this.length,
      this.width,
      this.days,
      this.nonFoodVehicleCount});

  PermitItem copyWith({
    int? permitTypeId,
    String? name,
    int? maxCount,
    int? calculatorServiceId,
    int? detailedActivityId,
    String? detailedActivityName,
    int? municipalityId,
    String? municipalityName,
    bool? isFreeOfCharge,
    bool? isSelected,
    int? order,
    double? length,
    double? width,
    int? days,
    int? nonFoodVehicleCount,
  }) =>
      PermitItem(
          length: length ?? this.length,
          width: width ?? this.width,
          days: days ?? this.days,
          nonFoodVehicleCount: nonFoodVehicleCount ?? this.nonFoodVehicleCount,
          permitTypeId: permitTypeId ?? this.permitTypeId,
          name: name ?? this.name,
          maxCount: maxCount ?? this.maxCount,
          calculatorServiceId: calculatorServiceId ?? this.calculatorServiceId,
          detailedActivityId: detailedActivityId ?? this.detailedActivityId,
          detailedActivityName:
              detailedActivityName ?? this.detailedActivityName,
          municipalityId: municipalityId ?? this.municipalityId,
          municipalityName: municipalityName ?? this.municipalityName,
          isFreeOfCharge: isFreeOfCharge ?? this.isFreeOfCharge,
          isSelected: isSelected ?? this.isSelected,
          order: order ?? this.order);

  factory PermitItem.fromJson(Map<String, dynamic> json) => PermitItem(
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
