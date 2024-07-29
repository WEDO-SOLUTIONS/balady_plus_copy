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
  CalcPositionOptionsMessage(
    this.screenArea,
    this.tilt,
    this.bearing,
    this.size,
  );

  final CameraSetPaddingMessage? screenArea;
  final double? tilt;
  final double? bearing;
  final ScreenSizeMessage? size;
}

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

enum CameraAnimationTypeMessage { default_, linear, showBothPositions }

class DgisObjectIdMessage {
  const DgisObjectIdMessage({
    required this.objectId,
    required this.entranceId,
  });

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

enum WeekDayMessage {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

class WeekTimeMessage {
  const WeekTimeMessage({
    required this.weekDay,
    required this.time,
  });

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

  final List<WeekTimeIntervalMessage?> values;
}

class OpeningHoursMessage {
  const OpeningHoursMessage(this.values, this.isOpen24x7);

  final List<WeekTimeIntervalListMessage?> values;
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

  final List<AddressAdmDivMessage?> drilldown;
  final List<AddressComponentMessage?> components;
  final String? buildingName;
  final String? postCode;
  final String? buildingCode;
  final String? addressComment;
}

class FormattedAddressMessage {
  FormattedAddressMessage(
    this.drilldownAddress,
    this.streetAddress,
    this.addressComment,
    this.postCode,
  );

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

enum ParkingPurposeMessage {
  car,
  bike,
  motorbike,
  babyCarriage,
  scooter,
}

enum ParkingAccessMessage { public, handicappedOnly, customersOnly, residentsOnly, taxiOnly }

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
  final List<SpecialSpaceMessage?> specialSpaces;
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
  final List<LevelInfoMessage?> levels;
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

  final List<GeoPointMessage?> entrancePoints;
  final List<List<GeoPointMessage?>?> entrancePolylines;
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
  attraction,
  branch,
  building,
  coordinates,
  crossroad,
  parking,
  road,
  route,
  station,
  stationEntrance,
  street,
  unknown
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

class DirectoryObjectMessage {
  DirectoryObjectMessage(
    this.types,
    this.title,
    this.titleAddition,
    this.about,
    this.subtitle,
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
  );

  final List<ObjectTypeItemMessage?> types;
  final String title;
  final String titleAddition;
  final String subtitle;
  final String about;
  final DgisObjectIdMessage? id;
  final GeoPointWithElevationMessage? markerPosition;
  final AddressMessage? address;
  final FormattedAddressMessage? fullAddressName;
  final FormattedAddressMessage? shortAddressName;
  final List<AttributeMessage?> attributes;
  final List<AttributeMessage?> contextAttributes;
  final double? timeZoneOffset;
  final OpeningHoursMessage? openingHours;
  final List<ContactInfoMessage?> contactInfos;
  final ReviewsMessage? reviews;
  final ParkingInfoMessage? parkingInfo;
  final WorkStatusMessage? workStatus;
  final int? levelId;
  final BuildingLevelsMessage? buildingLevels;
  final BuildingInfoMessage buildingInfo;
  final List<EntranceInfoMessage?> entrances;
  final TradeLicenseMessage? tradeLicense;
}

enum SortingTypeMessage { byRelevance, byDistance, byRating }

class WeekTimeSearchMessage {
  const WeekTimeSearchMessage({
    this.weekDay,
    this.time,
    this.isOpenNow = false,
  });

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

class MarkerOptionsMessageOld {
  const MarkerOptionsMessageOld({
    required this.svgAsset,
    required this.width,
    required this.height,
    required this.iconWidth,
  });

  final String svgAsset;
  final double width;
  final double height;
  final double iconWidth;
}

enum RouteSearchOptionsMessage { car, publicTransport, bicycle, pedestrian, scooter, truck, taxi }

class RouteEditorRoutePointMessage {
  RouteEditorRoutePointMessage(
    this.point,
    this.objectId,
    this.levelId,
  );

  final GeoPointMessage point;
  final DgisObjectIdMessage? objectId;
  final int? levelId;
}

class RouteEditorRouteParamsMessage {
  RouteEditorRouteParamsMessage(
    this.startPoint,
    this.finishPoint,
    this.options,
  );

  final RouteEditorRoutePointMessage? startPoint;
  final RouteEditorRoutePointMessage? finishPoint;

  final RouteSearchOptionsMessage options;
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

  final List<MarkerWithPhotoMessage?> markers;
}

class LayerPointObjectMessage {
  LayerPointObjectMessage({required this.position, required this.attributes});
  GeoPointWithElevationMessage position;
  final Map<String?, String?> attributes;
}

class AddLayerPointObjectsMessage {
  AddLayerPointObjectsMessage(this.objects);
  final List<LayerPointObjectMessage?> objects;
}

class GeoRectMessage {
  GeoRectMessage({
    required this.northEast,
    required this.southWest,
  });

  final GeoPointMessage northEast;
  final GeoPointMessage southWest;
}

enum WorkingFilterMessage { none, isOpen, isOpen24x7 }

class CameraSetPaddingMessage {
  CameraSetPaddingMessage({
    this.leftPadding = 0,
    this.topPadding = 0,
    this.rightPadding = 0,
    this.bottomPadding = 0,
  });

  final int leftPadding;
  final int topPadding;
  final int rightPadding;
  final int bottomPadding;
}

class MarkerAzimuthMessage {
  MarkerAzimuthMessage(this.degree);

  final double degree;
}

class MarkerAnchorMessage {
  MarkerAnchorMessage(this.x, this.y);

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
  centerCenter
}

class MarkerTextPlacementMessage {
  MarkerTextPlacementMessage(this.placement);

  final TextPlacementMessage placement;
}

class MarkerTextStyleMessage {
  MarkerTextStyleMessage({
    this.fontSize,
    this.color,
    this.strokeWidth,
    this.strokeColor,
    this.textPlacement,
    this.textOffset,
    this.fontName,
  });

  final double? fontSize;
  final int? color;
  final double? strokeWidth;
  final int? strokeColor;
  final MarkerTextPlacementMessage? textPlacement;
  final double? textOffset;
  final String? fontName;
}

class MarkerIconMessage {
  MarkerIconMessage(this.path, this.width, this.iconMapDirection, this.iconOpacity);

  final String path;
  final double width;
  final double? iconOpacity;
  final MarkerAzimuthMessage? iconMapDirection;
}

class MarkerOptionsMessage {
  MarkerOptionsMessage({
    required this.position,
    required this.icon,
    this.anchor,
    required this.text,
    this.textStyle,
    this.animatedAppearance,
    this.zIndex,
  });

  final GeoPointWithElevationMessage position;
  final MarkerIconMessage? icon;
  final MarkerAnchorMessage? anchor;
  final String? text;
  final MarkerTextStyleMessage? textStyle;
  final bool? animatedAppearance;
  final int? zIndex;
}

class MarkerMessage {
  MarkerMessage(this.id, this.options);

  final String id;
  final MarkerOptionsMessage options;
}

class PolygonOptionsMessage {
  PolygonOptionsMessage({
    required List<List<GeoPointMessage>> this.contours,
    this.color,
    this.strokeWidth,
    this.strokeColor,
  });

  final List<List<GeoPointMessage?>?> contours;
  final int? color;
  final double? strokeWidth;
  final int? strokeColor;
}

class PolygonMessage {
  PolygonMessage(this.id, this.options);

  final String id;
  final PolygonOptionsMessage options;
}

class PolylineOptionsMessage {
  PolylineOptionsMessage({
    required List<GeoPointMessage> this.points,
    this.color,
    this.width,
  });

  final List<GeoPointMessage?> points;
  final int? color;
  final double? width;
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
  final List<DirectoryObjectMessage?> items;
}

enum GeometryKindMessage {
  point,
  polyline,
  polygon,
  complex,
}

class GeometryMessage {
  GeometryMessage(this.kind, this.bounds, this.minPoint, this.maxPoint);

  final GeometryKindMessage kind;
  final GeoRectMessage bounds;
  final GeoPointMessage minPoint;
  final GeoPointMessage maxPoint;
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
  ItemMarkerInfoMessage(this.objectId, this.geoPoint, this.floorInfo);

  final DgisObjectIdMessage? objectId;
  final GeoPointWithElevationMessage geoPoint;
  final FloorInfoMessage? floorInfo;
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
    this.markersWithLabel,
  );

  final PageMessage? firstPage;
  final GeometryMessage? representativeArea;
  final CameraPositionMessage? areaOfInterestPosition;
  final List<ItemMarkerInfoMessage?>? itemMarkerInfos;
  final SearchResultTypeMessage searchResultType;
  final List<DynamicFilterMessage?> dynamicFilters;
  final bool autoUseFirstResult;
  final List<UiMarkerInfoMessage?>? markersWithLabel;
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
  SuggestHandlerMessage(
    this.objectHandler,
    this.performSearchHandler,
    this.incompleteTextHandler,
  );

  final SuggestObjectHandlerMessage? objectHandler;
  final PerformSearchHandlerMessage? performSearchHandler;
  final IncompleteTextHandlerMessage? incompleteTextHandler;
}

enum SuggestedTypeMessage {
  admDiv,
  attraction,
  attribute,
  branch,
  building,
  coordinates,
  crossroad,
  districtArea,
  org,
  orgCategory,
  parking,
  region,
  road,
  route,
  station,
  stationEntrance,
  street,
  text,
  unknown
}

class MarkedUpTextSpanMessage {
  MarkedUpTextSpanMessage(this.offset, this.length);

  final int offset;
  final int length;
}

class MarkedUpTextMessage {
  MarkedUpTextMessage(this.text, this.matchedParts);

  final String text;
  final List<MarkedUpTextSpanMessage?> matchedParts;
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

  final List<SuggestMessage?> suggests;
}

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
  beaches
}

class SearchCategoryMessage_ {
  SearchCategoryMessage_(this.category);

  final SearchCategoryMessage category;
}

class SearchCategoriesMessage {
  SearchCategoriesMessage(this.categories);

  final List<SearchCategoryMessage_?> categories;
}

class SimpleClusterOptionsMessage {
  SimpleClusterOptionsMessage({
    this.icon,
    this.anchor,
    this.text,
    this.textStyle,
  });

  final MarkerIconMessage? icon;
  final MarkerAnchorMessage? anchor;
  final String? text;
  final MarkerTextStyleMessage? textStyle;
}

class ClusteringMapObjectManagerOptionsMessage {
  ClusteringMapObjectManagerOptionsMessage(
    this.logicalPixel,
    this.maxZoom,
    this.minZoom,
  );

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

class PackageMessage {
  PackageMessage(this.id, this.info);

  final String id;
  final PackageInfoMessage info;
}

class PackageInfoMessage {
  PackageInfoMessage(this.name, this.installed, this.incomplete, this.preinstalled, this.compatible, this.hasUpdate,
      this.updateStatus);

  final String name;
  final bool installed;
  final bool incomplete;
  final bool preinstalled;
  final bool compatible;
  final bool hasUpdate;
  final PackageUpdateStatusMessage updateStatus;
}

enum PackageUpdateStatusMessage { notAvailable, inProgress, paused }

enum BriefExtraRouteInfoTypeMessage {
  bicycle,
  car,
  pedestrian,
  publicTransport,
  scooter,
}

class BriefExtraRouteInfoMessage {
  const BriefExtraRouteInfoMessage(this.type, this.distance);

  final BriefExtraRouteInfoTypeMessage type;
  final int distance;
}

enum WeatherMapType {
  temperature,
  precipitation,
}

class WeatherMapMessage {
  WeatherMapMessage({
    this.type,
    required this.layerName,
    required this.rasterTileUri,
    required this.enabled,
  });
  final WeatherMapType? type;
  final String? layerName;
  final String? rasterTileUri;
  final bool enabled;
}

class RenderedObjectMessage {
  RenderedObjectMessage(this.object, this.closestMapPoint);

  final DgisObjectIdMessage object;
  final GeoPointWithElevationMessage closestMapPoint;
}

enum VendorConfigMessage {
  urbiPreProd,
  momrahProd,
  momrahStg,
}

enum FollowStateMessage {
  off,
  followPosition,
  followDirection,
}

enum BetterRouteResponseMessage { accept, reject, timeout }

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

/// Settings for better route searching
/// [routeSearchDelay] - delay (in seconds) before searching for alternative routes when starting a trip on a route or after switching
/// to another route. Must be not less than 5 seconds
/// [betterRouteTimeCostThreshold] - minimum travel time (in seconds) difference between the original route and the alternative route
/// for which the alternative route is considered a better route
/// [betterRouteLengthThreshold] - minimum total length (in millimeters) of route edges that differ between the original route
/// and the alternative route at which the alternative route is considered a better route
class BetterRouteSettingsMessage {
  final int betterRouteTimeCostThreshold;
  final int betterRouteLengthThreshold;
  final int routeSearchDelay;

  const BetterRouteSettingsMessage({
    required this.betterRouteTimeCostThreshold,
    required this.betterRouteLengthThreshold,
    required this.routeSearchDelay,
  });
}

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/pigeons/messages.g.dart',
    objcHeaderOut: '../dgis_map/ios/Classes/messages.h',
    objcSourceOut: '../dgis_map/ios/Classes/messages.m',
    javaOut: '../dgis_map/android/src/main/kotlin/com/dgis/map/map_api/Messages.java',
    javaOptions: JavaOptions(
      package: 'com.dgis.map.map_api',
    ),
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
  void followNavigation();

  @async
  void selectIndoorLevel(int index);

  @async
  void loadStyles(String asset);

  @async
  void overrideLocales(List<String> locales);

  @async
  void setCameraPosition(CameraPositionMessage cameraPosition);

  @async
  void setCameraPositionPoint(CameraPositionPointMessage cameraPosition);

  @async
  void moveCamera(
    CameraPositionMessage cameraPosition,
    double duration,
    CameraAnimationTypeMessage animationType,
  );

  @async
  List<RenderedObjectMessage> getNearestObjects();

  @async
  CameraPositionMessage getCameraPosition();

  @async
  CameraPositionMessage calcPositionForRoute(
    CalcPositionOptionsMessage options,
  );

  @async
  CameraPositionMessage calcPositionForMarkers(
    List<String> markers,
    CalcPositionOptionsMessage options,
  );

  @async
  CameraPositionMessage calcPositionForPolygons(
    List<String> polygons,
    CalcPositionOptionsMessage options,
  );

  @async
  CameraPositionMessage calcPositionForPolylines(
    List<String> polylines,
    CalcPositionOptionsMessage options,
  );

  @async
  DirectoryObjectMessage searchByObjectId(DgisObjectIdMessage objectId);

  @async
  List<DistanceResponseMessage> getDistanceTo(List<DistanceRequestMessage> points);

  @async
  SearchResultMessage search(
    String queryText,
    SearchCategoriesMessage? categories,
    List<GeoPointMessage>? spatialRestriction,
    WeekTimeSearchMessage? weekTime,
    GeoRectMessage? searchRect,
    SortingTypeMessage sortingType,
    int pageSize,
  );

  @async
  SearchResultMessage searchByQuery(
    SearchQueryMessage query,
    List<GeoPointMessage>? spatialRestriction,
    WeekTimeSearchMessage? weekTime,
    GeoRectMessage? searchRect,
    SortingTypeMessage sortingType,
    int pageSize,
  );

  @async
  SearchResultMessage searchByCategory(
    SearchCategoryMessage category,
    List<GeoPointMessage>? spatialRestriction,
    WeekTimeSearchMessage? weekTime,
    GeoRectMessage? searchRect,
    SortingTypeMessage sortingType,
    int pageSize,
  );

  @async
  SearchResultMessage searchByRubrics(
    List<int> rubrics,
    List<GeoPointMessage>? spatialRestriction,
    WeekTimeSearchMessage? weekTime,
    GeoRectMessage? searchRect,
    SortingTypeMessage sortingType,
    int pageSize,
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
  );

  @async
  void setMarkerOptions(MarkerOptionsMessageOld options);

  @async
  void addMarker(MarkerMessage marker, MapObjectManagerMessage? manager);

  @async
  void addMarkers(
    List<MarkerMessage> markers,
    MapObjectManagerMessage? manager,
  );

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
  MapObjectManagerMessage createMapObjectManager(
    String? layerId,
  );

  @async
  void removeMapObjectManager(MapObjectManagerMessage manager);

  @async
  void setClusterIcon(String id, String icon);

  @async
  void releaseCluster(String id);

  @async
  void setMapObjectManagerIsVisible(
    bool isVisible,
    MapObjectManagerMessage? manager,
  );

  @async
  void addPolygon(PolygonMessage polygon, MapObjectManagerMessage? manager);

  @async
  void addPolygons(
    List<PolygonMessage> polygons,
    MapObjectManagerMessage? manager,
  );

  @async
  void removePolygon(String id, MapObjectManagerMessage? manager);

  @async
  void removeAllPolygons(MapObjectManagerMessage? manager);

  @async
  void addPolyline(
    PolylineMessage polyline,
    MapObjectManagerMessage? manager,
  );

  @async
  void addPolylines(
    List<PolylineMessage> polylines,
    MapObjectManagerMessage? manager,
  );

  @async
  void removePolyline(String id, MapObjectManagerMessage? manager);

  @async
  void removeAllPolylines(MapObjectManagerMessage? manager);

  @async
  void setHighlighted(List<DgisObjectIdMessage> objectIds);

  @async
  void onLocationPremissionGranted(DesiredAccuracyMessage desiredAccuracy);

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
  void startNavigation(SpeedRangeZoom speedRangeZoom);

  @async
  void startNavigationSimulation(SpeedRangeZoom speedRangeZoom);

  @async
  void stopNavigation();

  @async
  Uint8List saveNavigationState();

  @async
  void restoreNavigationState(Uint8List state, SpeedRangeZoom speedRangeZoom);

  @async
  void setPanoramaMarkerAzimuth(MarkerAzimuthMessage message);

  @async
  void onCompassClicked();

  @async
  void setPublicTransportActiveRoute(int routeIndex);

  @async
  void toggleSound(bool enabled);

  @async
  void onTrafficAndParkingAttached();

  @async
  void onTrafficAndParkingDetached();

  @async
  void onParkingClicked();

  @async
  void onTrafficClicked();

  @async
  void setAppearance(MapAppearanceMessage appearance);

  @async
  void setZoomRestrictions(double? min, double? max);

  @async
  void startFreeRoam();

  @async
  void stopFreeRoam();

  @async
  void setCameraPadding(CameraSetPaddingMessage cameraPadding);

  @async
  void setMapAttributeString(String name, String value);

  @async
  void setMapAttributeBool(String name, bool value);

  @async
  List<BriefRouteInfoMessage?> findBriefRouteInfos(
    RouteSearchOptionsMessage routeSearchOptions,
    RouteSearchPointMessage? startPoint,
    RouteSearchPointMessage? finishPoint,
  );

  @async
  List<PackageMessage?> listPackages();

  @async
  List<PackageMessage?> listVoices();

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
}

@FlutterApi()
abstract class FlutterMapApi {
  SimpleClusterOptionsMessage renderCluster(
    MapObjectManagerMessage manager,
    int objectCount,
  );
}

@HostApi()
abstract class PluginApi {
  @async
  void initialize(LogOptionsMessage? message, VendorConfigMessage? configMessage);
}
