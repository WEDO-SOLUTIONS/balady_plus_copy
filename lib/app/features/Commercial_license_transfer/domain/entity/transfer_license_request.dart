class TransferLicenseRequest {
  TransferLicenseRequest({
    this.crNumber,
    this.selectedPermits,
  });

  TransferLicenseRequest.fromJson(dynamic json) {
    crNumber = json['crNumber'];
    selectedPermits = json['selectedPermits'] != null
        ? json['selectedPermits'].cast<int>()
        : [];
  }
  String? crNumber;
  List<int>? selectedPermits;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['crNumber'] = crNumber;
    map['selectedPermits'] = selectedPermits;
    return map;
  }
}
