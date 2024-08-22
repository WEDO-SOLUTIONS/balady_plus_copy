class CommercialDebt {
  List<Debt>? debts;
  String? infoMessage;
  String status;
  double totalAmount;

  CommercialDebt({
    required this.debts,
    required this.infoMessage,
    required this.status,
    required this.totalAmount,
  });

  factory CommercialDebt.fromJson(Map<String, dynamic> json) => CommercialDebt(
        debts: json["debts"] != null
            ? List<Debt>.from(json["debts"].map((x) => Debt.fromJson(x)))
            : null,
        infoMessage: json["infoMessage"],
        status: json["status"],
        totalAmount: (json["totalAmount"] ?? 0.0) + 0.0,
      );

}

class Debt {
  double amount;
  String creationDate;
  String dueDate;
  String id;
  String number;
  DueStatus service;
  String source ;
  Debt({
    required this.amount,
    required this.creationDate,
    required this.dueDate,
    required this.id,
    required this.number,
    required this.service,
    required this.source,
  });

  factory Debt.fromJson(Map<String, dynamic> json) => Debt(
        amount: (json["amount"] + 0.0),
        creationDate: json["creationDate"],
        dueDate: json["dueDate"],
        id: json["id"],
        number: json["number"],
        service: DueStatus.fromJson(json["service"]),
        source: json["source"],
      );

}


class DueStatus {
  String id;
  String name;

  DueStatus({
    required this.id,
    required this.name,
  });

  factory DueStatus.fromJson(Map<String, dynamic> json) => DueStatus(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

