class CommercialDebt {
  String? infoMessage;
  String status;
  String? referenceId;
  double totalAmount;

  CommercialDebt({
    required this.infoMessage,
    required this.status,
    required this.referenceId,
    required this.totalAmount,
  });

  factory CommercialDebt.fromJson(Map<String, dynamic> json) => CommercialDebt(
        infoMessage: json["infoMessage"],
        status: json["status"] ?? "",
        referenceId: json["referenceId"],
        totalAmount: (json["totalAmount"] ?? 0.0) + 0.0,
      );
}

class Debt {
  double amount;
  String creationDate;
  String dueDate;
  String id;
  String number;
  DueStatus? service;
  String source;

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
        creationDate: json["creationDate"]  ?? "",
        dueDate: json["dueDate"]  ?? "",
        id: json["id"]  ?? "",
        number: json["number"] ?? "",
        service:  json["service"] != null ? DueStatus.fromJson(json["service"]) : null,
        source: json["source"]  ?? "",
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
        id: json["id"] ?? "",
        name: json["name"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
