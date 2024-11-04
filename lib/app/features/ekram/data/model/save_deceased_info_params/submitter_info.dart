class SubmitterInfo {
  bool? hasIdentity;
  bool? baladyClient;
  bool? ekramDepartment;
  String? relationship;

  SubmitterInfo({
    this.hasIdentity,
    this.baladyClient,
    this.ekramDepartment,
    this.relationship,
  });

  factory SubmitterInfo.fromJson(Map<String, dynamic> json) => SubmitterInfo(
        hasIdentity: json['hasIdentity'] as bool?,
        baladyClient: json['baladyClient'] as bool?,
        ekramDepartment: json['ekramDepartment'] as bool?,
        relationship: json['relationship'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'hasIdentity': hasIdentity,
        'baladyClient': baladyClient,
        'ekramDepartment': ekramDepartment,
        'relationship': relationship,
      };

  SubmitterInfo copyWith({
    bool? hasIdentity,
    bool? baladyClient,
    bool? ekramDepartment,
    String? relationship,
  }) {
    return SubmitterInfo(
      hasIdentity: hasIdentity ?? this.hasIdentity,
      baladyClient: baladyClient ?? this.baladyClient,
      ekramDepartment: ekramDepartment ?? this.ekramDepartment,
      relationship: relationship ?? this.relationship,
    );
  }
}
