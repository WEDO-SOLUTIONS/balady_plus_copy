class SuggestedAreaModel {
  int id;
  int? from;
  int? to;
  String desc;
  bool isActive;

  SuggestedAreaModel(
      {required this.desc,
      this.from,
      this.to,
      required this.id,
      required this.isActive});

  String getItem() {
    if (from == null && to != null) {
      return "أصغر من ${to}";
    }

    if (from != null && to == null) {
      return "أكبر من ${from}";
    }

    return "من ${from} إلى ${to}";
  }

  factory SuggestedAreaModel.fromJson(Map<String, dynamic> json) {
    return SuggestedAreaModel(
      id: json['id'],
      from: json['from'],
      to: json['to'],
      desc: json['desc'],
      isActive: json['isActive'],
    );
  }

  // Convert SuggestedAreaModel object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'from': from,
      'to': to,
      'desc': desc,
      'isActive': isActive,
    };
  }
}
