import 'package:dgis_map/library.dart';

extension DirectoryObjectMessageExt on DirectoryObjectMessage {
  Map<String, dynamic> toJson() {
    final typesList = types.map((item) => item.toJson()).toList();
    final markerPositionJson = markerPosition?.toJson();
    final addressJson = address?.toJson();
    final fullAddressNameJson = fullAddressName?.toJson();
    final shortAddressNameJson = shortAddressName?.toJson();
    final attributesList = attributes.map((item) => item.toJson()).toList();
    final contextAttributesList = contextAttributes.map((item) => item.toJson()).toList();
    final contactInfosList = contactInfos.map((item) => item.toJson()).toList();
    final openingHoursJson = openingHours?.toJson();
    final reviewsJson = reviews?.toJson();
    final parkingInfoJson = parkingInfo?.toJson();
    final workStatusJson = workStatus?.toJson();
    final buildingLevelsJson = buildingLevels?.toJson();
    final buildingInfoJson = buildingInfo.toJson();
    final entrancesList = entrances.map((item) {
      final json = item.toJson();
      return json;
    }).toList();
    final tradeLicenseJson = tradeLicense?.toJson();
    final routeInfosList = routeInfos.map((item) => item.toJson()).toList();
    final groupList = group.map((item) => item.toJson()).toList();
    return {
      'types': typesList,
      'title': title,
      'titleAddition': titleAddition,
      'subtitle': subtitle,
      'about': about,
      'id': id?.toJson(),
      'markerPosition': markerPositionJson,
      'address': addressJson,
      'fullAddressName': fullAddressNameJson,
      'shortAddressName': shortAddressNameJson,
      'attributes': attributesList,
      'contextAttributes': contextAttributesList,
      'timeZoneOffset': timeZoneOffset,
      'openingHours': openingHoursJson,
      'contactInfos': contactInfosList,
      'reviews': reviewsJson,
      'parkingInfo': parkingInfoJson,
      'workStatus': workStatusJson,
      'levelId': levelId,
      'buildingLevels': buildingLevelsJson,
      'buildingInfo': buildingInfoJson,
      'entrances': entrancesList,
      'tradeLicense': tradeLicenseJson,
      'rubricIds': rubricIds,
      'routeInfos': routeInfosList,
      'group': groupList,
      'platformIds': platformIds.map((item) => item.toJson()).toList(),
    };
  }

  static DirectoryObjectMessage fromJson(Map<String, dynamic> json) => DirectoryObjectMessage(
    types: (json['types'] as List<dynamic>?)!
        .map((e) => ObjectTypeItemMessageExt.fromJson(e as Map<String, dynamic>))
        .toList(),
    title: json['title'] as String,
    titleAddition: json['titleAddition'] as String,
    subtitle: json['subtitle'] as String,
    about: json['about'] as String,
    id: json['id'] != null ? DgisObjectIdMessageExt.fromJson(json['id'] as Map<String, dynamic>) : null,
    markerPosition: json['markerPosition'] != null
        ? GeoPointWithElevationMessageExt.fromJson(json['markerPosition'] as Map<String, dynamic>)
        : null,
    address: json['address'] != null ? AddressMessageExt.fromJson(json['address'] as Map<String, dynamic>) : null,
    fullAddressName: json['fullAddressName'] != null
        ? FormattedAddressMessageExtension.fromJson(json['fullAddressName'] as Map<String, dynamic>)
        : null,
    shortAddressName: json['shortAddressName'] != null
        ? FormattedAddressMessageExtension.fromJson(json['shortAddressName'] as Map<String, dynamic>)
        : null,
    attributes: (json['attributes'] as List<dynamic>?)!
        .map((e) => AttributeMessageExtension.fromJson(e as Map<String, dynamic>?))
        .toList(),
    contextAttributes: (json['contextAttributes'] as List<dynamic>?)!
        .map((e) => AttributeMessageExtension.fromJson(e as Map<String, dynamic>?))
        .toList(),
    timeZoneOffset: (json['timeZoneOffset'] as num?)?.toDouble(),
    openingHours: json['openingHours'] != null
        ? OpeningHoursMessageExtension.fromJson(json['openingHours'] as Map<String, dynamic>)
        : null,
    contactInfos: (json['contactInfos'] as List<dynamic>?)!
        .map((e) => ContactInfoMessageExtension.fromJson(e as Map<String, dynamic>?))
        .toList(),
    reviews: json['reviews'] != null ? ReviewsMessageExtension.fromJson(json['reviews'] as Map<String, dynamic>) : null,
    parkingInfo: json['parkingInfo'] != null
        ? ParkingInfoMessageExtension.fromJson(json['parkingInfo'] as Map<String, dynamic>)
        : null,
    workStatus: json['workStatus'] != null
        ? WorkStatusMessageExtension.fromJson(json['workStatus'] as Map<String, dynamic>)
        : null,
    levelId: json['levelId'] as int?,
    buildingLevels: json['buildingLevels'] != null
        ? BuildingLevelsMessageExtension.fromJson(json['buildingLevels'] as Map<String, dynamic>)
        : null,
    buildingInfo: BuildingInfoMessageExtension.fromJson(json['buildingInfo'] as Map<String, dynamic>),
    entrances: (json['entrances'] as List<dynamic>?)!
        .map((e) => EntranceInfoMessageExt.fromJson(e as Map<String, dynamic>?))
        .toList(),
    tradeLicense: json['tradeLicense'] != null
        ? TradeLicenseMessageExt.fromJson(json['tradeLicense'] as Map<String, dynamic>)
        : null,
    rubricIds: (json['rubricIds'] as List<dynamic>).map((e) => e as int).toList(),
    routeInfos:
        (json['routeInfos'] as List<dynamic>?)
            ?.map((e) => PublicTransportDirectoryRouteInfoMessageExt.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    orgInfo: json['orgInfo'] != null ? OrgInfoMessageExt.fromJson(json['orgInfo'] as Map<String, dynamic>) : null,
    platformIds:
        (json['platformIds'] as List<dynamic>?)
            ?.map((e) => DgisObjectIdMessageExt.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    group:
        (json['group'] as List<dynamic>?)
            ?.map((e) => GroupItemMessageExt.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
  );
  static const _broadAreaDrilldownTypes = {
    'region',
    'district_area',
    'district',
  };

  bool get hasHighlightableType {
    final hasBroadAreaType = types.any(
      (e) => switch (e.type) {
        ObjectTypeMessage.admDiv ||
        ObjectTypeMessage.admDivCity ||
        ObjectTypeMessage.admDivCountry ||
        ObjectTypeMessage.admDivDistrict ||
        ObjectTypeMessage.admDivDistrictArea ||
        ObjectTypeMessage.admDivDivision ||
        ObjectTypeMessage.admDivLivingArea ||
        ObjectTypeMessage.admDivPlace ||
        ObjectTypeMessage.admDivRegion ||
        ObjectTypeMessage.admDivSettlement ||
        ObjectTypeMessage.road ||
        ObjectTypeMessage.street => true,
        ObjectTypeMessage.unknown =>
          address?.drilldown.any((item) => _broadAreaDrilldownTypes.contains(item.type)) ?? false,
        _ => false,
      },
    );
    if (hasBroadAreaType) {
      return false;
    }
    return types.isNotEmpty;
  }
}

extension TradeLicenseMessageExt on TradeLicenseMessage {
  Map<String, dynamic> toJson() => {
    'type': type,
    'license': license,
    'legalForm': legalForm,
    'endDate': endDate,
  };

  static TradeLicenseMessage? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    return TradeLicenseMessage(
      type: json['type'] ?? '',
      license: json['license'],
      legalForm: json['legalForm'] ?? '',
      endDate: json['endDate'] ?? '',
    );
  }
}

extension OrgInfoMessageExt on OrgInfoMessage {
  Map<String, dynamic> toJson() => {
    'id': id,
    'branchCount': branchCount,
    'name': name,
  };

  static OrgInfoMessage fromJson(Map<String, dynamic> json) => OrgInfoMessage(
    id: json['id'],
    branchCount: json['branchCount'],
    name: json['name'],
  );
}

extension EntranceInfoMessageExt on EntranceInfoMessage {
  Map<String, dynamic> toJson() {
    final geometryJson = geometry?.toJson();
    return {
      'id': id.toJson(),
      'buildingNumber': buildingNumber,
      'porchName': porchName,
      'porchNumber': porchNumber,
      'apartmentRanges': apartmentRanges.map((item) => item?.toJson()).nonNulls.toList(),
      'geometry': geometryJson,
    };
  }

  static EntranceInfoMessage fromJson(Map<String, dynamic>? json) => EntranceInfoMessage(
    id: DgisObjectIdMessageExt.fromJson(json?['id']),
    buildingNumber: json?['buildingNumber'],
    porchName: json?['porchName'],
    porchNumber: json?['porchNumber'],
    apartmentRanges: (json?['apartmentRanges'] as List)
        .map((e) => e == null ? null : ApartmentRangeMessageExtension.fromJson(e))
        .toList(),
    geometry: json?['geometry'] == null ? null : EntranceGeometryMessageExtension.fromJson(json?['geometry']),
  );
}

extension DgisObjectIdMessageExt on DgisObjectIdMessage {
  Map<String, dynamic> toJson() => {
    'objectId': objectId,
    'entranceId': entranceId,
  };

  static DgisObjectIdMessage fromJson(Map<String, dynamic> json) => DgisObjectIdMessage(
    objectId: json['objectId'],
    entranceId: json['entranceId'],
  );
}

extension GeoPointWithElevationMessageExt on GeoPointWithElevationMessage {
  static GeoPointWithElevationMessage fromJson(Map<String, dynamic> json) => GeoPointWithElevationMessage(
    latitude: json['latitude'] as double,
    longitude: json['longitude'] as double,
    elevation: json['elevation'] as double,
  );

  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
    'elevation': elevation,
  };
}

extension ObjectTypeItemMessageExt on ObjectTypeItemMessage {
  Map<String, dynamic> toJson() => {
    'type': type.toString().split('.').last,
  };

  static ObjectTypeItemMessage fromJson(Map<String, dynamic> json) => ObjectTypeItemMessage(
    type: _parseObjectType(json['type']),
  );

  static ObjectTypeMessage _parseObjectType(String value) {
    switch (value) {
      case 'admDiv':
        return ObjectTypeMessage.admDiv;
      case 'attraction':
        return ObjectTypeMessage.attraction;
      case 'branch':
        return ObjectTypeMessage.branch;
      case 'building':
        return ObjectTypeMessage.building;
      case 'coordinates':
        return ObjectTypeMessage.coordinates;
      case 'crossroad':
        return ObjectTypeMessage.crossroad;
      case 'parking':
        return ObjectTypeMessage.parking;
      case 'road':
        return ObjectTypeMessage.road;
      case 'route':
        return ObjectTypeMessage.route;
      case 'station':
        return ObjectTypeMessage.station;
      case 'stationEntrance':
        return ObjectTypeMessage.stationEntrance;
      case 'street':
        return ObjectTypeMessage.street;
      case 'unknown':
        return ObjectTypeMessage.unknown;
      default:
        throw ArgumentError('Unknown ObjectTypeMessage value: $value');
    }
  }
}

extension AddressMessageExt on AddressMessage {
  Map<String, dynamic> toJson() => {
    'drilldown': drilldown.map((item) => item.toJson()).toList(),
    'components': components.map((item) => item.toJson()).toList(),
    'buildingName': buildingName,
    'postCode': postCode,
    'buildingCode': buildingCode,
    'addressComment': addressComment,
  };

  static AddressMessage fromJson(Map<String, dynamic> json) => AddressMessage(
    drilldown: (json['drilldown'] as List<dynamic>?)!
        .map((e) => AddressAdmDivMessageExtension.fromJson(e as Map<String, dynamic>))
        .toList(),
    components: (json['components'] as List<dynamic>?)!
        .map((e) => AddressComponentMessageExtension.fromJson(e as Map<String, dynamic>))
        .toList(),
    buildingName: json['buildingName'] as String?,
    postCode: json['postCode'] as String?,
    buildingCode: json['buildingCode'] as String?,
    addressComment: json['addressComment'] as String?,
  );
}

extension AddressAdmDivMessageExtension on AddressAdmDivMessage {
  Map<String, dynamic> toJson() => {
    'type': type,
    'name': name,
  };

  static AddressAdmDivMessage fromJson(Map<String, dynamic> json) => AddressAdmDivMessage(
    type: json['type'] as String,
    name: json['name'] as String,
  );
}

extension AddressComponentMessageExtension on AddressComponentMessage {
  Map<String, dynamic> toJson() => {
    'streetAddress': streetAddress?.toJson(),
    'number': number?.toJson(),
    'location': location?.toJson(),
  };

  static AddressComponentMessage fromJson(Map<String, dynamic> json) => AddressComponentMessage(
    streetAddress: json['streetAddress'] != null
        ? AddressStreetMessageExtension.fromJson(json['streetAddress'] as Map<String, dynamic>)
        : null,
    number: json['number'] != null
        ? AddressNumberMessageExtension.fromJson(json['number'] as Map<String, dynamic>)
        : null,
    location: json['location'] != null
        ? AddressLocationMessageExtension.fromJson(json['location'] as Map<String, dynamic>)
        : null,
  );
}

extension AddressStreetMessageExtension on AddressStreetMessage {
  Map<String, dynamic> toJson() => {
    'street': street,
    'number': number,
  };

  static AddressStreetMessage fromJson(Map<String, dynamic> json) => AddressStreetMessage(
    street: json['street'] as String,
    number: json['number'] as String,
  );
}

extension AddressNumberMessageExtension on AddressNumberMessage {
  Map<String, dynamic> toJson() => {
    'number': number,
  };

  static AddressNumberMessage fromJson(Map<String, dynamic> json) => AddressNumberMessage(
    number: json['number'] as String,
  );
}

extension AddressLocationMessageExtension on AddressLocationMessage {
  Map<String, dynamic> toJson() => {
    'comment': comment,
  };

  static AddressLocationMessage fromJson(Map<String, dynamic> json) => AddressLocationMessage(
    comment: json['comment'] as String,
  );
}

extension GeoPointMessageExtension on GeoPointMessage {
  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
  };

  static GeoPointMessage fromJson(Map<String, dynamic> json) => GeoPointMessage(
    latitude: json['latitude'] as double,
    longitude: json['longitude'] as double,
  );
}

extension EntranceGeometryMessageExtension on EntranceGeometryMessage {
  Map<String, dynamic> toJson() {
    final entrancePointsList = entrancePoints.map((point) {
      final json = point.toJson();
      return json;
    }).toList();

    return {
      'entrancePoints': entrancePointsList,
      'entrancePolylines': [],
    };
  }

  static EntranceGeometryMessage fromJson(Map<String, dynamic> json) {
    final entrancePoints = (json['entrancePoints'] as List<dynamic>?)!
        .map((point) => GeoPointMessageExtension.fromJson(point as Map<String, dynamic>))
        .toList();

    final json2 = json['entrancePolylines'] as List<dynamic>?;
    final entrancePolylines = json2?.map<PolylineGeometryMessage>((polyline) {
      final points = (polyline as List<dynamic>)
          .map((point) => GeoPointMessageExtension.fromJson(point as Map<String, dynamic>))
          .toList();
      return PolylineGeometryMessage(points: points);
    }).toList();

    return EntranceGeometryMessage(
      entrancePoints: entrancePoints,
      entrancePolylines: entrancePolylines ?? [],
    );
  }
}

extension FormattedAddressMessageExtension on FormattedAddressMessage {
  Map<String, dynamic> toJson() => {
    'drilldownAddress': drilldownAddress,
    'streetAddress': streetAddress,
    'addressComment': addressComment,
    'postCode': postCode,
  };

  static FormattedAddressMessage fromJson(Map<String, dynamic>? json) => FormattedAddressMessage(
    drilldownAddress: json?['drilldownAddress'] as String?,
    streetAddress: json?['streetAddress'] as String?,
    addressComment: json?['addressComment'] as String?,
    postCode: json?['postCode'] as String?,
  );
}

extension AttributeMessageExtension on AttributeMessage {
  Map<String, dynamic> toJson() => {
    'tag': tag,
    'value': value,
  };

  static AttributeMessage fromJson(Map<String, dynamic>? json) => AttributeMessage(
    tag: json?['tag'] as String,
    value: json?['value'] as String,
  );
}

extension OpeningHoursMessageExtension on OpeningHoursMessage {
  Map<String, dynamic> toJson() => {
    'values': values.map((item) => item.toJson()).toList(),
    'isOpen24x7': isOpen24x7,
  };

  static OpeningHoursMessage fromJson(Map<String, dynamic> json) => OpeningHoursMessage(
    values: (json['values'] as List<dynamic>?)!
        .map((item) => WeekTimeIntervalListMessageExtension.fromJson(item as Map<String, dynamic>))
        .toList(),
    isOpen24x7: json['isOpen24x7'] as bool,
  );
}

extension WeekTimeIntervalListMessageExtension on WeekTimeIntervalListMessage {
  Map<String, dynamic> toJson() => {
    'values': values.map((item) => item.toJson()).toList(),
  };

  static WeekTimeIntervalListMessage fromJson(Map<String, dynamic> json) => WeekTimeIntervalListMessage(
    values: (json['values'] as List<dynamic>?)!
        .map((item) => WeekTimeIntervalMessageExtension.fromJson(item as Map<String, dynamic>))
        .toList(),
  );
}

extension WeekTimeIntervalMessageExtension on WeekTimeIntervalMessage {
  Map<String, dynamic> toJson() => {
    'startTime': startTime.toJson(),
    'finishTime': finishTime.toJson(),
  };

  static WeekTimeIntervalMessage fromJson(Map<String, dynamic> json) => WeekTimeIntervalMessage(
    startTime: WeekTimeMessageExtension.fromJson(json['startTime'] as Map<String, dynamic>),
    finishTime: WeekTimeMessageExtension.fromJson(json['finishTime'] as Map<String, dynamic>),
  );
}

extension WeekTimeMessageExtension on WeekTimeMessage {
  Map<String, dynamic> toJson() => {
    'weekDay': weekDay.toJson(),
    'time': time.toJson(),
  };

  static WeekTimeMessage fromJson(Map<String, dynamic> json) => WeekTimeMessage(
    weekDay: WeekDayMessageExtension.fromJson(json['weekDay'] as String),
    time: DayTimeMessageExtension.fromJson(json['time'] as Map<String, dynamic>),
  );
}

extension WeekDayMessageExtension on WeekDayMessage {
  String toJson() {
    switch (this) {
      case WeekDayMessage.monday:
        return 'monday';
      case WeekDayMessage.tuesday:
        return 'tuesday';
      case WeekDayMessage.wednesday:
        return 'wednesday';
      case WeekDayMessage.thursday:
        return 'thursday';
      case WeekDayMessage.friday:
        return 'friday';
      case WeekDayMessage.saturday:
        return 'saturday';
      case WeekDayMessage.sunday:
        return 'sunday';
    }
  }

  static WeekDayMessage fromJson(String value) {
    switch (value) {
      case 'monday':
        return WeekDayMessage.monday;
      case 'tuesday':
        return WeekDayMessage.tuesday;
      case 'wednesday':
        return WeekDayMessage.wednesday;
      case 'thursday':
        return WeekDayMessage.thursday;
      case 'friday':
        return WeekDayMessage.friday;
      case 'saturday':
        return WeekDayMessage.saturday;
      case 'sunday':
        return WeekDayMessage.sunday;
      default:
        throw ArgumentError('Invalid WeekDayMessage value: $value');
    }
  }
}

extension DayTimeMessageExtension on DayTimeMessage {
  Map<String, dynamic> toJson() => {
    'hours': hours,
    'minutes': minutes,
  };

  static DayTimeMessage fromJson(Map<String, dynamic> json) => DayTimeMessage(
    hours: json['hours'] as int,
    minutes: json['minutes'] as int,
  );
}

extension ContactInfoMessageExtension on ContactInfoMessage {
  Map<String, dynamic> toJson() => {
    'type': type,
    'displayText': displayText,
    'value': value,
    'comment': comment,
  };

  static ContactInfoMessage fromJson(Map<String, dynamic>? json) => ContactInfoMessage(
    type: json?['type'] as String,
    displayText: json?['displayText'] as String,
    value: json?['value'] as String,
    comment: json?['comment'] as String?,
  );
}

extension ReviewsMessageExtension on ReviewsMessage {
  Map<String, dynamic> toJson() => {
    'rating': rating,
    'count': count,
  };

  static ReviewsMessage fromJson(Map<String, dynamic>? json) => ReviewsMessage(
    rating: json?['rating'] as double,
    count: json?['count'] as int,
  );
}

extension ParkingInfoMessageExtension on ParkingInfoMessage {
  Map<String, dynamic> toJson() => {
    'type': type.toJson(),
    'purpose': purpose.toJson(),
    'access': access.toJson(),
    'pavingType': pavingType.toJson(),
    'isPaid': isPaid,
    'isIncentive': isIncentive,
    'forTrucks': forTrucks,
    'levelCount': levelCount,
    'capacity': capacity?.toJson(),
  };

  static ParkingInfoMessage fromJson(Map<String, dynamic> json) => ParkingInfoMessage(
    type: ParkingTypeMessageExtension.fromJson(json['type'] as String),
    purpose: ParkingPurposeMessageExtension.fromJson(json['purpose'] as String),
    access: ParkingAccessMessageExtension.fromJson(json['access'] as String),
    pavingType: ParkingPavingTypeMessageExtension.fromJson(json['pavingType'] as String),
    isPaid: json['isPaid'] as bool,
    isIncentive: json['isIncentive'] as bool,
    forTrucks: json['forTrucks'] as bool,
    levelCount: json['levelCount'] as int?,
    capacity: json['capacity'] != null
        ? ParkingCapacityMessageExtension.fromJson(json['capacity'] as Map<String, dynamic>)
        : null,
  );
}

extension WorkStatusMessageExtension on WorkStatusMessage {
  Map<String, dynamic> toJson() => {
    'isOpen': isOpen,
    'desc': desc,
  };

  static WorkStatusMessage fromJson(Map<String, dynamic> json) => WorkStatusMessage(
    isOpen: json['isOpen'] as bool,
    desc: json['desc'] as String,
  );
}

extension BuildingLevelsMessageExtension on BuildingLevelsMessage {
  Map<String, dynamic> toJson() => {
    'defaultLevelId': defaultLevelId,
    'levels': levels.map((level) => level.toJson()).toList(),
  };

  static BuildingLevelsMessage fromJson(Map<String, dynamic>? json) => BuildingLevelsMessage(
    defaultLevelId: json?['defaultLevelId'] as int,
    levels: (json?['levels'] as List<dynamic>?)!
        .map((level) => LevelInfoMessageExtension.fromJson(level as Map<String, dynamic>))
        .toList(),
  );
}

extension BuildingInfoMessageExtension on BuildingInfoMessage {
  Map<String, dynamic> toJson() => {
    'buildingName': buildingName,
    'purposeName': purposeName,
    'purposeCode': purposeCode,
  };

  static BuildingInfoMessage fromJson(Map<String, dynamic> json) => BuildingInfoMessage(
    buildingName: json['buildingName'] as String?,
    purposeName: json['purposeName'] as String?,
    purposeCode: json['purposeCode'] as int?,
  );
}

extension ApartmentRangeMessageExtension on ApartmentRangeMessage {
  Map<String, dynamic> toJson() => {
    'start': start,
    'end': end,
  };

  static ApartmentRangeMessage fromJson(Map<String, dynamic> json) => ApartmentRangeMessage(
    start: json['start'] as String,
    end: json['end'] as String?,
  );
}

extension LevelInfoMessageExtension on LevelInfoMessage {
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };

  static LevelInfoMessage fromJson(Map<String, dynamic> json) => LevelInfoMessage(
    id: json['id'] as int,
    name: json['name'] as String,
  );
}

extension ParkingCapacityMessageExtension on ParkingCapacityMessage {
  Map<String, dynamic> toJson() => {
    'total': total,
    'specialSpaces': specialSpaces.map((space) => space.toJson()).toList(),
  };

  static ParkingCapacityMessage fromJson(Map<String, dynamic> json) => ParkingCapacityMessage(
    total: json['total'] as String?,
    specialSpaces: (json['specialSpaces'] as List<dynamic>?)!
        .map((space) => SpecialSpaceMessageExtension.fromJson(space as Map<String, dynamic>))
        .toList(),
  );
}

extension SpecialSpaceMessageExtension on SpecialSpaceMessage {
  Map<String, dynamic> toJson() => {
    'type': type.toJson(),
    'name': name,
    'count': count,
  };

  static SpecialSpaceMessage fromJson(Map<String, dynamic> json) => SpecialSpaceMessage(
    type: SpecialSpaceTypeMessageExtension.fromJson(json['type'] as String),
    name: json['name'] as String,
    count: json['count'] as String?,
  );
}

extension SpecialSpaceTypeMessageExtension on SpecialSpaceTypeMessage {
  String toJson() {
    switch (this) {
      case SpecialSpaceTypeMessage.bicycle:
        return 'bicycle';
      case SpecialSpaceTypeMessage.motorbike:
        return 'motorbike';
      case SpecialSpaceTypeMessage.family:
        return 'family';
      case SpecialSpaceTypeMessage.handicapped:
        return 'handicapped';
      case SpecialSpaceTypeMessage.babyCarriage:
        return 'babyCarriage';
      case SpecialSpaceTypeMessage.truck:
        return 'truck';
      case SpecialSpaceTypeMessage.scooter:
        return 'scooter';
    }
  }

  static SpecialSpaceTypeMessage fromJson(String value) {
    switch (value) {
      case 'bicycle':
        return SpecialSpaceTypeMessage.bicycle;
      case 'motorbike':
        return SpecialSpaceTypeMessage.motorbike;
      case 'family':
        return SpecialSpaceTypeMessage.family;
      case 'handicapped':
        return SpecialSpaceTypeMessage.handicapped;
      case 'babyCarriage':
        return SpecialSpaceTypeMessage.babyCarriage;
      case 'truck':
        return SpecialSpaceTypeMessage.truck;
      case 'scooter':
        return SpecialSpaceTypeMessage.scooter;
      default:
        throw ArgumentError('Invalid SpecialSpaceTypeMessage value: $value');
    }
  }
}

extension ParkingPurposeMessageExtension on ParkingPurposeMessage {
  String toJson() {
    switch (this) {
      case ParkingPurposeMessage.car:
        return 'car';
      case ParkingPurposeMessage.bike:
        return 'bike';
      case ParkingPurposeMessage.motorbike:
        return 'motorbike';
      case ParkingPurposeMessage.babyCarriage:
        return 'babyCarriage';
      case ParkingPurposeMessage.scooter:
        return 'scooter';
    }
  }

  static ParkingPurposeMessage fromJson(String value) {
    switch (value) {
      case 'car':
        return ParkingPurposeMessage.car;
      case 'bike':
        return ParkingPurposeMessage.bike;
      case 'motorbike':
        return ParkingPurposeMessage.motorbike;
      case 'babyCarriage':
        return ParkingPurposeMessage.babyCarriage;
      case 'scooter':
        return ParkingPurposeMessage.scooter;
      default:
        throw ArgumentError('Invalid ParkingPurposeMessage value: $value');
    }
  }
}

extension ParkingAccessMessageExtension on ParkingAccessMessage {
  String toJson() {
    switch (this) {
      case ParkingAccessMessage.publicAccess:
        return 'public';
      case ParkingAccessMessage.handicappedOnly:
        return 'handicappedOnly';
      case ParkingAccessMessage.customersOnly:
        return 'customersOnly';
      case ParkingAccessMessage.residentsOnly:
        return 'residentsOnly';
      case ParkingAccessMessage.taxiOnly:
        return 'taxiOnly';
    }
  }

  static ParkingAccessMessage fromJson(String value) {
    switch (value) {
      case 'public':
        return ParkingAccessMessage.publicAccess;
      case 'handicappedOnly':
        return ParkingAccessMessage.handicappedOnly;
      case 'customersOnly':
        return ParkingAccessMessage.customersOnly;
      case 'residentsOnly':
        return ParkingAccessMessage.residentsOnly;
      case 'taxiOnly':
        return ParkingAccessMessage.taxiOnly;
      default:
        throw ArgumentError('Invalid ParkingAccessMessage value: $value');
    }
  }
}

extension ParkingPavingTypeMessageExtension on ParkingPavingTypeMessage {
  String toJson() {
    switch (this) {
      case ParkingPavingTypeMessage.asphalt:
        return 'asphalt';
      case ParkingPavingTypeMessage.concrete:
        return 'concrete';
      case ParkingPavingTypeMessage.gravel:
        return 'gravel';
      case ParkingPavingTypeMessage.unpaved:
        return 'unpaved';
      case ParkingPavingTypeMessage.none:
        return 'none';
    }
  }

  static ParkingPavingTypeMessage fromJson(String value) {
    switch (value) {
      case 'asphalt':
        return ParkingPavingTypeMessage.asphalt;
      case 'concrete':
        return ParkingPavingTypeMessage.concrete;
      case 'gravel':
        return ParkingPavingTypeMessage.gravel;
      case 'unpaved':
        return ParkingPavingTypeMessage.unpaved;
      case 'none':
        return ParkingPavingTypeMessage.none;
      default:
        throw ArgumentError('Invalid ParkingPavingTypeMessage value: $value');
    }
  }
}

extension ParkingTypeMessageExtension on ParkingTypeMessage {
  String toJson() => toString().split('.').last;

  static ParkingTypeMessage fromJson(String json) => ParkingTypeMessage.values.firstWhere(
    (e) => e.toString().split('.').last == json,
    orElse: () => ParkingTypeMessage.none,
  );
}

extension PublicTransportDirectoryRouteInfoMessageExt on PublicTransportDirectoryRouteInfoMessage {
  Map<String, dynamic> toJson() => {
    'id': id.toJson(),
    'name': name,
    'color': color,
    'fromToStationNames': fromToStationNames?.toJson(),
    'directions': directions.map((e) => e.toJson()).toList(),
  };

  static PublicTransportDirectoryRouteInfoMessage fromJson(Map<String, dynamic> json) =>
      PublicTransportDirectoryRouteInfoMessage(
        id: DgisObjectIdMessageExt.fromJson(json['id'] as Map<String, dynamic>),
        name: json['name'] as String,
        color: json['color'] as int?,
        fromToStationNames: json['fromToStationNames'] != null
            ? PublicTransportDirectoryRouteDirectionNamesInfoMessageExt.fromJson(
                json['fromToStationNames'] as Map<String, dynamic>,
              )
            : null,
        directions:
            (json['directions'] as List<dynamic>?)
                ?.map((e) => PublicTransportRouteDirectionMessageExt.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );
}

extension PublicTransportDirectoryRouteDirectionNamesInfoMessageExt
    on PublicTransportDirectoryRouteDirectionNamesInfoMessage {
  Map<String, dynamic> toJson() => {
    'fromName': fromName,
    'toName': toName,
  };

  static PublicTransportDirectoryRouteDirectionNamesInfoMessage fromJson(Map<String, dynamic> json) =>
      PublicTransportDirectoryRouteDirectionNamesInfoMessage(
        fromName: json['fromName'] as String,
        toName: json['toName'] as String,
      );
}

extension PublicTransportRouteDirectionMessageExt on PublicTransportRouteDirectionMessage {
  Map<String, dynamic> toJson() => {
    'id': id.toJson(),
    'type': type.toString().split('.').last,
    'geometry': geometry?.toJson(),
    'platforms': platforms.map((e) => e.toJson()).toList(),
  };

  static PublicTransportRouteDirectionMessage fromJson(Map<String, dynamic> json) =>
      PublicTransportRouteDirectionMessage(
        id: PublicTransportRouteDirectionIdMessageExt.fromJson(json['id'] as Map<String, dynamic>),
        type: PublicTransportRouteDirectionTypeMessage.values.firstWhere(
          (e) => e.toString().split('.').last == json['type'],
        ),
        geometry: json['geometry'] != null
            ? PublicTransportRouteGeometryMessageExt.fromJson(json['geometry'] as Map<String, dynamic>)
            : null,
        platforms:
            (json['platforms'] as List<dynamic>?)
                ?.map((e) => PublicTransportPlatformMessageExt.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );
}

extension PublicTransportRouteDirectionIdMessageExt on PublicTransportRouteDirectionIdMessage {
  Map<String, dynamic> toJson() => {
    'value': value,
  };

  static PublicTransportRouteDirectionIdMessage fromJson(Map<String, dynamic> json) =>
      PublicTransportRouteDirectionIdMessage(
        value: json['value'] as int,
      );
}

extension PublicTransportRouteGeometryMessageExt on PublicTransportRouteGeometryMessage {
  Map<String, dynamic> toJson() => {
    'line': line.toJson(),
    'centroid': centroid?.toJson(),
  };

  static PublicTransportRouteGeometryMessage fromJson(Map<String, dynamic> json) => PublicTransportRouteGeometryMessage(
    line: PolylineGeometryMessageExt.fromJson(json['line'] as Map<String, dynamic>),
    centroid: json['centroid'] != null
        ? GeoPointMessageExtension.fromJson(json['centroid'] as Map<String, dynamic>)
        : null,
  );
}

extension PolylineGeometryMessageExt on PolylineGeometryMessage {
  Map<String, dynamic> toJson() => {
    'points': points.map((e) => e.toJson()).toList(),
  };

  static PolylineGeometryMessage fromJson(Map<String, dynamic> json) => PolylineGeometryMessage(
    points:
        (json['points'] as List<dynamic>?)
            ?.map((e) => GeoPointMessageExtension.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
  );
}

extension PublicTransportPlatformMessageExt on PublicTransportPlatformMessage {
  Map<String, dynamic> toJson() => {
    'id': id.toJson(),
    'stationId': stationId.toJson(),
    'name': name,
    'description': description,
    'transitions': transitions.map((e) => e.toJson()).toList(),
    'position': position?.toJson(),
  };

  static PublicTransportPlatformMessage fromJson(Map<String, dynamic> json) => PublicTransportPlatformMessage(
    id: DgisObjectIdMessageExt.fromJson(json['id'] as Map<String, dynamic>),
    stationId: DgisObjectIdMessageExt.fromJson(json['stationId'] as Map<String, dynamic>),
    name: json['name'] as String,
    description: json['description'] as String?,
    transitions:
        (json['transitions'] as List<dynamic>?)
            ?.map((e) => PublicTransportPlatformTransitionMessageExt.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    position: json['position'] != null
        ? GeoPointMessageExtension.fromJson(json['position'] as Map<String, dynamic>)
        : null,
  );
}

extension PublicTransportPlatformTransitionMessageExt on PublicTransportPlatformTransitionMessage {
  Map<String, dynamic> toJson() => {
    'routeId': routeId.toJson(),
    'routeName': routeName,
    'routeType': routeType.toString().split('.').last,
    'color': color,
    'stationId': stationId.toJson(),
    'stationName': stationName,
  };

  static PublicTransportPlatformTransitionMessage fromJson(Map<String, dynamic> json) =>
      PublicTransportPlatformTransitionMessage(
        routeId: DgisObjectIdMessageExt.fromJson(json['routeId'] as Map<String, dynamic>),
        routeName: json['routeName'] as String,
        routeType: PublicTransportRouteTypeMessage.values.firstWhere(
          (e) => e.toString().split('.').last == json['routeType'],
        ),
        color: json['color'] as int?,
        stationId: DgisObjectIdMessageExt.fromJson(json['stationId'] as Map<String, dynamic>),
        stationName: json['stationName'] as String,
      );
}

extension GroupItemMessageExt on GroupItemMessage {
  Map<String, dynamic> toJson() => {
    'id': DgisObjectIdMessageExt(id).toJson(),
    'type': type.toString().split('.').last,
  };

  static GroupItemMessage fromJson(Map<String, dynamic> json) => GroupItemMessage(
    id: DgisObjectIdMessageExt.fromJson(json['id'] as Map<String, dynamic>),
    type: ObjectTypeMessage.values.firstWhere((e) => e.toString().split('.').last == json['type']),
  );
}
