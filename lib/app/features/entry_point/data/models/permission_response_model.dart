import '../../domain/entities/permission_response.dart';

class PermissionResponseModel extends PermissionResponse {
  const PermissionResponseModel({super.permissions, super.roles});

  factory PermissionResponseModel.fromMap(Map<String, dynamic> json) => PermissionResponseModel(
    permissions: json["permissions"] != null ? List<String>.from(json["permissions"].map((x) => x)) : null,
    roles: json["roles"] != null ? List<String>.from(json["roles"].map((x) => x)) : null,
  );

  Map<String, dynamic> toJson() {
    return {"permissions": permissions, "roles": roles};
  }
}
