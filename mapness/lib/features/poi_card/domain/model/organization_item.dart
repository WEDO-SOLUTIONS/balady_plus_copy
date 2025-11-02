import 'package:dgis_map/library.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mapness/shared/extensions/directory_object_message_ext.dart';

part 'organization_item.g.dart';

@JsonSerializable()
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
  @JsonKey(name: 'trade_license', fromJson: TradeLicenseMessageExt.fromJson, toJson: _tradeLicenceToJson)
  final TradeLicenseMessage? tradeLicense;

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
    this.tradeLicense,
  });

  factory OrganizationItem.fromJson(Map<String, dynamic> json) => _$OrganizationItemFromJson(json);

  Map<String, dynamic> toJson() => _$OrganizationItemToJson(this);
}

Map<String, dynamic>? _tradeLicenceToJson(TradeLicenseMessage? tradeLicence) => tradeLicence?.toJson();

@JsonSerializable()
class Flags {
  final bool? photos;
  final bool? isDefault;

  const Flags({this.isDefault, this.photos});

  factory Flags.fromJson(Map<String, dynamic> json) => _$FlagsFromJson(json);

  Map<String, dynamic> toJson() => _$FlagsToJson(this);
}

@JsonSerializable()
class Stat {
  bool? isAdvertised;
  int? matchType;
  int? sourceType;

  Stat({this.isAdvertised, this.matchType, this.sourceType});
  factory Stat.fromJson(Map<String, dynamic> json) => _$StatFromJson(json);

  Map<String, dynamic> toJson() => _$StatToJson(this);
}

@JsonSerializable()
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
  factory Rubrics.fromJson(Map<String, dynamic> json) => _$RubricsFromJson(json);

  Map<String, dynamic> toJson() => _$RubricsToJson(this);
}

@JsonSerializable()
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

  factory AdmDiv.fromJson(Map<String, dynamic> json) => _$AdmDivFromJson(json);

  Map<String, dynamic> toJson() => _$AdmDivToJson(this);
}

@JsonSerializable()
class Links {
  final List<Entrances>? databaseEntrances;
  final List<Entrances>? entrances;
  final List<NearestParking>? nearestParking;

  const Links({
    this.databaseEntrances,
    this.entrances,
    this.nearestParking,
  });

  factory Links.fromJson(Map<String, dynamic> json) => _$LinksFromJson(json);

  Map<String, dynamic> toJson() => _$LinksToJson(this);
}

@JsonSerializable()
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

  factory Entrances.fromJson(Map<String, dynamic> json) => _$EntrancesFromJson(json);

  Map<String, dynamic> toJson() => _$EntrancesToJson(this);
}

@JsonSerializable()
class Geometry {
  final List<String>? normals;
  final List<String>? points;
  final List<String>? vectors;

  const Geometry({
    this.normals,
    this.points,
    this.vectors,
  });

  factory Geometry.fromJson(Map<String, dynamic> json) => _$GeometryFromJson(json);

  Map<String, dynamic> toJson() => _$GeometryToJson(this);
}

@JsonSerializable()
class NearestParking {
  final String? id;

  const NearestParking({this.id});

  factory NearestParking.fromJson(Map<String, dynamic> json) => _$NearestParkingFromJson(json);

  Map<String, dynamic> toJson() => _$NearestParkingToJson(this);
}

@JsonSerializable()
class Reviews {
  final bool? isReviewable;
  final bool? isReviewableOnFlamp;
  final List<Items>? items;

  const Reviews({
    this.isReviewable,
    this.isReviewableOnFlamp,
    this.items,
  });

  factory Reviews.fromJson(Map<String, dynamic> json) => _$ReviewsFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewsToJson(this);
}

@JsonSerializable()
class Items {
  final bool? isReviewable;
  final String? tag;

  const Items({this.isReviewable, this.tag});

  factory Items.fromJson(Map<String, dynamic> json) => _$ItemsFromJson(json);

  Map<String, dynamic> toJson() => _$ItemsToJson(this);
}

@JsonSerializable()
class Address {
  final String? buildingId;
  final List<Components>? components;
  final String? makani;

  const Address({this.buildingId, this.components, this.makani});

  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);
}

@JsonSerializable()
class Components {
  final String? number;
  final String? street;
  final String? streetId;
  final String? type;

  const Components({this.number, this.street, this.streetId, this.type});

  factory Components.fromJson(Map<String, dynamic> json) => _$ComponentsFromJson(json);

  Map<String, dynamic> toJson() => _$ComponentsToJson(this);
}

@JsonSerializable()
class Point {
  final double? lat;
  final double? lon;

  const Point({this.lat, this.lon});

  factory Point.fromJson(Map<String, dynamic> json) => _$PointFromJson(json);

  Map<String, dynamic> toJson() => _$PointToJson(this);
}

@JsonSerializable()
class NameEx {
  final String? extensionValue;
  final String? primary;
  final String? shortName;

  const NameEx({this.extensionValue, this.primary, this.shortName});

  factory NameEx.fromJson(Map<String, dynamic> json) => _$NameExFromJson(json);

  Map<String, dynamic> toJson() => _$NameExToJson(this);
}

@JsonSerializable()
class ExternalContent {
  final int? count;
  final String? url;
  final String? subtype;
  final String? type;

  const ExternalContent({this.count, this.url, this.subtype, this.type});

  factory ExternalContent.fromJson(Map<String, dynamic> json) => _$ExternalContentFromJson(json);

  Map<String, dynamic> toJson() => _$ExternalContentToJson(this);
}

@JsonSerializable()
class Schedule {
  final DayOfWeek? thu;
  final DayOfWeek? sat;
  final DayOfWeek? tue;
  final DayOfWeek? sun;
  final DayOfWeek? mon;
  final DayOfWeek? wed;
  final DayOfWeek? fri;

  const Schedule({this.thu, this.sat, this.tue, this.sun, this.mon, this.wed, this.fri});

  factory Schedule.fromJson(Map<String, dynamic> json) => _$ScheduleFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleToJson(this);
}

@JsonSerializable()
class DayOfWeek {
  final List<WorkingHours>? workingHours;

  const DayOfWeek({this.workingHours});

  factory DayOfWeek.fromJson(Map<String, dynamic> json) => _$DayOfWeekFromJson(json);

  Map<String, dynamic> toJson() => _$DayOfWeekToJson(this);
}

@JsonSerializable()
class WorkingHours {
  final String? from;
  final String? to;

  const WorkingHours({this.from, this.to});

  factory WorkingHours.fromJson(Map<String, dynamic> json) => _$WorkingHoursFromJson(json);

  Map<String, dynamic> toJson() => _$WorkingHoursToJson(this);
}

@JsonSerializable()
class Org {
  final int? branchCount;
  final String? id;
  final String? name;

  const Org({
    this.branchCount,
    this.id,
    this.name,
  });

  factory Org.fromJson(Map<String, dynamic> json) => _$OrgFromJson(json);

  Map<String, dynamic> toJson() => _$OrgToJson(this);
}
