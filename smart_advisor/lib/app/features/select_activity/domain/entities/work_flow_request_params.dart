class WorkFlowRequestParams {
  int activityId;
  String municipalityId;
  double area;
  double x;
  double y;
  int requestTypeId;
  List<String> additionalActivities;
  String entityType;
  String contractOption;
  String contractType;
  String? atmFeesOption;

  // Constructor
  WorkFlowRequestParams({
    required this.activityId,
    required this.municipalityId,
    required this.area,
    required this.x,
    required this.y,
    required this.requestTypeId,
    required this.additionalActivities,
    required this.entityType,
    required this.contractOption,
    required this.contractType,
    this.atmFeesOption,
  });

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'activityId': activityId,
      'municipalityId': municipalityId,
      'area': area,
      'x': x,
      'y': y,
      'requestTypeId': requestTypeId,
      if (additionalActivities.isNotEmpty)
        'additionalActivities': additionalActivities.join(","),
      'entityType': entityType,
      'contractOption':
          contractOption == "Undefined" ? "ATTACH" : contractOption,
      'contractType': contractType == "Undefined" ? "EJAR" : contractType,
      if (atmFeesOption != null) 'atmFeesOption': atmFeesOption,
    };
  }
}
