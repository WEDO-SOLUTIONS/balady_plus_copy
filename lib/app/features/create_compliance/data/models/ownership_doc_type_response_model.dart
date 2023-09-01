import '../../domain/entities/ownership_doc_type_response.dart';

class ComplinaceLookUpResponseModel extends ComplinaceLookUpResponse {
  const ComplinaceLookUpResponseModel({super.items});

  factory ComplinaceLookUpResponseModel.fromJson(dynamic json) =>
      ComplinaceLookUpResponseModel(
        items: json == null
            ? []
            : List<ComplinaceLookUpItem>.from(
                json!.map((x) => ComplinaceLookUpItemModel.fromJson(x))),
      );
}

class ComplinaceLookUpItemModel extends ComplinaceLookUpItem {
  const ComplinaceLookUpItemModel({
    super.id,
    super.name,
  });

  factory ComplinaceLookUpItemModel.fromJson(Map<String, dynamic> json) =>
      ComplinaceLookUpItemModel(
        id: json["id"],
        name: json["name"],
      );
}
