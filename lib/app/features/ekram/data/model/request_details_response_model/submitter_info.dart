class SubmitterInfo {
  String? fullName;
  String? mobileNumber;
  bool? hasIdentity;
  bool? baladyClient;
  bool? ekramDepartment;
  String? relationship;

  SubmitterInfo({
    this.fullName,
    this.mobileNumber,
    this.hasIdentity,
    this.baladyClient,
    this.ekramDepartment,
    this.relationship,
  });

  factory SubmitterInfo.fromJson(Map<String, dynamic> json) => SubmitterInfo(
        fullName: json['fullName'] as String?,
        mobileNumber: json['mobileNumber'] as String?,
        hasIdentity: json['hasIdentity'] as bool?,
        baladyClient: json['baladyClient'] as bool?,
        ekramDepartment: json['ekramDepartment'] as bool?,
        relationship: json['relationship'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'mobileNumber': mobileNumber,
        'hasIdentity': hasIdentity,
        'baladyClient': baladyClient,
        'ekramDepartment': ekramDepartment,
        'relationship': relationship,
      };
}
