









class UrbiLocationModel {
  UrbiLocationModel({
    this.admDiv,
    this.fullName,
    this.id,
    this.name,
    this.point,
    this.searchAttributes,
    this.subtype,
    this.type,});

  UrbiLocationModel.fromJson(dynamic json) {
    if (json['adm_div'] != null) {
      admDiv = [];
      json['adm_div'].forEach((v) {
        admDiv?.add(AdmDiv.fromJson(v));
      });
    }
    fullName = json['full_name'];
    id = json['id'];
    name = json['name'];
    point = json['point'] != null ? Point.fromJson(json['point']) : null;
    searchAttributes = json['search_attributes'] != null ? SearchAttributes.fromJson(json['search_attributes']) : null;
    subtype = json['subtype'];
    type = json['type'];
  }
  List<AdmDiv>? admDiv;
  String? fullName;
  String? id;
  String? name;
  Point? point;
  SearchAttributes? searchAttributes;
  String? subtype;
  String? type;
  UrbiLocationModel copyWith({  List<AdmDiv>? admDiv,
    String? fullName,
    String? id,
    String? name,
    Point? point,
    SearchAttributes? searchAttributes,
    String? subtype,
    String? type,
  }) => UrbiLocationModel(  admDiv: admDiv ?? this.admDiv,
    fullName: fullName ?? this.fullName,
    id: id ?? this.id,
    name: name ?? this.name,
    point: point ?? this.point,
    searchAttributes: searchAttributes ?? this.searchAttributes,
    subtype: subtype ?? this.subtype,
    type: type ?? this.type,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (admDiv != null) {
      map['adm_div'] = admDiv?.map((v) => v.toJson()).toList();
    }
    map['full_name'] = fullName;
    map['id'] = id;
    map['name'] = name;
    if (point != null) {
      map['point'] = point?.toJson();
    }
    if (searchAttributes != null) {
      map['search_attributes'] = searchAttributes?.toJson();
    }
    map['subtype'] = subtype;
    map['type'] = type;
    return map;
  }

}

class SearchAttributes {
  SearchAttributes({
    this.handlingType,
    this.suggestParts,
    this.suggestedText,});

  SearchAttributes.fromJson(dynamic json) {
    handlingType = json['handling_type'];
    if (json['suggest_parts'] != null) {
      suggestParts = [];
      json['suggest_parts'].forEach((v) {
        suggestParts?.add(SuggestParts.fromJson(v));
      });
    }
    suggestedText = json['suggested_text'];
  }
  int? handlingType;
  List<SuggestParts>? suggestParts;
  String? suggestedText;
  SearchAttributes copyWith({  int? handlingType,
    List<SuggestParts>? suggestParts,
    String? suggestedText,
  }) => SearchAttributes(  handlingType: handlingType ?? this.handlingType,
    suggestParts: suggestParts ?? this.suggestParts,
    suggestedText: suggestedText ?? this.suggestedText,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['handling_type'] = handlingType;
    if (suggestParts != null) {
      map['suggest_parts'] = suggestParts?.map((v) => v.toJson()).toList();
    }
    map['suggested_text'] = suggestedText;
    return map;
  }

}

class SuggestParts {
  SuggestParts({
    this.isSuggested,
    this.text,});

  SuggestParts.fromJson(dynamic json) {
    isSuggested = json['is_suggested'];
    text = json['text'];
  }
  bool? isSuggested;
  String? text;
  SuggestParts copyWith({  bool? isSuggested,
    String? text,
  }) => SuggestParts(  isSuggested: isSuggested ?? this.isSuggested,
    text: text ?? this.text,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['is_suggested'] = isSuggested;
    map['text'] = text;
    return map;
  }

}

class Point {
  Point({
    this.lat,
    this.lon,});

  Point.fromJson(dynamic json) {
    lat = json['lat'];
    lon = json['lon'];
  }
  double? lat;
  double? lon;
  Point copyWith({  double? lat,
    double? lon,
  }) => Point(  lat: lat ?? this.lat,
    lon: lon ?? this.lon,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['lat'] = lat;
    map['lon'] = lon;
    return map;
  }

}

class AdmDiv {
  AdmDiv({
    this.id,
    this.name,
    this.type,});

  AdmDiv.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
  }
  String? id;
  String? name;
  String? type;
  AdmDiv copyWith({  String? id,
    String? name,
    String? type,
  }) => AdmDiv(  id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['type'] = type;
    return map;
  }

}