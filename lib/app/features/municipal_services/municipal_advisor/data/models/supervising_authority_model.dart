import '../../municipal_advisor_exports.dart' show SupervisingAuthorityEntity;

class SupervisingAuthorityModel extends SupervisingAuthorityEntity {
  const SupervisingAuthorityModel({
    required super.agencyId,
    required super.agencyName,
    required super.approvalTypeId,
    required super.approvalTypeName,
  });

  factory SupervisingAuthorityModel.fromMap(Map<String, dynamic> map) {
    return SupervisingAuthorityModel(
      agencyId: map['agencyId'] as int,
      agencyName: map['agencyName'] as String,
      approvalTypeId: map['approvalTypeId'].toString(),
      approvalTypeName: map['approvalTypeName'] as String,
    );
  }
}
