// ignore_for_file: public_member_api_docs, sort_constructors_first
class PermitLicenseRequestParams {
  String? crNumber;

  String? groupId;

  int? page;
  int? size;
  PermitLicenseRequestParams({
    this.crNumber,
    this.groupId,
    this.page,
    this.size,
  });

  Map<String, dynamic> toMap() {
    return {"page": page, "size": size};
  }

  PermitLicenseRequestParams copyWith({
    String? crNumber,
    String? groupId,
    int? page,
    int? size,
  }) {
    return PermitLicenseRequestParams(
      crNumber: crNumber ?? this.crNumber,
      groupId: groupId ?? this.groupId,
      page: page ?? this.page,
      size: size ?? this.size,
    );
  }
}
