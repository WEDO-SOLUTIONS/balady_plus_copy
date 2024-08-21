class CommercialDebt {
  List<Debt>? debts;
  String? infoMessage;
  String status;
  int? totalAmount;

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
        totalAmount: json["totalAmount"],
      );

// Map<String, dynamic> toJson() => {
//   "debts": List<dynamic>.from(debts.map((x) => x.toJson())),
//   "infoMessage": infoMessage,
//   "status": status,
//   "totalAmount": totalAmount,
// };
}

class Debt {
  int amount;
  List<DueStatus> categories;
  String creationDate;
  String dueDate;
  DueStatus dueStatus;
  String id;
  DueStatus license;
  DueStatus licenseType;
  DueStatus municipality;
  String number;
  DueStatus product;
  DueStatus service;
  String settlementDate;
  DueStatus status;
  SubMunicipality subMunicipality;
  DueStatus transaction;

  Debt({
    required this.amount,
    required this.categories,
    required this.creationDate,
    required this.dueDate,
    required this.dueStatus,
    required this.id,
    required this.license,
    required this.licenseType,
    required this.municipality,
    required this.number,
    required this.product,
    required this.service,
    required this.settlementDate,
    required this.status,
    required this.subMunicipality,
    required this.transaction,
  });

  factory Debt.fromJson(Map<String, dynamic> json) => Debt(
        amount: json["amount"],
        categories: List<DueStatus>.from(
            json["categories"].map((x) => DueStatus.fromJson(x))),
        creationDate: json["creationDate"],
        dueDate: json["dueDate"],
        dueStatus: DueStatus.fromJson(json["dueStatus"]),
        id: json["id"],
        license: DueStatus.fromJson(json["license"]),
        licenseType: DueStatus.fromJson(json["licenseType"]),
        municipality: DueStatus.fromJson(json["municipality"]),
        number: json["number"],
        product: DueStatus.fromJson(json["product"]),
        service: DueStatus.fromJson(json["service"]),
        settlementDate: json["settlementDate"],
        status: DueStatus.fromJson(json["status"]),
        subMunicipality: SubMunicipality.fromJson(json["subMunicipality"]),
        transaction: DueStatus.fromJson(json["transaction"]),
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
        "creationDate": creationDate,
        "dueDate": dueDate,
        "dueStatus": dueStatus.toJson(),
        "id": id,
        "license": license.toJson(),
        "licenseType": licenseType.toJson(),
        "municipality": municipality.toJson(),
        "number": number,
        "product": product.toJson(),
        "service": service.toJson(),
        "settlementDate": settlementDate,
        "status": status.toJson(),
        "subMunicipality": subMunicipality.toJson(),
        "transaction": transaction.toJson(),
      };
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

class SubMunicipality {
  String id;

  SubMunicipality({
    required this.id,
  });

  factory SubMunicipality.fromJson(Map<String, dynamic> json) =>
      SubMunicipality(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}
