// ignore_for_file: public_member_api_docs, sort_constructors_first
class ViolationDetailsParams {
  String id;
  String applicationId;
  String? identityNumber;

  ViolationDetailsParams({
    required this.id,
    required this.applicationId,
    this.identityNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      "violationNumber": id,
      "applicationId": applicationId,
      if (identityNumber != null) "identityNumber": identityNumber
    };
  }
}
