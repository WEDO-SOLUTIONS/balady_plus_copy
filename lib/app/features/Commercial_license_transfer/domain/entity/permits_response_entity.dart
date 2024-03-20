class PermitsResponseEntity {

  List<PermitEntity>? permits;
  String? term;


  PermitsResponseEntity({this.permits,this.term,});
}


class PermitEntity {

  bool? accepted;
  String? expirationDate;
  int? id;
  int? permitNumber;
  String? permitName;
  bool? selected;



  PermitEntity({
    this.accepted,
    this.expirationDate,
    this.id,
    this.permitNumber,
    this.permitName,
    this.selected,});

}