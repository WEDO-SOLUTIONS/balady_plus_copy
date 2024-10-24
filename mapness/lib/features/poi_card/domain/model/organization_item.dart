class OrganizationItem {
  final int? timezoneOffset;
  final Flags? flags;
  final Stat? stat;
  final List<Rubrics>? rubrics;
  final String? regionId;
  final List<AdmDiv>? admDiv;
  final String? locale;
  final Links? links;
  final Reviews? reviews;
  final Address? address;
  final String? addressName;
  final String? addressComment;
  final String? name;
  final Point? point;
  final NameEx? nameEx;
  final List<ExternalContent>? externalContent;
  final String? segmentId;
  final bool? isDeleted;
  final String? poiCategory;
  final Schedule? schedule;
  final String? type;
  final Org? org;
  final String? cityAlias;
  final bool? hasDiscount;
  final String? id;

  const OrganizationItem({
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

  factory OrganizationItem.fromJson(Map<String, dynamic> json) {
    final rubricsFromJson = <Rubrics>[];
    if (json['rubrics'] != null) {
      for (final v in json['rubrics'] as Iterable) {
        rubricsFromJson.add(Rubrics.fromJson(v));
      }
    }

    final admDivFromJson = <AdmDiv>[];
    if (json['adm_div'] != null) {
      for (final v in json['adm_div'] as Iterable) {
        admDivFromJson.add(AdmDiv.fromJson(v));
      }
    }
    final externalContentFromJson = <ExternalContent>[];
    if (json['external_content'] != null) {
      for (final v in json['external_content'] as Iterable) {
        externalContentFromJson.add(ExternalContent.fromJson(v));
      }
    }

    return OrganizationItem(
      id: json['id'],
      timezoneOffset: json['timezone_offset'],
      flags: json['flags'] != null ? Flags.fromJson(json['flags']) : null,
      stat: json['stat'] != null ? Stat.fromJson(json['stat']) : null,
      rubrics: rubricsFromJson,
      regionId: json['region_id'],
      admDiv: admDivFromJson,
      locale: json['locale'],
      links: json['links'] != null ? Links.fromJson(json['links']) : null,
      reviews: json['reviews'] != null ? Reviews.fromJson(json['reviews']) : null,
      address: json['address'] != null ? Address.fromJson(json['address']) : null,
      addressName: json['address_name'],
      addressComment: json['address_comment'],
      name: json['name'],
      point: json['point'] != null ? Point.fromJson(json['point']) : null,
      nameEx: json['name_ex'] != null ? NameEx.fromJson(json['name_ex']) : null,
      externalContent: externalContentFromJson,
      segmentId: json['segment_id'],
      isDeleted: json['is_deleted'],
      poiCategory: json['poi_category'],
      schedule: json['schedule'] != null ? Schedule.fromJson(json['schedule']) : null,
      type: json['type'],
      org: json['org'] != null ? Org.fromJson(json['org']) : null,
      cityAlias: json['city_alias'],
      hasDiscount: json['has_discount'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['timezone_offset'] = timezoneOffset;
    data['id'] = id;
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
  final bool? photos;
  final bool? isDefault;

  const Flags({this.isDefault, this.photos});

  factory Flags.fromJson(Map<String, dynamic> json) => Flags(
        isDefault: json['is_default'],
        photos: json['photos'],
      );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
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
    final data = <String, dynamic>{};
    data['is_advertised'] = isAdvertised;
    data['match_type'] = matchType;
    data['source_type'] = sourceType;
    return data;
  }
}

class Rubrics {
  final String? name;
  final String? parentId;
  final int? shortId;
  final String? alias;
  final String? id;
  final String? kind;

  const Rubrics({
    required this.name,
    required this.parentId,
    required this.shortId,
    required this.alias,
    required this.id,
    required this.kind,
  });

  factory Rubrics.fromJson(Map<String, dynamic> json) => Rubrics(
        name: json['name'],
        parentId: json['parent_id'],
        shortId: json['short_id'],
        alias: json['alias'],
        id: json['id'],
        kind: json['kind'],
      );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
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
  final String? id;
  final String? name;
  final String? type;
  final bool? isDefault;
  final Flags? flags;
  final String? cityAlias;

  const AdmDiv({
    this.id,
    this.name,
    this.type,
    this.isDefault,
    this.flags,
    this.cityAlias,
  });

  factory AdmDiv.fromJson(Map<String, dynamic> json) => AdmDiv(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      isDefault: json['is_default'],
      flags: json['flags'] != null ? Flags.fromJson(json['flags']) : null,
      cityAlias: json['city_alias']);

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
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
  final List<Entrances>? databaseEntrances;
  final List<Entrances>? entrances;
  final List<NearestParking>? nearestParking;

  const Links({
    this.databaseEntrances,
    this.entrances,
    this.nearestParking,
  });

  factory Links.fromJson(Map<String, dynamic> json) {
    final databaseEntrances = <Entrances>[];
    if (json['database_entrances'] != null) {
      for (final v in json['database_entrances'] as Iterable) {
        databaseEntrances.add(Entrances.fromJson(v));
      }
    }
    final entrances = <Entrances>[];
    if (json['entrances'] != null) {
      for (final v in json['entrances'] as Iterable) {
        entrances.add(Entrances.fromJson(v));
      }
    }
    final nearestParking = <NearestParking>[];
    if (json['nearest_parking'] != null) {
      for (final v in json['nearest_parking'] as Iterable) {
        nearestParking.add(NearestParking.fromJson(v));
      }
    }
    return Links(
      databaseEntrances: databaseEntrances,
      entrances: entrances,
      nearestParking: nearestParking,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
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
  final Geometry? geometry;
  final String? id;
  final bool? isPrimary;
  final bool? isVisibleOnMap;

  const Entrances({
    this.geometry,
    this.id,
    this.isPrimary,
    this.isVisibleOnMap,
  });

  factory Entrances.fromJson(Map<String, dynamic> json) => Entrances(
        geometry: json['geometry'] != null ? Geometry.fromJson(json['geometry']) : null,
        id: json['id'],
        isPrimary: json['is_primary'],
        isVisibleOnMap: json['is_visible_on_map'],
      );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
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
  final List<String>? normals;
  final List<String>? points;
  final List<String>? vectors;

  const Geometry({
    this.normals,
    this.points,
    this.vectors,
  });

  factory Geometry.fromJson(Map<String, dynamic> json) {
    final normals = (json['normals'] as List).cast<String>();
    return Geometry(
      normals: normals,
      points: normals,
      vectors: normals,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['normals'] = normals;
    data['points'] = points;
    data['vectors'] = vectors;
    return data;
  }
}

class NearestParking {
  final String? id;

  const NearestParking({this.id});

  factory NearestParking.fromJson(Map<String, dynamic> json) => NearestParking(
        id: json['id'],
      );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    return data;
  }
}

class Reviews {
  final bool? isReviewable;
  final bool? isReviewableOnFlamp;
  final List<Items>? items;

  const Reviews({
    this.isReviewable,
    this.isReviewableOnFlamp,
    this.items,
  });

  factory Reviews.fromJson(Map<String, dynamic> json) {
    final _items = <Items>[];
    if (json['items'] != null) {
      for (final v in json['items'] as Iterable) {
        _items.add(Items.fromJson(v));
      }
    }
    return Reviews(
      isReviewable: json['is_reviewable'],
      isReviewableOnFlamp: json['is_reviewable_on_flamp'],
      items: _items,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['is_reviewable'] = isReviewable;
    data['is_reviewable_on_flamp'] = isReviewableOnFlamp;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  final bool? isReviewable;
  final String? tag;

  const Items({this.isReviewable, this.tag});

  factory Items.fromJson(Map<String, dynamic> json) => Items(
        isReviewable: json['is_reviewable'],
        tag: json['tag'],
      );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['is_reviewable'] = isReviewable;
    data['tag'] = tag;
    return data;
  }
}

class Address {
  final String? buildingId;
  final List<Components>? components;
  final String? makani;

  const Address({this.buildingId, this.components, this.makani});

  factory Address.fromJson(Map<String, dynamic> json) {
    final _components = <Components>[];
    if (json['components'] != null) {
      for (final v in json['components'] as Iterable) {
        _components.add(Components.fromJson(v));
      }
    }
    return Address(
      buildingId: json['building_id'],
      components: _components,
      makani: json['makani'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['building_id'] = buildingId;
    if (components != null) {
      data['components'] = components!.map((v) => v.toJson()).toList();
    }
    data['makani'] = makani;
    return data;
  }
}

class Components {
  final String? number;
  final String? street;
  final String? streetId;
  final String? type;

  const Components({this.number, this.street, this.streetId, this.type});

  factory Components.fromJson(Map<String, dynamic> json) => Components(
        number: json['number'],
        street: json['street'],
        streetId: json['street_id'],
        type: json['type'],
      );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['number'] = number;
    data['street'] = street;
    data['street_id'] = streetId;
    data['type'] = type;
    return data;
  }
}

class Point {
  final double? lat;
  final double? lon;

  const Point({this.lat, this.lon});

  factory Point.fromJson(Map<String, dynamic> json) => Point(
        lat: json['lat'],
        lon: json['lon'],
      );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['lat'] = lat;
    data['lon'] = lon;
    return data;
  }
}

class NameEx {
  final String? extensionValue;
  final String? primary;
  final String? shortName;

  const NameEx({this.extensionValue, this.primary, this.shortName});

  factory NameEx.fromJson(Map<String, dynamic> json) => NameEx(
        extensionValue: json['extension'],
        primary: json['primary'],
        shortName: json['short_name'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['extension'] = extensionValue;
    data['primary'] = primary;
    data['short_name'] = shortName;
    return data;
  }
}

class ExternalContent {
  final int? count;
  final String? url;
  final String? subtype;
  final String? type;

  const ExternalContent({this.count, this.url, this.subtype, this.type});

  factory ExternalContent.fromJson(Map<String, dynamic> json) => ExternalContent(
        count: json['count'],
        url: json['url'],
        subtype: json['subtype'],
        type: json['type'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['url'] = url;
    data['subtype'] = subtype;
    data['type'] = type;
    return data;
  }
}

class Schedule {
  final DayOfWeek? thu;
  final DayOfWeek? sat;
  final DayOfWeek? tue;
  final DayOfWeek? sun;
  final DayOfWeek? mon;
  final DayOfWeek? wed;
  final DayOfWeek? fri;

  const Schedule({this.thu, this.sat, this.tue, this.sun, this.mon, this.wed, this.fri});

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
        thu: json['Thu'] != null ? DayOfWeek.fromJson(json['Thu']) : null,
        sat: json['Sat'] != null ? DayOfWeek.fromJson(json['Sat']) : null,
        tue: json['Tue'] != null ? DayOfWeek.fromJson(json['Tue']) : null,
        sun: json['Sun'] != null ? DayOfWeek.fromJson(json['Sun']) : null,
        mon: json['Mon'] != null ? DayOfWeek.fromJson(json['Mon']) : null,
        wed: json['Wed'] != null ? DayOfWeek.fromJson(json['Wed']) : null,
        fri: json['Fri'] != null ? DayOfWeek.fromJson(json['Fri']) : null,
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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

class DayOfWeek {
  final List<WorkingHours>? workingHours;

  const DayOfWeek({this.workingHours});

  factory DayOfWeek.fromJson(Map<String, dynamic> json) {
    final _workingHours = <WorkingHours>[];
    if (json['working_hours'] != null) {
      for (final v in json['working_hours'] as Iterable) {
        _workingHours.add(WorkingHours.fromJson(v));
      }
    }
    return DayOfWeek(workingHours: _workingHours);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (workingHours != null) {
      data['working_hours'] = workingHours!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WorkingHours {
  final String? from;
  final String? to;

  const WorkingHours({this.from, this.to});

  factory WorkingHours.fromJson(Map<String, dynamic> json) => WorkingHours(
        from: json['from'],
        to: json['to'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['from'] = from;
    data['to'] = to;
    return data;
  }
}

class Org {
  final int? branchCount;
  final String? id;
  final String? name;

  const Org({
    this.branchCount,
    this.id,
    this.name,
  });

  factory Org.fromJson(Map<String, dynamic> json) => Org(
        branchCount: json['branch_count'],
        id: json['id'],
        name: json['name'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['branch_count'] = branchCount;
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
