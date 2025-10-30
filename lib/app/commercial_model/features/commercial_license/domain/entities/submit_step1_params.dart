class SubmitStep1Params {
  final String? crNumber;
  final int? entityType;
  final int? crType;
  final String? identityIdForEtmam;
  final String? consultationId;

  SubmitStep1Params({
    this.crNumber,
    this.entityType,
    this.crType,
    this.identityIdForEtmam,
    this.consultationId,
  });

  Map<String, dynamic> toJson() => {
        "crNumber": crNumber,
        "entityType": entityType,
        "crType": crType,
        "identityIdForEtmam": identityIdForEtmam,
        "consultationId": consultationId,
      };
}
