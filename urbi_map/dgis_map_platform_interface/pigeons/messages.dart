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

class CameraPositionMessage {
  CameraPositionMessage({
    required this.zoomValue,
    required this.geoPoint,
  });

  final double zoomValue;
  final GeoPointMessage geoPoint;
}

class DgisObjectIdMessage {
  const DgisObjectIdMessage({
    required this.objectId,
    required this.entranceId,
  });

  final int objectId;
  final int entranceId;
}

class ReviewsMessage {
  ReviewsMessage(this.count, this.rating);

  final int count;
  final double rating;
}

class AdmDivMessage {
  AdmDivMessage(this.type, this.name);

  final String type;
  final String name;
}

class AddressMessage {
  AddressMessage({
    this.addressComment,
    this.drilldownString,
    this.postCode,
    this.streetAddress,
    this.drilldown,
  });

  final String? addressComment;
  final String? drilldownString;
  final String? postCode;
  final String? streetAddress;
  final List<AdmDivMessage?>? drilldown;
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
  const WeekTimeIntervalListMessage(this.values);

  final List<WeekTimeIntervalMessage?> values;
}

class OpeningHoursMessage {
  const OpeningHoursMessage(this.values, this.isOpen24x7);

  final List<WeekTimeIntervalListMessage?> values;
  final bool isOpen24x7;
}

class MarkerPositionMessage {
  MarkerPositionMessage(this.point, this.elevation);

  final GeoPointMessage point;
  final double elevation;
}

enum ObjectTypeMessage { branch, other }

class ObjectInfoMessage {
  ObjectInfoMessage(
    this.title,
    this.subtitle,
    this.reviews,
    this.address,
    this.workStatus,
    this.openingHours,
    this.markerPosition,
    this.entranceIds,
    this.dgisObjectId,
    this.type,
  );

  final String title;
  final String subtitle;
  final ReviewsMessage? reviews;
  final AddressMessage? address;
  final WorkStatusMessage? workStatus;
  final OpeningHoursMessage? openingHours;
  final MarkerPositionMessage? markerPosition;
  final List<DgisObjectIdMessage?> entranceIds;
  final DgisObjectIdMessage? dgisObjectId;
  final ObjectTypeMessage type;
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

class EverGisLayerMessage {
  EverGisLayerMessage(this.name, this.alias);

  final String name;
  final String alias;
}

class SuggestMessage {
  SuggestMessage(this.title, this.subTitle, this.index, this.handler);

  final String title;
  final String subTitle;
  final int index;
  final SuggestHandlerMessage handler;
}

enum SuggestHandlerMessage { object, incomplete, search }

class SuggestSelectedMessage {
  SuggestSelectedMessage(this.value);

  final SuggestHandlerMessage value;
}

enum DesiredAccuracyMessage { low, medium, high }

class MarkerWithPhotoMessage {
  MarkerWithPhotoMessage({
    required this.position,
    required this.photoUrl,
    required this.isPanoramic,
    required this.azimuth,
  });

  MarkerPositionMessage position;
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
  GeoPointMessage position;
  final Map<String?, String?> attributes;
}

class AddLayerPointObjectsMessage {
  AddLayerPointObjectsMessage(this.objects);
  final List<LayerPointObjectMessage?> objects;
}

class VisibleRectMessage {
  VisibleRectMessage(this.northEast, this.southWest);

  final GeoPointMessage northEast;
  final GeoPointMessage southWest;
}

class FlagFilterMessage {
  FlagFilterMessage(this.tagName, this.displayName, this.flagValue);

  final String tagName;
  final String displayName;
  final bool flagValue;
}

enum WorkingFilterMessage { none, isOpen, isOpen24x7 }

class EGStringFilterMessage {
  const EGStringFilterMessage(this.attrName, this.value);

  final String attrName;
  final String value;
}

class EGIntFilterMessage {
  const EGIntFilterMessage(this.attrName, this.value);

  final String attrName;
  final int value;
}

class EGDoubleFilterMessage {
  const EGDoubleFilterMessage(this.attrName, this.from, this.to);

  final String attrName;
  final double from;
  final double to;
}

/// [from] and [to] are Strings in UTC format with TZ
class EGDateRangeFilterMessage {
  const EGDateRangeFilterMessage({
    required this.attrName,
    this.from,
    this.to,
  });

  final String attrName;
  final String? from;
  final String? to;
}

/// [from] and [to] are Strings in UTC format with TZ.
///
/// Applies filter: MORE-OR-EQUALS to [attrFromName] and LESS-OR-EQUALS to [attrToName]
class EGComplexDateFilterMessage {
  EGComplexDateFilterMessage({
    required this.attrFromName,
    required this.attrToName,
    this.from,
    this.to,
  });

  final String attrFromName;
  final String attrToName;
  final String? from;
  final String? to;
}

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

  final GeoPointMessage position;
  final MarkerIconMessage? icon;
  final MarkerAnchorMessage? anchor;
  final String? text;
  final MarkerTextStyleMessage? textStyle;
}

class MarkerMessage {
  MarkerMessage(this.id, this.options);

  final int id;
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

  final int id;
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

  final int id;
  final PolylineOptionsMessage options;
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
  ObjectInfoMessage searchByObjectId(DgisObjectIdMessage objectId);

  @async
  List<DistanceResponseMessage> getDistanceTo(
      List<DistanceRequestMessage> points);

  @async
  List<ObjectInfoMessage> search(
    String queryText,
    WeekTimeSearchMessage? weekTime,
    SortingTypeMessage sortingType,
    int pageSize,
  );

  @async
  List<ObjectInfoMessage>? getNextPage();

  @async
  void setMarkerOptions(MarkerOptionsMessageOld options);

  @async
  void addMarker(MarkerMessage marker);

  @async
  void removeMarker(int id);

  @async
  void removeAllMarkers();

  @async
  void addPolygon(PolygonMessage polygon);

  @async
  void removePolygon(int id);

  @async
  void removeAllPolygons();

  @async
  void addPolyline(PolylineMessage polyline);

  @async
  void removePolyline(int id);

  @async
  void removeAllPolylines();

  @async
  void removeSearchMarkers();

  @async
  void setHighlighted(List<DgisObjectIdMessage> objectIds);

  @async
  List<EverGisLayerMessage> getLayers();

  @async
  void setLayerVisible(String alias, bool visible);

  @async
  List<SuggestMessage> fetchSuggests(String queryText);

  @async
  ObjectInfoMessage getSuggestObject(int index);

  @async
  List<ObjectInfoMessage> searchBySuggest(
    int index,
    WeekTimeSearchMessage? weekTime,
    SortingTypeMessage sortingType,
    int pageSize,
  );

  @async
  void showLastSearchMarker();

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
  int overlappedBy(VisibleRectMessage outerRect, VisibleRectMessage innerRect);

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
  void applyEverGisFilters(
    String layerAlias,
    List<EGStringFilterMessage> stringFilters,
    List<EGDoubleFilterMessage> doubleFilters,
    List<EGIntFilterMessage> intFilters,
    List<EGDateRangeFilterMessage> dateRangeFilters,
    List<EGComplexDateFilterMessage> complexDateFilters,
  );

  @async
  List<FlagFilterMessage> getDirectoryDynamicFilters();

  @async
  List<ObjectInfoMessage?> applyDirectoryFilters(
    List<FlagFilterMessage> filters,
    WorkingFilterMessage isOpenFilter,
    SortingTypeMessage sortingType,
  );

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
