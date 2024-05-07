class PermitsResponseEntity {
  List<PermitEntity>? permits;
  String? term;

  PermitsResponseEntity({
    this.permits,
    this.term,
  });
}

class PermitEntity {
  bool? accepted;
  String? expirationDate;
  int? id;
  int? permitNumber;
  int? requestId;
  String? permitName;
  bool? selected;

  PermitEntity({
    this.accepted,
    this.expirationDate,
    this.id,
    this.permitNumber,
    this.requestId,
    this.permitName,
    this.selected,
  });
}
