class Permit {
  dynamic permitName;
  int? permitNumber;
  String? permitEndDate;
  bool? selected;

  Permit({this.permitName, this.permitNumber, this.permitEndDate , this.selected});

  factory Permit.fromJson(Map<String, dynamic> json) => Permit(
        permitName: json['permitName'] as dynamic,
        permitNumber: json['permitNumber'] as int?,
        permitEndDate: json['permitEndDate'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'permitName': permitName,
        'permitNumber': permitNumber,
        'permitEndDate': permitEndDate,
      };
}
