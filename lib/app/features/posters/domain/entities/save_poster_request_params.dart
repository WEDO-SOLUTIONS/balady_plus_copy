class SavePosterRequestParams {
  final String? requestId;
  final int? duration;
  final String? permitStartDate;
  final List<Poster>? posters;

  SavePosterRequestParams({
    this.requestId,
    this.duration,
    this.permitStartDate,
    this.posters,
  });

  factory SavePosterRequestParams.fromJson(Map<String, dynamic> json) =>
      SavePosterRequestParams(
        duration: json["duration"],
        permitStartDate: json["permitStartDate"],
        posters: json["posters"] == null
            ? []
            : List<Poster>.from(
                json["posters"]!.map((x) => Poster.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "duration": duration,
        "permitStartDate": permitStartDate,
        "posters": posters == null
            ? []
            : List<dynamic>.from(posters!.map((x) => x.toJson())),
      };
}

class Poster {
  final List<String>? attachedDocuments;
  final double? length;
  final String? name;
  final int? typeId;
  final double? width;
  final int? discountPercentage;

  Poster(
      {this.attachedDocuments,
      this.length,
      this.name,
      this.typeId,
      this.width,
      this.discountPercentage});

  factory Poster.fromJson(Map<String, dynamic> json) => Poster(
        attachedDocuments: json["attachedDocuments"] == null
            ? []
            : List<String>.from(json["attachedDocuments"]!.map((x) => x)),
        length: json["length"],
        discountPercentage: json["discountPercentage"],
        name: json["name"],
        typeId: json["typeId"],
        width: json["width"],
      );

  Map<String, dynamic> toJson() => {
        "attachedDocuments": attachedDocuments == null
            ? []
            : List<dynamic>.from(attachedDocuments!.map((x) => x)),
        "length": length,
        "name": name,
        "typeId": typeId,
        "width": width,
        "discountPercentage": discountPercentage
      };
}
