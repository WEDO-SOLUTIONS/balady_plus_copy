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
    this.weekDay,
    this.time,
  });

  final WeekDayMessage? weekDay;
  final DayTimeMessage? time;
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

enum ParkingAccessMessage {
  public,
  handicappedOnly,
  customersOnly,
  residentsOnly,
  taxiOnly
}

enum ParkingPavingTypeMessage { asphalt, concrete, gravel, unpaved, none }

enum SpecialSpaceTypeMessage {
  bicycle,
  motorbike,
  family,
  handicapped,
  babyCarriage,
  truck,
  scooter
}

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
    this.subtitle,
    this.id,
    this.markerPosition,
    this.address,
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
    this.entrances,
    this.tradeLicense,
    this.externalIds,
  );

  final List<ObjectTypeItemMessage?> types;
  final String title;
  final String titleAddition;
  final String subtitle;
  final DgisObjectIdMessage? id;
  final GeoPointWithElevationMessage? markerPosition;
  final AddressMessage? address;
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
  final List<EntranceInfoMessage?> entrances;
  final TradeLicenseMessage? tradeLicense;
  final List<String?>? externalIds;
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

enum RouteSearchOptionsMessage {
  car,
  publicTransport,
  bicycle,
  pedestrian,
  scooter,
  truck,
  taxi
}

class RouteEditorRouteParamsMessage {
  RouteEditorRouteParamsMessage(
    this.startPoint,
    this.finishPoint,
    // TODO: not yet supported
    // this.intermediatePoints,
    this.options,
  );

  final GeoPointMessage? startPoint;
  final GeoPointMessage? finishPoint;

  // TODO: not yet supported
  // final List<RouteSearchPointMessage> intermediatePoints;
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
  MarkerIconMessage(this.path, this.width, this.iconMapDirection);

  final String path;
  final double width;
  final MarkerAzimuthMessage? iconMapDirection;
}

class MarkerOptionsMessage {
  MarkerOptionsMessage({
    required this.position,
    required this.icon,
    this.anchor,
    required this.text,
    this.textStyle,
  });

  final GeoPointWithElevationMessage position;
  final MarkerIconMessage? icon;
  final MarkerAnchorMessage? anchor;
  final String? text;
  final MarkerTextStyleMessage? textStyle;
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
  RangeFilterMessage(
      this.tagName, this.displayName, this.minValue, this.maxValue);

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
    this.itemMarkerInfos,
    this.searchResultType,
    this.dynamicFilters,
    this.autoUseFirstResult,
  );

  final PageMessage? firstPage;
  final GeometryMessage? representativeArea;
  final List<ItemMarkerInfoMessage?>? itemMarkerInfos;
  final SearchResultTypeMessage searchResultType;
  final List<DynamicFilterMessage?> dynamicFilters;
  final bool autoUseFirstResult;
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
}

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/pigeons/messages.g.dart',
    objcHeaderOut: '../dgis_map/ios/Classes/messages.h',
    objcSourceOut: '../dgis_map/ios/Classes/messages.m',
    javaOut:
        '../dgis_map/android/src/main/kotlin/com/dgis/map/map_api/Messages.java',
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
  void changeFollowState();

  @async
  void selectIndoorLevel(int index);

  @async
  void loadStyles(String asset);

  @async
  void overrideLocales(List<String> locales);

  @async
  void setCameraPosition(CameraPositionMessage cameraPosition);

  @async
  CameraPositionMessage getCameraPosition();

  @async
  DirectoryObjectMessage searchByObjectId(DgisObjectIdMessage objectId);

  @async
  List<DistanceResponseMessage> getDistanceTo(
      List<DistanceRequestMessage> points);

  @async
  SearchResultMessage search(
    String queryText,
    WeekTimeSearchMessage? weekTime,
    GeoRectMessage? searchRect,
    SortingTypeMessage sortingType,
    int pageSize,
  );

  @async
  SearchResultMessage searchByQuery(
    SearchQueryMessage query,
    WeekTimeSearchMessage? weekTime,
    GeoRectMessage? searchRect,
    SortingTypeMessage sortingType,
    int pageSize,
  );

  @async
  SearchResultMessage searchByCategory(
    SearchCategoryMessage category,
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
    GeoRectMessage? searchRect,
  );

  @async
  void setMarkerOptions(MarkerOptionsMessageOld options);

  @async
  void addMarker(MarkerMessage marker);

  @async
  void addMarkers(List<MarkerMessage> markers);

  @async
  void removeMarker(String id);

  @async
  void removeAllMarkers();

  @async
  void addPolygon(PolygonMessage polygon);

  @async
  void addPolygons(List<PolygonMessage> polygons);

  @async
  void removePolygon(String id);

  @async
  void removeAllPolygons();

  @async
  void addPolyline(PolylineMessage polyline);

  @async
  void addPolylines(List<PolylineMessage> polylines);

  @async
  void removePolyline(String id);

  @async
  void removeAllPolylines();

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
  void setRouteParams(RouteEditorRouteParamsMessage params);

  @async
  void hideRoutes();

  @async
  void startNavigation();

  @async
  void startNavigationSimulation();

  @async
  void stopNavigation();

  @async
  void setPanoramaMarkerAzimuth(MarkerAzimuthMessage message);

  @async
  void onCompassClicked();

  @async
  void setPublicTransportActiveRoute(int routeIndex);

  @async
  void toggleSound();

  @async
  void onTrafficAndParkingAttached();

  @async
  void onTrafficAndParkingDetached();

  @async
  void onParkingClicked();

  @async
  void onTrafficClicked();

  @async
  void startFreeRoam();

  @async
  void stopFreeRoam();
}
