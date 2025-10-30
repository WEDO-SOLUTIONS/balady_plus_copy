class SaveSelectedRequestsPermitsRequest {
  SaveSelectedRequestsPermitsRequest({
    this.selectedPermits,
  });

  SaveSelectedRequestsPermitsRequest.fromJson(dynamic json) {
    selectedPermits = json['selectedPermits'] != null
        ? json['selectedPermits'].cast<int>()
        : [];
  }
  List<int>? selectedPermits;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['selectedPermits'] = selectedPermits;
    return map;
  }
}
