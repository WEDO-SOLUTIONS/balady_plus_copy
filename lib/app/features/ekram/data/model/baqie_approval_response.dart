import 'package:balady_plus/app/core/utils/extensions/date_time_extension.dart';
import 'package:intl/intl.dart';

class BaqieApprovalResponse {
  final String? idno;
  final int? idType;
  final String? firstName;
  final String? middleName;
  final String? thirdName;
  final String? lastName;
  final int? status;
  final String? approvalDate;

  BaqieApprovalResponse({
    this.idno,
    this.idType,
    this.firstName,
    this.middleName,
    this.thirdName,
    this.lastName,
    this.status,
    this.approvalDate,
  });

  factory BaqieApprovalResponse.fromJson(Map<String, dynamic> json) =>
      BaqieApprovalResponse(
        idno: json["idno"],
        idType: json["idType"],
        firstName: json["firstName"],
        middleName: json["middleName"],
        thirdName: json["thirdName"],
        lastName: json["lastName"],
        status: json["status"],
        approvalDate: json["approvalDate"],
      );
  String? getDate() {
    DateTime? d = DateTime.tryParse(approvalDate ?? "");

    if (d != null) {
      final DateFormat formatter = DateFormat('yyyy/M/dd hh:mm');
      final String formatted = formatter.format(d);
      return formatted;
    }
  }

  String getStatusAr() {
    switch (status) {
      case 0:
        return "معلق";
      case 1:
        return "معتمد";

      case 2:
        return "مرفوض";
    }
    return "";
  }
}
