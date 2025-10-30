import '../../objections_exports.dart' show CreateObjectionResponse;

class CreateObjectionResponseModel extends CreateObjectionResponse {
  CreateObjectionResponseModel({super.objectionRequestNumber});

  factory CreateObjectionResponseModel.fromJson(Map<String, dynamic> json) =>
      CreateObjectionResponseModel(
        objectionRequestNumber: json["ObjectionRequestNumber"],
      );
}
