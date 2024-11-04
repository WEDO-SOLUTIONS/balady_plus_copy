class BodyRecipientInfo {
  bool? hasIdentity;
  bool? baladyClient;
  bool? ekramDepartment;

  BodyRecipientInfo({
    this.hasIdentity,
    this.baladyClient,
    this.ekramDepartment,
  });

  factory BodyRecipientInfo.fromJson(Map<String, dynamic> json) {
    return BodyRecipientInfo(
      hasIdentity: json['hasIdentity'] as bool?,
      baladyClient: json['baladyClient'] as bool?,
      ekramDepartment: json['ekramDepartment'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
        'hasIdentity': hasIdentity,
        'baladyClient': baladyClient,
        'ekramDepartment': ekramDepartment,
      };
}
