class OrganizationItem {
  int? timezoneOffset;
  Flags? flags;
  Stat? stat;
  List<Rubrics>? rubrics;
  String? regionId;
  List<AdmDiv>? admDiv;
  String? locale;
  Links? links;
  Reviews? reviews;
  Address? address;
  String? addressName;
  String? addressComment;
  String? name;
  Point? point;
  NameEx? nameEx;
  List<ExternalContent>? externalContent;
  String? segmentId;
  bool? isDeleted;
  String? poiCategory;
  Schedule? schedule;
  String? type;
  Org? org;
  String? cityAlias;
  bool? hasDiscount;
  String? id;

  OrganizationItem({
    this.timezoneOffset,
    this.flags,
    this.stat,
    this.rubrics,
    this.regionId,
    this.admDiv,
    this.locale,
    this.links,
    this.reviews,
    this.address,
    this.addressName,
    this.addressComment,
    this.name,
    this.point,
    this.nameEx,
    this.externalContent,
    this.segmentId,
    this.isDeleted,
    this.poiCategory,
    this.schedule,
    this.type,
    this.org,
    this.cityAlias,
    this.hasDiscount,
    this.id,
  });

  OrganizationItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    timezoneOffset = json['timezone_offset'];
    flags = json['flags'] != null ? Flags.fromJson(json['flags']) : null;
    stat = json['stat'] != null ? Stat.fromJson(json['stat']) : null;
    if (json['rubrics'] != null) {
      rubrics = <Rubrics>[];
      json['rubrics'].forEach((v) {
        rubrics!.add(Rubrics.fromJson(v));
      });
    }
    regionId = json['region_id'];
    if (json['adm_div'] != null) {
      admDiv = <AdmDiv>[];
      json['adm_div'].forEach((v) {
        admDiv!.add(AdmDiv.fromJson(v));
      });
    }
    locale = json['locale'];
    links = json['links'] != null ? Links.fromJson(json['links']) : null;
    reviews = json['reviews'] != null ? Reviews.fromJson(json['reviews']) : null;
    address = json['address'] != null ? Address.fromJson(json['address']) : null;
    addressName = json['address_name'];
    addressComment = json['address_comment'];
    name = json['name'];
    point = json['point'] != null ? Point.fromJson(json['point']) : null;
    nameEx = json['name_ex'] != null ? NameEx.fromJson(json['name_ex']) : null;
    if (json['external_content'] != null) {
      externalContent = <ExternalContent>[];
      json['external_content'].forEach((v) {
        externalContent!.add(ExternalContent.fromJson(v));
      });
    }
    segmentId = json['segment_id'];
    isDeleted = json['is_deleted'];
    poiCategory = json['poi_category'];
    schedule = json['schedule'] != null ? Schedule.fromJson(json['schedule']) : null;
    type = json['type'];
    org = json['org'] != null ? Org.fromJson(json['org']) : null;
    cityAlias = json['city_alias'];
    hasDiscount = json['has_discount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['timezone_offset'] = timezoneOffset;
    if (flags != null) {
      data['flags'] = flags!.toJson();
    }
    if (stat != null) {
      data['stat'] = stat!.toJson();
    }
    if (rubrics != null) {
      data['rubrics'] = rubrics!.map((v) => v.toJson()).toList();
    }
    data['region_id'] = regionId;
    if (admDiv != null) {
      data['adm_div'] = admDiv!.map((v) => v.toJson()).toList();
    }
    data['locale'] = locale;
    if (links != null) {
      data['links'] = links!.toJson();
    }
    if (reviews != null) {
      data['reviews'] = reviews!.toJson();
    }
    if (address != null) {
      data['address'] = address!.toJson();
    }
    data['address_name'] = addressName;
    data['address_comment'] = addressComment;
    data['name'] = name;
    if (point != null) {
      data['point'] = point!.toJson();
    }
    if (nameEx != null) {
      data['name_ex'] = nameEx!.toJson();
    }
    if (externalContent != null) {
      data['external_content'] = externalContent!.map((v) => v.toJson()).toList();
    }
    data['segment_id'] = segmentId;
    data['is_deleted'] = isDeleted;
    data['poi_category'] = poiCategory;
    if (schedule != null) {
      data['schedule'] = schedule!.toJson();
    }
    data['type'] = type;
    if (org != null) {
      data['org'] = org!.toJson();
    }
    data['city_alias'] = cityAlias;
    data['has_discount'] = hasDiscount;
    return data;
  }
}

class Flags {
  bool? photos;

  bool? isDefault;

  Flags({this.isDefault});

  Flags.fromJson(Map<String, dynamic> json) {
    isDefault = json['is_default'];
    photos = json['photos'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['photos'] = photos;
    data['is_default'] = isDefault;
    return data;
  }
}

class Stat {
  bool? isAdvertised;
  int? matchType;
  int? sourceType;

  Stat({this.isAdvertised, this.matchType, this.sourceType});

  Stat.fromJson(Map<String, dynamic> json) {
    isAdvertised = json['is_advertised'];
    matchType = json['match_type'];
    sourceType = json['source_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['is_advertised'] = isAdvertised;
    data['match_type'] = matchType;
    data['source_type'] = sourceType;
    return data;
  }
}

class Rubrics {
  String? name;
  String? parentId;
  int? shortId;
  String? alias;
  String? id;
  String? kind;

  Rubrics({this.name, this.parentId, this.shortId, this.alias, this.id, this.kind});

  Rubrics.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    parentId = json['parent_id'];
    shortId = json['short_id'];
    alias = json['alias'];
    id = json['id'];
    kind = json['kind'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = name;
    data['parent_id'] = parentId;
    data['short_id'] = shortId;
    data['alias'] = alias;
    data['id'] = id;
    data['kind'] = kind;
    return data;
  }
}

class AdmDiv {
  String? id;
  String? name;
  String? type;
  bool? isDefault;
  Flags? flags;
  String? cityAlias;

  AdmDiv({this.id, this.name, this.type, this.isDefault, this.flags, this.cityAlias});

  AdmDiv.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    isDefault = json['is_default'];
    flags = json['flags'] != null ? Flags.fromJson(json['flags']) : null;
    cityAlias = json['city_alias'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['type'] = type;
    data['is_default'] = isDefault;
    if (flags != null) {
      data['flags'] = flags!.toJson();
    }
    data['city_alias'] = cityAlias;
    return data;
  }
}

class Links {
  List<Entrances>? databaseEntrances;
  List<Entrances>? entrances;
  List<NearestParking>? nearestParking;

  Links({this.databaseEntrances, this.entrances, this.nearestParking});

  Links.fromJson(Map<String, dynamic> json) {
    if (json['database_entrances'] != null) {
      databaseEntrances = <Entrances>[];
      json['database_entrances'].forEach((v) {
        databaseEntrances!.add(Entrances.fromJson(v));
      });
    }
    if (json['entrances'] != null) {
      entrances = <Entrances>[];
      json['entrances'].forEach((v) {
        entrances!.add(Entrances.fromJson(v));
      });
    }
    if (json['nearest_parking'] != null) {
      nearestParking = <NearestParking>[];
      json['nearest_parking'].forEach((v) {
        nearestParking!.add(NearestParking.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (databaseEntrances != null) {
      data['database_entrances'] = databaseEntrances!.map((v) => v.toJson()).toList();
    }
    if (entrances != null) {
      data['entrances'] = entrances!.map((v) => v.toJson()).toList();
    }
    if (nearestParking != null) {
      data['nearest_parking'] = nearestParking!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Entrances {
  Geometry? geometry;
  String? id;
  bool? isPrimary;
  bool? isVisibleOnMap;

  Entrances({this.geometry, this.id, this.isPrimary, this.isVisibleOnMap});

  Entrances.fromJson(Map<String, dynamic> json) {
    geometry = json['geometry'] != null ? Geometry.fromJson(json['geometry']) : null;
    id = json['id'];
    isPrimary = json['is_primary'];
    isVisibleOnMap = json['is_visible_on_map'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (geometry != null) {
      data['geometry'] = geometry!.toJson();
    }
    data['id'] = id;
    data['is_primary'] = isPrimary;
    data['is_visible_on_map'] = isVisibleOnMap;
    return data;
  }
}

class Geometry {
  List<String>? normals;
  List<String>? points;
  List<String>? vectors;

  Geometry({this.normals, this.points, this.vectors});

  Geometry.fromJson(Map<String, dynamic> json) {
    normals = json['normals'].cast<String>();
    points = json['points'].cast<String>();
    vectors = json['vectors'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['normals'] = normals;
    data['points'] = points;
    data['vectors'] = vectors;
    return data;
  }
}

class NearestParking {
  String? id;

  NearestParking({this.id});

  NearestParking.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    return data;
  }
}

class Reviews {
  bool? isReviewable;
  bool? isReviewableOnFlamp;
  List<Items>? items;

  Reviews({this.isReviewable, this.isReviewableOnFlamp, this.items});

  Reviews.fromJson(Map<String, dynamic> json) {
    isReviewable = json['is_reviewable'];
    isReviewableOnFlamp = json['is_reviewable_on_flamp'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['is_reviewable'] = isReviewable;
    data['is_reviewable_on_flamp'] = isReviewableOnFlamp;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  bool? isReviewable;
  String? tag;

  Items({this.isReviewable, this.tag});

  Items.fromJson(Map<String, dynamic> json) {
    isReviewable = json['is_reviewable'];
    tag = json['tag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['is_reviewable'] = isReviewable;
    data['tag'] = tag;
    return data;
  }
}

class Address {
  String? buildingId;
  List<Components>? components;
  String? makani;

  Address({this.buildingId, this.components, this.makani});

  Address.fromJson(Map<String, dynamic> json) {
    buildingId = json['building_id'];
    if (json['components'] != null) {
      components = <Components>[];
      json['components'].forEach((v) {
        components!.add(Components.fromJson(v));
      });
    }
    makani = json['makani'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['building_id'] = buildingId;
    if (components != null) {
      data['components'] = components!.map((v) => v.toJson()).toList();
    }
    data['makani'] = makani;
    return data;
  }
}

class Components {
  String? number;
  String? street;
  String? streetId;
  String? type;

  Components({this.number, this.street, this.streetId, this.type});

  Components.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    street = json['street'];
    streetId = json['street_id'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['number'] = number;
    data['street'] = street;
    data['street_id'] = streetId;
    data['type'] = type;
    return data;
  }
}

class Point {
  double? lat;
  double? lon;

  Point({this.lat, this.lon});

  Point.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lon = json['lon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['lat'] = lat;
    data['lon'] = lon;
    return data;
  }
}

class NameEx {
  String? extension;
  String? primary;
  String? shortName;

  NameEx({this.extension, this.primary, this.shortName});

  NameEx.fromJson(Map<String, dynamic> json) {
    extension = json['extension'];
    primary = json['primary'];
    shortName = json['short_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['extension'] = extension;
    data['primary'] = primary;
    data['short_name'] = shortName;
    return data;
  }
}

class ExternalContent {
  int? count;
  String? url;
  String? subtype;
  String? type;

  ExternalContent({this.count, this.url, this.subtype, this.type});

  ExternalContent.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    url = json['url'];
    subtype = json['subtype'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['count'] = count;
    data['url'] = url;
    data['subtype'] = subtype;
    data['type'] = type;
    return data;
  }
}

class Schedule {
  Thu? thu;
  Thu? sat;
  Thu? tue;
  Thu? sun;
  Thu? mon;
  Thu? wed;
  Thu? fri;

  Schedule({this.thu, this.sat, this.tue, this.sun, this.mon, this.wed, this.fri});

  Schedule.fromJson(Map<String, dynamic> json) {
    thu = json['Thu'] != null ? Thu.fromJson(json['Thu']) : null;
    sat = json['Sat'] != null ? Thu.fromJson(json['Sat']) : null;
    tue = json['Tue'] != null ? Thu.fromJson(json['Tue']) : null;
    sun = json['Sun'] != null ? Thu.fromJson(json['Sun']) : null;
    mon = json['Mon'] != null ? Thu.fromJson(json['Mon']) : null;
    wed = json['Wed'] != null ? Thu.fromJson(json['Wed']) : null;
    fri = json['Fri'] != null ? Thu.fromJson(json['Fri']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (thu != null) {
      data['Thu'] = thu!.toJson();
    }
    if (sat != null) {
      data['Sat'] = sat!.toJson();
    }
    if (tue != null) {
      data['Tue'] = tue!.toJson();
    }
    if (sun != null) {
      data['Sun'] = sun!.toJson();
    }
    if (mon != null) {
      data['Mon'] = mon!.toJson();
    }
    if (wed != null) {
      data['Wed'] = wed!.toJson();
    }
    if (fri != null) {
      data['Fri'] = fri!.toJson();
    }
    return data;
  }
}

class Thu {
  List<WorkingHours>? workingHours;

  Thu({this.workingHours});

  Thu.fromJson(Map<String, dynamic> json) {
    if (json['working_hours'] != null) {
      workingHours = <WorkingHours>[];
      json['working_hours'].forEach((v) {
        workingHours!.add(WorkingHours.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (workingHours != null) {
      data['working_hours'] = workingHours!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WorkingHours {
  String? from;
  String? to;

  WorkingHours({this.from, this.to});

  WorkingHours.fromJson(Map<String, dynamic> json) {
    from = json['from'];
    to = json['to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['from'] = from;
    data['to'] = to;
    return data;
  }
}

class Org {
  int? branchCount;
  String? id;
  String? name;

  Org({this.branchCount, this.id, this.name});

  Org.fromJson(Map<String, dynamic> json) {
    branchCount = json['branch_count'];
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['branch_count'] = branchCount;
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
