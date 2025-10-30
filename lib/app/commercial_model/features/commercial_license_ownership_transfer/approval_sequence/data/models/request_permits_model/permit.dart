class Permit {
  dynamic permitName;
  int? permitNumber;
  int? requestId;
  String? permitEndDate;
  bool? selected;

  Permit(
      {this.permitName, this.permitNumber,this.requestId, this.permitEndDate, this.selected});

  factory Permit.fromJson(Map<String, dynamic> json) => Permit(
        permitName: json['permitName'] as dynamic,
        permitNumber: json['permitNumber'] as int?,
        requestId : json['requestId']as int?,
        permitEndDate: json['permitEndDate'] as String?
      );

  Map<String, dynamic> toJson() => {
        'permitName': permitName,
        'permitNumber': permitNumber,
        'permitEndDate': permitEndDate,
      };
}
