class BodyRecipientInfo {
  BodyRecipientInfo({
    this.hasIdentity,
    this.baladyClient,
    this.ekramDepartment,});

  BodyRecipientInfo.fromJson(dynamic json) {
    hasIdentity = json['hasIdentity'];
    baladyClient = json['baladyClient'];
    ekramDepartment = json['ekramDepartment'];
  }
  bool? hasIdentity;
  bool? baladyClient;
  bool? ekramDepartment;
  BodyRecipientInfo copyWith({  bool? hasIdentity,
    bool? baladyClient,
    bool? ekramDepartment,
  }) => BodyRecipientInfo(  hasIdentity: hasIdentity ?? this.hasIdentity,
    baladyClient: baladyClient ?? this.baladyClient,
    ekramDepartment: ekramDepartment ?? this.ekramDepartment,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['hasIdentity'] = hasIdentity;
    map['baladyClient'] = baladyClient;
    map['ekramDepartment'] = ekramDepartment;
    return map;
  }

}