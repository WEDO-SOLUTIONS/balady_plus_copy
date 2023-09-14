class CreateFormParams {
  String? profileId;
  String? requestTypeId;
  List<String>? services;

  CreateFormParams({this.profileId, this.requestTypeId, this.services});

  Map<String, dynamic> toMap() => {
        "profileId": profileId,
        "requestTypeId": requestTypeId,
        "services": services?.toList()
      };
}
