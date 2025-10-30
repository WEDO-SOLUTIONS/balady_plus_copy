class SaveContractInfoRequest {
  int? requestId;
  String? designerEngOfficeId;

  SaveContractInfoRequest({this.designerEngOfficeId, this.requestId});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'designerEngOfficeId': designerEngOfficeId,
    };
  }
}
