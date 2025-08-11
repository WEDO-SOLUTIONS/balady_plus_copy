class SaveActivityAndLocationResponseModel {
  SaveActivityAndLocationResponseModel({
      this.requestId, 
      this.succeeded, 
      this.workFlow,});

  SaveActivityAndLocationResponseModel.fromJson(dynamic json) {
    requestId = json['requestId'];
    succeeded = json['succeeded'];
    workFlow = json['workFlow'] != null ? WorkFlow.fromJson(json['workFlow']) : null;
  }
  int? requestId;
  bool? succeeded;
  WorkFlow? workFlow;
SaveActivityAndLocationResponseModel copyWith({  int? requestId,
  bool? succeeded,
  WorkFlow? workFlow,
}) => SaveActivityAndLocationResponseModel(  requestId: requestId ?? this.requestId,
  succeeded: succeeded ?? this.succeeded,
  workFlow: workFlow ?? this.workFlow,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['requestId'] = requestId;
    map['succeeded'] = succeeded;
    if (workFlow != null) {
      map['workFlow'] = workFlow?.toJson();
    }
    return map;
  }

}

class WorkFlow {
  WorkFlow({
      this.id, 
      this.name,});

  WorkFlow.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }
  String? id;
  String? name;
WorkFlow copyWith({  String? id,
  String? name,
}) => WorkFlow(  id: id ?? this.id,
  name: name ?? this.name,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }

}