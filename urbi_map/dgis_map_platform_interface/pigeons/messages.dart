// ignore_for_file: avoid_positional_boolean_parameters, camel_case_types

import 'package:pigeon/pigeon.dart';

enum ZoomControlMessage { zoomIn, zoomOut }

class InitializeMessage {
  InitializeMessage(this.wasInitialized, this.errorDescription);

  final bool wasInitialized;
  final String errorDescription;
}

class GeoPointMessage {
  GeoPointMessage(this.latitude, this.longitude);

  final double latitude;
  final double longitude;
}

class ScreenSizeMessage {
  ScreenSizeMessage(this.width, this.height);

  final int width;
  final int height;
}

class CalcPositionOptionsMessage {
  CalcPositionOptionsMessage(this.screenArea, this.tilt, this.bearing, this.size);

  final CameraSetPaddingMessage? screenArea;
  final double? tilt;
  final double? bearing;
  final ScreenSizeMessage? size;
}

/// A point in a geographic coordinate system (latitude, longitude, elevation).
/// elevation (Elevation) in meters above the surface, not above sea level.
class GeoPointWithElevationMessage {
  GeoPointWithElevationMessage(this.latitude, this.longitude, this.elevation);

  final double latitude;
  final double longitude;
  final double elevation;
}

class CameraPositionMessage {
  CameraPositionMessage(this.point, this.zoom, this.tilt, this.bearing);

  final GeoPointMessage point;
  final double zoom;
  final double tilt;
  final double bearing;
}

class CameraPositionPointMessage {
  CameraPositionPointMessage(this.x, this.y);

  final double x;
  final double y;
}

enum CameraAnimationTypeMessage { defaultType, linear, showBothPositions }

class DgisObjectIdMessage {
  const DgisObjectIdMessage({required this.objectId, required this.entranceId});

  final int objectId;
  final int entranceId;
}

class WorkStatusMessage {
  WorkStatusMessage(this.isOpen, this.desc);

  final bool isOpen;
  final String desc;
}

class DayTimeMessage {
  const DayTimeMessage(this.hours, this.minutes);

  final int hours;
  final int minutes;
}

enum WeekDayMessage { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

class WeekTimeMessage {
  const WeekTimeMessage({required this.weekDay, required this.time});

  final WeekDayMessage weekDay;
  final DayTimeMessage time;
}

class WeekTimeIntervalMessage {
  const WeekTimeIntervalMessage(this.startTime, this.finishTime);

  final WeekTimeMessage startTime;
  final WeekTimeMessage finishTime;
}

class WeekTimeIntervalListMessage {
  WeekTimeIntervalListMessage(this.values);

  final List<WeekTimeIntervalMessage> values;
}

class OpeningHoursMessage {
  const OpeningHoursMessage(this.values, this.isOpen24x7);

  final List<WeekTimeIntervalListMessage> values;
  final bool isOpen24x7;
}

class AddressAdmDivMessage {
  AddressAdmDivMessage(this.type, this.name);

  final String type;
  final String name;
}

class AddressStreetMessage {
  AddressStreetMessage(this.street, this.number);

  final String street;
  final String number;
}

class AddressNumberMessage {
  AddressNumberMessage(this.number);

  final String number;
}

class AddressLocationMessage {
  AddressLocationMessage(this.comment);

  final String comment;
}

class AddressComponentMessage {
  AddressComponentMessage(this.streetAddress, this.number, this.location);

  final AddressStreetMessage? streetAddress;
  final AddressNumberMessage? number;
  final AddressLocationMessage? location;
}

class AddressMessage {
  AddressMessage(
    this.drilldown,
    this.components,
    this.buildingName,
    this.postCode,
    this.buildingCode,
    this.addressComment,
  );

  final List<AddressAdmDivMessage> drilldown;
  final List<AddressComponentMessage> components;
  final String? buildingName;
  final String? postCode;
  final String? buildingCode;
  final String? addressComment;
}

class FormattedAddressMessage {
  FormattedAddressMessage(this.drilldownAddress, this.streetAddress, this.addressComment, this.postCode);

  final String? drilldownAddress;
  final String? streetAddress;
  final String? addressComment;
  final String? postCode;
}

class AttributeMessage {
  AttributeMessage(this.tag, this.value);

  final String tag;
  final String value;
}

class ContactInfoMessage {
  ContactInfoMessage(this.type, this.displayText, this.value, this.comment);

  final String type;
  final String displayText;
  final String value;
  final String? comment;
}

class ReviewsMessage {
  ReviewsMessage(this.rating, this.count);

  final double rating;
  final int count;
}

enum ParkingTypeMessage { ground, underground, multilevel, none }

enum ParkingPurposeMessage { car, bike, motorbike, babyCarriage, scooter }

enum ParkingAccessMessage { publicAccess, handicappedOnly, customersOnly, residentsOnly, taxiOnly }

enum ParkingPavingTypeMessage { asphalt, concrete, gravel, unpaved, none }

enum SpecialSpaceTypeMessage { bicycle, motorbike, family, handicapped, babyCarriage, truck, scooter }

class SpecialSpaceMessage {
  SpecialSpaceMessage(this.type, this.name, this.count);

  final SpecialSpaceTypeMessage type;
  final String name;
  final String? count;
}

class ParkingCapacityMessage {
  ParkingCapacityMessage(this.total, this.specialSpaces);

  final String? total;
  final List<SpecialSpaceMessage> specialSpaces;
}

class ParkingInfoMessage {
  ParkingInfoMessage(
    this.type,
    this.purpose,
    this.access,
    this.pavingType,
    this.isPaid,
    this.isIncentive,
    this.forTrucks,
    this.levelCount,
    this.capacity,
  );

  final ParkingTypeMessage type;
  final ParkingPurposeMessage purpose;
  final ParkingAccessMessage access;
  final ParkingPavingTypeMessage pavingType;
  final bool isPaid;
  final bool isIncentive;
  final bool forTrucks;
  final int? levelCount;
  final ParkingCapacityMessage? capacity;
}

class LevelInfoMessage {
  LevelInfoMessage(this.id, this.name);

  final int id;
  final String name;
}

class BuildingLevelsMessage {
  BuildingLevelsMessage(this.defaultLevelId, this.levels);

  final int defaultLevelId;
  final List<LevelInfoMessage> levels;
}

class BuildingInfoMessage {
  BuildingInfoMessage(this.buildingName, this.purposeName, this.purposeCode);

  final String? buildingName;
  final String? purposeName;
  final int? purposeCode;
}

class ApartmentRangeMessage {
  ApartmentRangeMessage(this.start, this.end);

  final String start;
  final String? end;
}

class EntranceGeometryMessage {
  EntranceGeometryMessage(this.entrancePoints, this.entrancePolylines);

  final List<GeoPointMessage> entrancePoints;
  final List<PolylineGeometryMessage> entrancePolylines;
}

class EntranceInfoMessage {
  EntranceInfoMessage(
    this.id,
    this.buildingNumber,
    this.porchName,
    this.porchNumber,
    this.apartmentRanges,
    this.geometry,
  );

  final DgisObjectIdMessage id;
  final String? buildingNumber;
  final String? porchName;
  final String? porchNumber;
  final List<ApartmentRangeMessage?> apartmentRanges;
  final EntranceGeometryMessage? geometry;
}

enum ObjectTypeMessage {
  admDiv,
  admDivCity,
  admDivCountry,
  admDivDistrict,
  admDivDistrictArea,
  admDivDivision,
  admDivLivingArea,
  admDivPlace,
  admDivRegion,
  admDivSettlement,
  attraction,
  branch,
  building,
  coordinates,
  crossroad,
  gate,
  kilometerRoadSign,
  parking,
  road,
  route,
  station,
  stationEntrance,
  stationMetro,
  stationPlatform,
  street,
  unknown,
}

class ObjectTypeItemMessage {
  ObjectTypeItemMessage(this.type);

  final ObjectTypeMessage type;
}

class TradeLicenseMessage {
  TradeLicenseMessage(this.type, this.license, this.legalForm, this.endDate);

  final String type;
  final String license;
  final String legalForm;
  final String endDate;
}

class GroupItemMessage {
  GroupItemMessage({required this.id, required this.type});

  final DgisObjectIdMessage id;
  final ObjectTypeMessage type;
}

class OrgInfoMessage {
  OrgInfoMessage({required this.id, required this.branchCount, this.name});

  final int branchCount;
  final int id;
  final String? name;
}

class DirectoryObjectMessage {
  DirectoryObjectMessage(
    this.types,
    this.title,
    this.titleAddition,
    this.about,
    this.subtitle,
    this.description,
    this.id,
    this.markerPosition,
    this.address,
    this.fullAddressName,
    this.shortAddressName,
    this.attributes,
    this.contextAttributes,
    this.timeZoneOffset,
    this.openingHours,
    this.contactInfos,
    this.reviews,
    this.parkingInfo,
    this.workStatus,
    this.levelId,
    this.buildingLevels,
    this.buildingInfo,
    this.entrances,
    this.tradeLicense,
    this.rubricIds,
    this.orgInfo,
    this.routeInfos,
    this.group,
    this.platformIds,
  );

  final List<ObjectTypeItemMessage> types;
  final String title;
  final String titleAddition;
  final String subtitle;
  final String about;
  final String? description;
  final DgisObjectIdMessage? id;
  final GeoPointWithElevationMessage? markerPosition;
  final AddressMessage? address;
  final FormattedAddressMessage? fullAddressName;
  final FormattedAddressMessage? shortAddressName;
  final List<AttributeMessage> attributes;
  final List<AttributeMessage> contextAttributes;
  final double? timeZoneOffset;
  final OpeningHoursMessage? openingHours;
  final List<ContactInfoMessage> contactInfos;
  final ReviewsMessage? reviews;
  final ParkingInfoMessage? parkingInfo;
  final WorkStatusMessage? workStatus;
  final int? levelId;
  final BuildingLevelsMessage? buildingLevels;
  final List<EntranceInfoMessage> entrances;
  final TradeLicenseMessage? tradeLicense;
  final BuildingInfoMessage buildingInfo;
  final List<int> rubricIds;
  final OrgInfoMessage? orgInfo;
  final List<GroupItemMessage> group;
  final List<PublicTransportDirectoryRouteInfoMessage> routeInfos;
  final List<DgisObjectIdMessage> platformIds;
}

class PublicTransportDirectoryRouteDirectionNamesInfoMessage {
  PublicTransportDirectoryRouteDirectionNamesInfoMessage({required this.fromName, required this.toName});

  final String fromName;
  final String toName;
}

class PublicTransportRouteDirectionIdMessage {
  PublicTransportRouteDirectionIdMessage({required this.value});

  final int value;
}

enum PublicTransportRouteDirectionTypeMessage { forward, backward, additional, circular, loop }

enum PublicTransportRouteTypeMessage {
  bus,
  trolleybus,
  tram,
  shuttleBus,
  metro,
  suburbanTrain,
  funicularRailway,
  monorail,
  riverTransport,
  cableCar,
  lightRail,
  premetro,
  lightMetro,
  aeroexpress,
}

class PublicTransportPlatformTransitionMessage {
  PublicTransportPlatformTransitionMessage({
    required this.routeId,
    required this.routeName,
    required this.routeType,
    this.color,
    required this.stationId,
    required this.stationName,
  });

  final DgisObjectIdMessage routeId;
  final String routeName;
  final PublicTransportRouteTypeMessage routeType;
  final int? color;
  final DgisObjectIdMessage stationId;
  final String stationName;
}

class PolylineGeometryMessage {
  PolylineGeometryMessage({required this.points});

  final List<GeoPointMessage> points;
}

class PublicTransportRouteGeometryMessage {
  PublicTransportRouteGeometryMessage({required this.line, this.centroid});

  final PolylineGeometryMessage line;
  final GeoPointMessage? centroid;
}

class PublicTransportPlatformMessage {
  PublicTransportPlatformMessage({
    required this.id,
    required this.stationId,
    required this.name,
    this.description,
    required this.transitions,
    this.position,
  });

  final DgisObjectIdMessage id;
  final DgisObjectIdMessage stationId;
  final String name;
  final String? description;
  final List<PublicTransportPlatformTransitionMessage> transitions;
  final GeoPointMessage? position;
}

class PublicTransportRouteDirectionMessage {
  PublicTransportRouteDirectionMessage({required this.id, required this.type, this.geometry, required this.platforms});

  final PublicTransportRouteDirectionIdMessage id;
  final PublicTransportRouteDirectionTypeMessage type;
  final PublicTransportRouteGeometryMessage? geometry;
  final List<PublicTransportPlatformMessage> platforms;
}

class PublicTransportDirectoryRouteInfoMessage {
  PublicTransportDirectoryRouteInfoMessage({
    required this.id,
    required this.name,
    this.color,
    this.fromToStationNames,
    required this.directions,
  });

  final DgisObjectIdMessage id;
  final String name;
  final int? color;
  final PublicTransportDirectoryRouteDirectionNamesInfoMessage? fromToStationNames;
  final List<PublicTransportRouteDirectionMessage> directions;
}

class RouteDistanceMessage {
  const RouteDistanceMessage({required this.millimeters});

  final int millimeters;
}

class RoutePointMessage {
  const RoutePointMessage({required this.distance});

  final RouteDistanceMessage distance;
}

class PublicTransportInfoMessage {
  const PublicTransportInfoMessage({
    required this.type,
    required this.names,
    required this.suggestedCarNumbers,
    required this.boardingSuggest,
    required this.color,
    required this.routeLogo,
  });

  final PublicTransportRouteTypeMessage type;
  final List<String> names;
  final List<int> suggestedCarNumbers;
  final String boardingSuggest;
  final int? color;
  final String routeLogo;
}

class PublicTransportStopMessage {
  const PublicTransportStopMessage({required this.coordinates, required this.name});

  final GeoPointMessage coordinates;
  final String name;
}

class PublicRoutePartMessage {
  const PublicRoutePartMessage({required this.transports, required this.intermediateStops});

  final List<PublicTransportInfoMessage> transports;
  final List<PublicTransportStopMessage> intermediateStops;
}

class PublicTransportTransferMessage {
  const PublicTransportTransferMessage({
    required this.startPointName,
    required this.finishPointName,
    required this.routeParts,
  });

  final String startPointName;
  final String finishPointName;
  final List<PublicRoutePartMessage> routeParts;
}

class PublicTransportTransferRouteLongEntryMessage {
  const PublicTransportTransferRouteLongEntryMessage({required this.point, required this.length, required this.value});

  final RoutePointMessage point;
  final RouteDistanceMessage length;
  final PublicTransportTransferMessage value;
}

enum SortingTypeMessage { byRelevance, byDistance, byRating }

class WeekTimeSearchMessage {
  const WeekTimeSearchMessage({this.weekDay, this.time, this.isOpenNow = false});

  final WeekDayMessage? weekDay;
  final DayTimeMessage? time;
  final bool isOpenNow;
}

class DistanceRequestMessage {
  DistanceRequestMessage(this.geoPoint, this.dgisObjectId);

  final GeoPointMessage geoPoint;
  final DgisObjectIdMessage? dgisObjectId;
}

class DistanceResponseMessage {
  DistanceResponseMessage(this.distance, this.dgisObjectId);

  final double distance;
  final DgisObjectIdMessage? dgisObjectId;
}

enum RouteSearchOptionsMessage { car, publicTransport, bicycle, pedestrian, scooter, truck, taxi }

class RouteEditorRoutePointMessage {
  RouteEditorRoutePointMessage(this.point, this.objectId, this.levelId);

  final GeoPointMessage point;
  final DgisObjectIdMessage? objectId;
  final int? levelId;
}

class RouteEditorRouteParamsMessage {
  RouteEditorRouteParamsMessage(
    this.startPoint,
    this.finishPoint,
    this.options,
    this.searchParams,
    this.showOnlyActiveRoute,
    this.intermediatePoints,
  );

  final RouteEditorRoutePointMessage? startPoint;
  final RouteEditorRoutePointMessage? finishPoint;

  final RouteSearchOptionsMessage options;
  final CarRouteSearchOptionParamsMessage? searchParams;
  final bool? showOnlyActiveRoute;
  final List<RouteEditorRoutePointMessage>? intermediatePoints;
}

enum ExcludedAreaTypeMessage { point, polyline, polygon }

enum ExcludedAreaSeverityMessage { soft, hard }

class ExcludedAreaMessage {
  ExcludedAreaMessage({required this.type, required this.severity, required this.extentMeters, required this.points});

  final ExcludedAreaTypeMessage type;
  final ExcludedAreaSeverityMessage severity;
  final double extentMeters;
  final List<GeoPointMessage> points;
}

class CarRouteSearchOptionParamsMessage {
  CarRouteSearchOptionParamsMessage({
    required this.avoidTollRoads,
    required this.avoidUnpavedRoads,
    this.excludedAreas = const [],
  });

  final bool avoidTollRoads;
  final bool avoidUnpavedRoads;
  final List<ExcludedAreaMessage> excludedAreas;
}

enum DesiredAccuracyMessage { low, medium, high }

class MarkerWithPhotoMessage {
  MarkerWithPhotoMessage({
    required this.position,
    required this.photoUrl,
    required this.isPanoramic,
    required this.azimuth,
  });

  GeoPointWithElevationMessage position;
  String photoUrl;
  bool isPanoramic;
  double azimuth;
}

class AddMarkersWithPhotoMessage {
  AddMarkersWithPhotoMessage(this.markers);

  final List<MarkerWithPhotoMessage> markers;
}

class LayerPointObjectMessage {
  LayerPointObjectMessage({required this.position, required this.attributes});

  GeoPointWithElevationMessage position;
  final Map<String, String> attributes;
}

class AddLayerPointObjectsMessage {
  AddLayerPointObjectsMessage(this.objects);

  final List<LayerPointObjectMessage> objects;
}

class GeoRectMessage {
  GeoRectMessage({required this.northEast, required this.southWest});

  final GeoPointMessage northEast;
  final GeoPointMessage southWest;
}

enum WorkingFilterMessage { none, isOpen, isOpen24x7 }

class CameraSetPaddingMessage {
  CameraSetPaddingMessage({this.leftPadding = 0, this.topPadding = 0, this.rightPadding = 0, this.bottomPadding = 0});

  final int leftPadding;
  final int topPadding;
  final int rightPadding;
  final int bottomPadding;
}

/// The angle of rotation of the object relative to the direction north,
/// in degrees, is counted clockwise.
class MapDirectionMessage {
  const MapDirectionMessage(this.degree);

  final double degree;
}

/// Image anchor point (0, 0) - upper left corner, (1, 1) - lower right
class MarkerAnchorMessage {
  const MarkerAnchorMessage(this.x, this.y);

  final double x;
  final double y;
}

enum TextPlacementMessage {
  noLabel,
  bottomCenter,
  bottomRight,
  bottomLeft,
  circleBottomRight,
  rightBottom,
  rightCenter,
  rightTop,
  circleTopRight,
  topCenter,
  topRight,
  topLeft,
  circleTopLeft,
  leftTop,
  leftCenter,
  leftBottom,
  circleBottomLeft,
  centerCenter,
}

class MarkerTextPlacementMessage {
  MarkerTextPlacementMessage(this.placement);

  final TextPlacementMessage placement;
}

/// Text appearance settings.
class MarkerTextStyleMessage {
  MarkerTextStyleMessage({
    this.fontSize,
    this.color,
    this.strokeWidth,
    this.strokeColor,
    this.textPlacement,
    this.textOffset,
    this.fontName,
    this.suppressOnOverlap,
  });

  final double? fontSize;
  final int? color;
  final double? strokeWidth;
  final int? strokeColor;
  final MarkerTextPlacementMessage? textPlacement;
  final double? textOffset;
  final String? fontName;
  final bool? suppressOnOverlap;
}

/// Don't use this class directly. Use [SvgMarkerIcon], [PngMarkerIcon], [PngBytesMarkerIcon] instead.
class MarkerIconMessage {
  MarkerIconMessage(this.svgPath, this.width, this.iconMapDirection, this.iconOpacity, this.pngData, this.pngPath);

  final String? svgPath;
  final Uint8List? pngData;
  final String? pngPath;
  final double width;
  final double? iconOpacity;
  final MapDirectionMessage? iconMapDirection;
}

/// Marker parameters.
class MarkerOptionsMessage {
  const MarkerOptionsMessage({
    required this.position,
    required this.icon,
    required this.text,
    this.anchor,
    this.textStyle,
    this.animatedAppearance,
    this.zIndex,
    this.isVisible,
  });

  /// Getting the location of the marker.
  final GeoPointWithElevationMessage position;

  /// Getting a marker icon.
  final MarkerIconMessage? icon;

  /// Getting the marker icon anchor point.
  final MarkerAnchorMessage? anchor;

  /// Getting the text of the marker.
  final String? text;

  /// Getting the text style of the marker.
  final MarkerTextStyleMessage? textStyle;

  /// Should I animate the appearance?
  final bool? animatedAppearance;

  /// Is the marker visible?
  final bool? isVisible;

  /// Object rendering level.
  final int? zIndex;
}

class ChangeMarkerOptionsMessage {
  ChangeMarkerOptionsMessage({
    this.position,
    this.icon,
    this.anchor,
    this.text,
    this.textStyle,
    this.animatedAppearance,
    this.zIndex,
    this.isVisible,
  });

  final GeoPointWithElevationMessage? position;
  final MarkerIconMessage? icon;
  final MarkerAnchorMessage? anchor;
  final String? text;
  final MarkerTextStyleMessage? textStyle;
  final bool? animatedAppearance;
  final bool? isVisible;
  final int? zIndex;
}

class MarkerMessage {
  MarkerMessage(this.id, this.options);

  final String id;
  final MarkerOptionsMessage options;
}

class PolygonOptionsMessage {
  PolygonOptionsMessage({required this.contours, this.color, this.strokeWidth, this.strokeColor});

  final List<PolylineGeometryMessage> contours;
  final int? color;
  final double? strokeWidth;
  final int? strokeColor;
}

class PolygonMessage {
  PolygonMessage(this.id, this.options);

  final String id;
  final PolygonOptionsMessage options;
}

class CircleOptionsMessage {
  CircleOptionsMessage({required this.position, required this.radius, this.color, this.strokeWidth, this.strokeColor});

  final GeoPointMessage position;
  final double radius;
  final int? color;
  final double? strokeWidth;
  final int? strokeColor;
}

class CircleMessage {
  CircleMessage(this.id, this.options);

  final String id;
  final CircleOptionsMessage options;
}

class PolylineOptionsMessage {
  PolylineOptionsMessage({
    required this.points,
    this.color,
    this.width,
    this.borderWidth,
    this.borderColor,
    this.zIndex,
  });

  final List<GeoPointMessage> points;
  final int? color;
  final double? width;
  final double? borderWidth;
  final int? borderColor;
  final int? zIndex;
}

class PolylineMessage {
  PolylineMessage(this.id, this.options);

  final String id;
  final PolylineOptionsMessage options;
}

class FloorInfoMessage {
  FloorInfoMessage(this.levelId, this.buildingId);

  final int levelId;
  final int buildingId;
}

class PageIdMessage {
  PageIdMessage(this.id);

  final String id;
}

class PageMessage {
  PageMessage._(this.id, this.items);

  final PageIdMessage id;
  final List<DirectoryObjectMessage> items;
}

enum GeometryKindMessage { point, polyline, polygon, complex }

class GeometryMessage {
  GeometryMessage(this.kind, this.bounds, this.minPoint, this.maxPoint);

  final GeometryKindMessage kind;
  final GeoRectMessage bounds;
  final GeoPointMessage minPoint;
  final GeoPointMessage maxPoint;
}

class PolygonGeometryMessage {
  const PolygonGeometryMessage(this.contours);

  final List<Object> contours;
}

enum SearchResultTypeMessage { recovery, discovery }

class FlagFilterMessage {
  FlagFilterMessage(this.tagName, this.displayName, this.flagValue);

  final String tagName;
  final String displayName;
  final bool? flagValue;
}

class RangeFilterMessage {
  RangeFilterMessage(this.tagName, this.displayName, this.minValue, this.maxValue);

  final String tagName;
  final String displayName;
  final double minValue;
  final double maxValue;
}

class DynamicFilterMessage {
  DynamicFilterMessage(this.flagFilter, this.rangeFilter);

  final FlagFilterMessage? flagFilter;
  final RangeFilterMessage? rangeFilter;
}

class ItemMarkerInfoMessage {
  ItemMarkerInfoMessage(this.objectId, this.geoPoint, this.floorInfo, this.title, this.rubricIds);

  final DgisObjectIdMessage? objectId;
  final GeoPointWithElevationMessage geoPoint;
  final FloorInfoMessage? floorInfo;
  final String? title;
  final List<int?>? rubricIds;
}

class SearchResultMessage {
  SearchResultMessage(
    this.firstPage,
    this.representativeArea,
    this.areaOfInterestPosition,
    this.itemMarkerInfos,
    this.searchResultType,
    this.dynamicFilters,
    this.autoUseFirstResult,
  );

  final PageMessage? firstPage;
  final GeometryMessage? representativeArea;
  final CameraPositionMessage? areaOfInterestPosition;
  final List<ItemMarkerInfoMessage>? itemMarkerInfos;
  final SearchResultTypeMessage searchResultType;
  final List<DynamicFilterMessage> dynamicFilters;
  final bool autoUseFirstResult;
}

class UiMarkerInfoMessage {
  UiMarkerInfoMessage(this.objectId, this.label);

  final DgisObjectIdMessage? objectId;
  final String? label;
}

class SuggestObjectHandlerMessage {
  SuggestObjectHandlerMessage(this.item);

  final DirectoryObjectMessage item;
}

class IncompleteTextHandlerMessage {
  IncompleteTextHandlerMessage(this.queryText);

  final String queryText;
}

class SearchQueryMessage {
  SearchQueryMessage._(this.id);

  final String id;
}

class PerformSearchHandlerMessage {
  PerformSearchHandlerMessage(this.searchQuery);

  final SearchQueryMessage searchQuery;
}

class SuggestHandlerMessage {
  SuggestHandlerMessage(this.objectHandler, this.performSearchHandler, this.incompleteTextHandler);

  final SuggestObjectHandlerMessage? objectHandler;
  final PerformSearchHandlerMessage? performSearchHandler;
  final IncompleteTextHandlerMessage? incompleteTextHandler;
}

enum SuggestedTypeMessage {
  admDivCity,
  admDivCountry,
  admDivDistrict,
  admDivDistrictArea,
  admDivDivision,
  admDivLivingArea,
  admDivPlace,
  admDivRegion,
  admDivSettlement,
  attraction,
  attribute,
  branch,
  building,
  coordinates,
  crossroad,
  kilometerRoadSign,
  marketAttribute,
  marketBrand,
  marketCategory,
  marketSuggestorCategory,
  metaRubric,
  org,
  parking,
  road,
  route,
  routeType,
  rubric,
  station,
  stationEntrance,
  stationMetro,
  street,
  text,
  unknown,
}

/// [SuggestorType] from 2GIS SDK Documentation
enum SuggestorTypeEnum {
  // Address suggestor.
  address,
  // Settlement suggestor. Can be used without specifying a project.
  citySelector,
  // Directory object (categories, branches, streets, cities, etc.) suggestor.
  object,
  // Place suggestor.
  places,
  // A tooltip for selecting waypoints. Optimized for searching for point objects in a single action. Rejects objects without points.
  routeEndpoint,
  // Category suggestor.
  rubric,
}

class MarkedUpTextSpanMessage {
  MarkedUpTextSpanMessage(this.offset, this.length);

  final int offset;
  final int length;
}

class MarkedUpTextMessage {
  MarkedUpTextMessage(this.text, this.matchedParts);

  final String text;
  final List<MarkedUpTextSpanMessage> matchedParts;
}

class SuggestedTypeMessage_ {
  SuggestedTypeMessage_(this.type);

  final SuggestedTypeMessage type;
}

class SuggestMessage {
  SuggestMessage(this.handler, this.suggestedType, this.title, this.subtitle);

  final SuggestHandlerMessage handler;
  final SuggestedTypeMessage suggestedType;
  final MarkedUpTextMessage title;
  final MarkedUpTextMessage subtitle;
}

class SuggestResultMessage {
  SuggestResultMessage(this.suggests);

  final List<SuggestMessage> suggests;
}

/// We created this for convenience, but now we don't have to use this class
/// You can find all information about rubric ids inside [QuickFilter] class
@Deprecated("We don't have to use this class because we have to send rubricIds and keep this ids on Flutter side")
enum SearchCategoryMessage {
  mousques,
  gasStations,
  cafe,
  restaurants,
  parks,
  hospitals,
  schools,
  pharmacies,
  dentalCenters,
  hotels,
  beautyCenters,
  recreationCenters,
  beaches,
}

class SearchCategoryMessage_ {
  SearchCategoryMessage_(this.category);

  final SearchCategoryMessage category;
}

class SearchCategoriesMessage {
  SearchCategoriesMessage(this.categories);

  final List<SearchCategoryMessage_> categories;
}

class SimpleClusterOptionsMessage {
  SimpleClusterOptionsMessage({this.icon, this.anchor, this.text, this.textStyle});

  final MarkerIconMessage? icon;
  final MarkerAnchorMessage? anchor;
  final String? text;
  final MarkerTextStyleMessage? textStyle;
}

class ClusteringMapObjectManagerOptionsMessage {
  ClusteringMapObjectManagerOptionsMessage(this.logicalPixel, this.maxZoom, this.minZoom);

  final double logicalPixel;
  final double maxZoom;
  final double? minZoom;
}

class MapObjectManagerMessage {
  MapObjectManagerMessage._(this.id);

  final String id;
}

enum MapAppearanceMessage { day, night, system }

enum LogLevelMessage { verbose, info, warning, error, fatal, off }

class LogOptionsMessage {
  LogOptionsMessage(this.systemLevel, this.customLevel, this.customSink);

  final LogLevelMessage systemLevel;
  final LogLevelMessage customLevel;
  final String? customSink;
}

class RouteSearchPointMessage {
  RouteSearchPointMessage(this.coordinates, this.course, this.objectId, this.levelId);

  final GeoPointMessage coordinates;
  final BearingMessage? course;
  final DgisObjectIdMessage objectId;
  final LevelIdMessage? levelId;
}

class LevelIdMessage {
  LevelIdMessage(this.value);

  final int value;
}

class BearingMessage {
  BearingMessage(this.value);

  final double value;
}

class BriefRouteInfoMessage {
  BriefRouteInfoMessage(this.duration, this.extraInfo);

  final double duration;
  final BriefExtraRouteInfoMessage extraInfo;
}

/// Represents detailed route information returned by findRoute method
class RouteInfoMessage {
  RouteInfoMessage({
    required this.distance,
    required this.duration,
    required this.stairwayCount,
    required this.gateCount,
    required this.altitudes,
    this.geometry,
    this.publicTransportTransfers,
  });

  final double distance;
  final double duration;
  final int stairwayCount;
  final int gateCount;
  final List<int> altitudes;
  final List<GeoPointMessage>? geometry;
  final List<PublicTransportTransferMessage>? publicTransportTransfers;
}

/// Represents a list of routes returned by findRoute method
class FindRouteResultMessage {
  FindRouteResultMessage(this.routes);

  final List<RouteInfoMessage> routes;
}

class VoiceMessage {
  const VoiceMessage(this.language, this.packageMessage);

  final String language;
  final PackageMessage packageMessage;
}

class PackageMessage {
  PackageMessage(this.id, this.info);

  final String id;
  final PackageInfoMessage info;
}

class PackageInfoMessage {
  PackageInfoMessage(
    this.name,
    this.installed,
    this.incomplete,
    this.preinstalled,
    this.compatible,
    this.hasUpdate,
    this.updateStatus,
  );

  final String name;
  final bool installed;
  final bool incomplete;
  final bool preinstalled;
  final bool compatible;
  final bool hasUpdate;
  final PackageUpdateStatusMessage updateStatus;
}

enum PackageUpdateStatusMessage { notAvailable, inProgress, paused }

enum BriefExtraRouteInfoTypeMessage { bicycle, car, pedestrian, publicTransport, scooter }

class BriefExtraRouteInfoMessage {
  const BriefExtraRouteInfoMessage(this.type, this.distance);

  final BriefExtraRouteInfoTypeMessage type;
  final int distance;
}

enum WeatherMapType { temperature, precipitation }

class WeatherMapMessage {
  WeatherMapMessage({this.type, required this.layerName, required this.rasterTileUri, required this.enabled});

  final WeatherMapType? type;
  final String? layerName;
  final String? rasterTileUri;
  final bool enabled;
}

class RenderedObjectMessage {
  RenderedObjectMessage(this.objectId, this.closestMapPoint, this.levelId);

  final DgisObjectIdMessage objectId;
  final GeoPointWithElevationMessage closestMapPoint;
  final int? levelId;
}

enum VendorConfigMessage { urbiPreProd, momrahProd, momrahStg }

enum FollowStateMessage { off, followPosition, followDirection }

enum BetterRouteResponseMessage { accept, reject, timeout }

enum RoadEventActionTypeMessage { like, dislike, confirmation, disproof }

enum RoadEventActionResultMessage { ok, networkError }

enum RoadEventTypeMessage { accident, roadWorks, camera, comment, roadRestriction, other }

enum RoadEventLaneMessage { left, center, right }

enum AddRoadEventResultMessage {
  ok,
  networkError,
  territoryNotSupported,
  unknownUserLocation,
  userLocationTooFarFromEvent,
  notAuthorized,
  noPersonalDataCollectionConsent,
  userBlocked,
  tooManyRequests,
}

class SpeedRangeZoom {
  SpeedRangeZoom({
    required this.minSpeedRange,
    required this.maxSpeedRange,
    required this.routeDistanceMillimeters,
    required this.styleZoomValue,
  });

  final double minSpeedRange;
  final double maxSpeedRange;
  final double routeDistanceMillimeters;
  final double styleZoomValue;
}

enum NavigationState { navigation, finish, disabled }

class NavigationStateMessage {
  NavigationStateMessage(this.state, this.routeSearchOptions);

  final NavigationState state;
  final RouteSearchOptionsMessage? routeSearchOptions;
}

/// Represents the types of sound toggles.
///
/// The [SoundToggleType] enum defines three types of sound toggles:
/// - [none]: Represents no sound toggle.
/// - [important]: Represents an important sound toggle.
/// - [all]: Represents all sound toggle.
enum SoundToggleType {
  /// Represents no sound toggle.
  none,

  /// Represents an important sound toggle.
  important,

  /// Represents all sound toggle.
  all,
}

/// Settings for better route searching
/// [routeSearchDelay] - delay (in seconds) before searching for alternative routes when starting a trip on a route or after switching
/// to another route. Must be not less than 5 seconds
/// [betterRouteTimeCostThreshold] - minimum travel time (in seconds) difference between the original route and the alternative route
/// for which the alternative route is considered a better route
/// [betterRouteLengthThreshold] - minimum total length (in millimeters) of route edges that differ between the original route
/// and the alternative route at which the alternative route is considered a better route
class BetterRouteSettingsMessage {
  const BetterRouteSettingsMessage({
    required this.betterRouteTimeCostThreshold,
    required this.betterRouteLengthThreshold,
    required this.routeSearchDelay,
  });

  final int betterRouteTimeCostThreshold;
  final int betterRouteLengthThreshold;
  final int routeSearchDelay;
}

class VendorConfigContentMessage {
  const VendorConfigContentMessage(this.content);

  final String content;
}

/// According to the icons that we have in our pack and which we can show on the map as marker
enum MapMarkersType {
  markets,
  beach,
  gym,
  gasStation,
  events,
  carServices,
  hospitals,
  hotels,
  pharmacies,
  mosques,
  parks,
  qibla,
  restaurants,
  wc,
  dentalCenters,
  schools,
  shopping,
  beauty,
  barbershops,
  recreationCenters,
  medicalHelp,
  healthCenter,
  hospital,
  fireStation,
  policeStation,
  waterPlaces,
  lostAndFound,
  hajjSupport,
  kiosksRetail,
  additional,
  stairs,
}

class FavouritesStateMessage {
  FavouritesStateMessage(this.items, this.home, this.work);

  final List<FavouriteItemMessage> items;
  final FavouriteItemMessage? home;
  final FavouriteItemMessage? work;
}

class FavouriteItemMessage {
  FavouriteItemMessage(this.id, this.subtitle, this.title, this.coordinates);

  final String id;
  final String subtitle;
  final String title;
  final GeoPointMessage coordinates;
}

class SearchHistoryDirectoryObjectMessage {
  SearchHistoryDirectoryObjectMessage({required this.title, required this.address, this.id});

  final String title;
  final String address;
  final DgisObjectIdMessage? id;
}

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/pigeons/messages.g.dart',
    swiftOut: '../dgis_map/ios/Classes/Messages.swift',
    kotlinOut: '../dgis_map/android/src/main/kotlin/com/dgis/map/map_api/Messages.kt',
    kotlinOptions: KotlinOptions(package: 'com.dgis.map.map_api'),
  ),
)
@HostApi()
abstract class MapApi {
  @async
  InitializeMessage initialize();

  @async
  void zoomDown(ZoomControlMessage type);

  @async
  void zoomUp(ZoomControlMessage type);

  @async
  void toggleFollowState();

  @async
  void moveCameraToActiveRoute(int index);

  @async
  void setActiveRouteIndex(int index);

  @async
  void followNavigation();

  @async
  void startFollowNavigation();

  @async
  void stopFollowNavigation();

  @async
  void selectIndoorLevel(int index);

  @async
  void setIndoorFloorPlansEnabled(bool enabled);

  @async
  void loadStyles(String asset);

  @async
  void overrideLocales(List<String> locales);

  @async
  void setCameraPosition(CameraPositionMessage cameraPosition);

  @async
  PolygonGeometryMessage getCameraVisibleArea();

  @async
  void setCameraPositionPoint(CameraPositionPointMessage cameraPosition);

  @async
  void moveCamera(CameraPositionMessage cameraPosition, double duration, CameraAnimationTypeMessage animationType);

  @async
  List<RenderedObjectMessage> getNearestObjects();

  @async
  CameraPositionMessage getCameraPosition();

  @async
  CameraPositionMessage calcPositionForRoute(CalcPositionOptionsMessage options);

  @async
  CameraPositionMessage calcPositionForMarkers(List<String> markers, CalcPositionOptionsMessage options);

  @async
  CameraPositionMessage calcPositionForPolygons(List<String> polygons, CalcPositionOptionsMessage options);

  @async
  CameraPositionMessage calcPositionForPolylines(List<String> polylines, CalcPositionOptionsMessage options);

  @async
  CameraPositionMessage calcPositionForGeoPoints(List<GeoPointMessage> points, CalcPositionOptionsMessage options);

  @async
  void animateToRepresentativeArea(
    GeometryMessage area,
    CalcPositionOptionsMessage options,
    double duration,
    CameraAnimationTypeMessage animationType,
  );

  @async
  DirectoryObjectMessage searchByObjectId(DgisObjectIdMessage objectId);

  @async
  List<DistanceResponseMessage> getDistanceTo(List<DistanceRequestMessage> points);

  @async
  SearchResultMessage search(
    String queryText,
    List<int>? rubrics,
    List<GeoPointMessage>? spatialRestriction,
    WeekTimeSearchMessage? weekTime,
    GeoRectMessage? searchRect,
    SortingTypeMessage sortingType,
    int pageSize,
    String? locale,
  );

  @async
  SearchResultMessage searchByQuery(
    SearchQueryMessage query,
    List<GeoPointMessage>? spatialRestriction,
    WeekTimeSearchMessage? weekTime,
    GeoRectMessage? searchRect,
    SortingTypeMessage sortingType,
    int pageSize,
    String? locale,
  );

  @async
  SearchResultMessage searchByRubrics(
    List<int> rubrics,
    List<GeoPointMessage>? spatialRestriction,
    WeekTimeSearchMessage? weekTime,
    GeoRectMessage? searchRect,
    SortingTypeMessage sortingType,
    int pageSize,
    String? locale,
  );

  @async
  PageMessage fetchPrevPage(PageIdMessage pageId);

  @async
  PageMessage fetchNextPage(PageIdMessage pageId);

  @async
  void releasePage(PageIdMessage pageId);

  @async
  SuggestResultMessage fetchSuggests(
    String queryText,
    List<SuggestedTypeMessage_>? allowedResultTypes,
    GeoRectMessage? searchRect,
    String? locale,
    SuggestorTypeEnum? suggestorType,
    int? limit,
  );

  @async
  void addMarker(MarkerMessage marker, MapObjectManagerMessage? manager);

  @async
  void setMarkerOptions(String id, ChangeMarkerOptionsMessage options);

  @async
  void addMarkers(List<MarkerMessage> markers, MapObjectManagerMessage? manager);

  @async
  void removeMarker(String id, MapObjectManagerMessage? manager);

  @async
  void removeAllMarkers(MapObjectManagerMessage? manager);

  @async
  MapObjectManagerMessage createMapObjectManagerWithClustering(
    ClusteringMapObjectManagerOptionsMessage message,
    String? layerId,
  );

  @async
  MapObjectManagerMessage createMapObjectManager(String? layerId);

  @async
  void removeMapObjectManager(MapObjectManagerMessage manager);

  @async
  void setClusterIcon(String id, String icon);

  @async
  void releaseCluster(String id);

  @async
  void setMapObjectManagerIsVisible(bool isVisible, MapObjectManagerMessage? manager);

  @async
  void addCircle(CircleMessage circle, MapObjectManagerMessage? manager);

  @async
  void addCircles(List<CircleMessage> circles, MapObjectManagerMessage? manager);

  @async
  void removeCircle(String id, MapObjectManagerMessage? manager);

  @async
  void removeAllCircles(MapObjectManagerMessage? manager);

  @async
  void addPolygon(PolygonMessage polygon, MapObjectManagerMessage? manager);

  @async
  void addPolygons(List<PolygonMessage> polygons, MapObjectManagerMessage? manager);

  @async
  void removePolygon(String id, MapObjectManagerMessage? manager);

  @async
  void onLocationPermissionGranted(DesiredAccuracyMessage desiredAccuracy);

  @async
  void removeAllPolygons(MapObjectManagerMessage? manager);

  @async
  void addPolyline(PolylineMessage polyline, MapObjectManagerMessage? manager);

  @async
  void addPolylines(List<PolylineMessage> polylines, MapObjectManagerMessage? manager);

  @async
  void removePolyline(String id, MapObjectManagerMessage? manager);

  @async
  void removeAllPolylines(MapObjectManagerMessage? manager);

  @async
  void setHighlighted(List<DgisObjectIdMessage> objectIds);

  @async
  void addPanoramasMarkers(AddMarkersWithPhotoMessage message);

  @async
  void hidePanoramasMarkers();

  @async
  void showPanoramasMarkers();

  @async
  void removePanoramasMarkers();

  @async
  void showEsriIOLayer(AddLayerPointObjectsMessage message);

  @async
  void removeEsriIOLayer();

  @async
  void setPanoramasPaddings(CameraSetPaddingMessage message);

  @async
  void moveCameraToSelectedPanorama();

  @async
  void unselectPanorama();

  @async
  int overlappedBy(GeoRectMessage outerRect, GeoRectMessage innerRect);

  @async
  bool contains(GeoRectMessage rect, GeoPointMessage point);

  @async
  bool containsRect(GeoRectMessage outer, GeoRectMessage inner);

  @async
  double pointBearing(GeoPointMessage from, GeoPointMessage to);

  @async
  void setRouteParams(RouteEditorRouteParamsMessage params);

  @async
  void hideRoutes();

  @async
  void showRoutes();

  @async
  void startNavigation(List<SpeedRangeZoom> speedRangeZoom);

  @async
  void startNavigationSimulation(List<SpeedRangeZoom> speedRangeZoom);

  void simulationSpeed(double speed);

  @async
  void stopNavigation();

  @async
  Uint8List saveNavigationState();

  @async
  NavigationStateMessage getCurrentNavigationState();

  @async
  void restoreNavigationState(Uint8List state, List<SpeedRangeZoom> speedRangeZoom);

  @async
  void setPanoramaMarkerAzimuth(MapDirectionMessage message);

  @async
  void onCompassClicked();

  @async
  void setPublicTransportActiveRoute(int routeIndex);

  // TODO: Do all logic like in [toggleVoiceInstruction]. You have to
  // send notification to native side and send it to CarPlay and Android Auto.
  @async
  void authorizationNotification(bool isAuthorized);

  @async
  void favouritesUpdateNotification(FavouritesStateMessage favouritesState);

  @async
  void toggleVoiceInstruction(SoundToggleType toggleType);

  @async
  void toggleRoadCameras(bool toggleType);

  @async
  void toggleOverSpeeding(bool toggleType);

  @async
  void muteOtherSounds(bool mute);

  @async
  void setNavigatorVolume(int volume);

  @async
  void onTrafficAndParkingAttached();

  @async
  void onTrafficAndParkingDetached();

  @async
  void onParkingClicked();

  @async
  void onTrafficClicked();

  @async
  void addRoadEventSource();

  @async
  void removeRoadEventSource();

  @async
  RoadEventActionResultMessage setRoadEventAction(RoadEventActionTypeMessage type);

  @async
  AddRoadEventResultMessage createRoadEvent(
    RoadEventTypeMessage type,
    GeoPointMessage location,
    List<RoadEventLaneMessage> lanes,
    String description,
  );

  @async
  void setAppearance(MapAppearanceMessage appearance);

  @async
  void setZoomRestrictions(double? min, double? max);

  @async
  void startFreeRoam(List<SpeedRangeZoom> speedRangeZoom);

  @async
  void stopFreeRoam();

  @async
  void setCameraPadding(CameraSetPaddingMessage cameraPadding);

  @async
  void setMapAttributeString(String name, String value);

  @async
  void setMapAttributeBool(String name, bool value);

  @async
  List<BriefRouteInfoMessage> findBriefRouteInfos(
    RouteSearchOptionsMessage routeSearchOptions,
    RouteSearchPointMessage? startPoint,
    RouteSearchPointMessage? finishPoint,
  );

  @async
  FindRouteResultMessage findRoute(
    RouteSearchPointMessage startPoint,
    RouteSearchPointMessage finishPoint,
    RouteSearchOptionsMessage navType, {
    List<RouteSearchPointMessage>? intermediatePoints,
  });

  @async
  List<PackageMessage> listPackages();

  @async
  List<VoiceMessage> listVoices();

  @async
  void voicePlayWelcome(String id);

  @async
  void installPackage(String id);

  @async
  void installVoice(String id);

  @async
  void setNavigatorVoice(String id);

  @async
  bool toggleHeatmap(WeatherMapMessage message);

  @async
  void betterRouteResponse(BetterRouteResponseMessage response);

  @async
  BetterRouteSettingsMessage getBetterRouteSettings();

  @async
  void setBetterRouteSettings(BetterRouteSettingsMessage message);

  @async
  void setBetterRouteEnabled(bool enabled);

  @async
  bool getCarConnectionState();

  @async
  void setMaxFps(int? maxFps);

  @async
  List<SearchHistoryDirectoryObjectMessage> getSearchHistoryItems();

  @async
  void addSearchHistoryItem(SearchHistoryDirectoryObjectMessage item);

  @async
  void removeSearchHistoryItem(int index);

  @async
  void clearSearchHistoryItems();
}

@FlutterApi()
abstract class FlutterMapApi {
  SimpleClusterOptionsMessage renderCluster(MapObjectManagerMessage manager, int objectCount);
}

@FlutterApi()
abstract class HostFlutterApi {
  void analyticsTrack(String event);

  @async
  MapMarkersType? getMarkerType(List<int> rubricIds);

  @async
  VendorConfigContentMessage getAppConfig();

  @async
  FavouritesStateMessage getFavourites();

  @async
  bool isAuthorized();

  void runMain();
}

@HostApi()
abstract class PluginApi {
  @async
  void initialize(
    LogOptionsMessage? message,
    VendorConfigMessage? configMessage,
    VendorConfigContentMessage? contentMessage,
  );
}
