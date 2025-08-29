import 'package:mapness/shared/providers/analytic/models/bss_common.dart';
import 'package:mapness/shared/providers/analytic/models/payload/bss_payload.dart';
import 'package:uuid/uuid.dart';

enum BSSEventType {
  /// Action of the user or application
  action,

  /// Show up of the UI element
  view,
}

/// Type of the action
enum BSSActionType {
  /// Tap on the UI element
  tap,

  /// Scroll on the List
  scroll,

  /// Text input
  textInput,

  /// Drag and drop
  dragAndDrop,

  /// Someone followed the link
  deeplink,
}

class BssRequest {
  const BssRequest({
    required this.eventType,
    required this.uiElement,
    this.payload,
    this.actionType,
  });

  /// Message code. For Balady - 434
  static const int type = 434;

  /// Globally unique event identifier in "uuid" format
  /// Note: We don't use it as parameter, because it's generated on the fly in [toJsonWithIds]
  /// final Uuid eventId;

  /// Ordinal number of the event in the sequence starts from 0
  /// Min: 0
  /// [sessionId] + [eventOrdinal] allows to track the message in the unique way
  /// Note: We don't use it as parameter, because it passed as a parameter in [toJsonWithIds] from [BssService]
  /// final int eventOrdinal;

  /// Type of the event; action of the user or application OR show up of the UI element
  /// Variants: action, view
  final BSSEventType eventType;

  /// IF [eventType] is [BSSEventType.action] then this field is required
  /// Variants: tap, scroll, textInput, dragAndDrop, deeplink
  final BSSActionType? actionType;

  /// Event time with millisecond accuracy.
  /// Defined as the number of milliseconds since Unix Epoch
  /// Note: We don't use it as parameter, because it's generated on the fly in [toJsonWithIds]
  /// final int timestamp;

  /// The ui element that the user saw or interacted with.
  final BssUIElement uiElement;

  /// Description of the state of the card at the time the event was performed by the user.
  /// Note: We don't use it as parameter, because it's passed as a parameter in [toJsonWithIds] from [BssService]
  ///final BssMap map;

  /// General attribute block
  /// Note: We don't use it as parameter, because it's passed as a parameter in [toJsonWithIds] from [BssService]
  /// final BssCommon common;

  /// Block of additional attributes
  final BssPayload? payload;

  Map<String, dynamic> toJson({
    required int eventOrdinal,
    required BssCommon common,
    required BssMap map,
  }) {
    final eventId = const Uuid().v4();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final data = <String, dynamic>{
      'type': type,
      'eventId': eventId.toString(),
      'eventOrdinal': eventOrdinal,
      'eventType': eventType.name,
      'timestamp': timestamp.toString(),
      'uiElement': uiElement.toJson(),
      'map': map.toJson(),
      'common': common.toJson(),
    };
    if (actionType != null) {
      data['actionType'] = actionType?.name;
    }
    if (payload != null) {
      data['payload'] = payload?.toJson();
    }
    return data;
  }

  BssRequest copyWith({
    BSSEventType? eventType,
    BSSActionType? actionType,
    BssUIElement? uiElement,
    BssPayload? payload,
  }) =>
      BssRequest(
        eventType: eventType ?? this.eventType,
        actionType: actionType ?? this.actionType,
        uiElement: uiElement ?? this.uiElement,
        payload: payload ?? this.payload,
      );
}

enum BssUIElementNames {
  directorySearchScreen,
  directoryObjectCardScreen,
  searchResultList,
  searchBar,
  searchStart,
  suggestList,
  suggestItem,
  placeCardMini,
  mapMarker,
  historyItem,
  historyList,
  searchField,
  expandHistoryList,
  rollupHistoryList,
  searchMoreButton,
  placeCardHidden,
  placeCardOneThird,
  placeCardTwoThird,
  placeCardFull,
  buildRoute,
  actionBar,
  contactTap,
  bookmark,
  contact,
  cardInformation,
}

class BssUIElement {
  const BssUIElement({
    required this.name,
    this.ownerName,
    this.position,
  });

  /// The name of the ui element that the user saw or interacted with.
  final BssUIElementNames name;

  /// The name of the parent ui element, needed to glue message chains together when there is a complex hierarchy of elements.
  /// For example: Column, Row, etc.
  final BssUIElementNames? ownerName;

  /// The ordinal number of the element in the list. Required to be filled in for list elements (vertical or horizontal)
  final int? position;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'name': name.name,
    };
    if (ownerName != null) {
      data['ownerName'] = ownerName!.name;
    }
    if (position != null) {
      data['position'] = position;
    }
    return data;
  }
}

/// Description of the state of the card at the time the event was performed by the user.
class BssMap {
  const BssMap({
    required this.inviewport,
    this.zoomLevel,
    this.rotation,
  });

  /// Start viewport when entering a query, specified by 4 (must be all 4) points
  /// Viewport of the screen where the user enters a query.
  /// Important: counter-clockwise traversal.
  /// Very important for the search team within the global map for both searches and card openings.
  final List<BssViewport> inviewport;

  /// Zoom, fractional number. For mobile and online, the same zoom value may correspond to a different physical scale,
  /// depending on the current grid on each platform.
  /// At the moment, the zoom value is approximately 0 when viewing the entire world, 20 - at maximum zoom
  /// (there is no need to validate this in the schemes).
  final double? zoomLevel;

  /// Rotate the map relative to the window. Fractional number. Measured in degrees. 0 degrees corresponds to the north,
  /// up to 180 degrees when rotating clockwise, up to -180 when rotating counterclockwise. 180 and -180 degrees correspond to the south.
  final double? rotation;

  Map<String, dynamic> toJson() => {
        'inviewport': inviewport.map((e) => e.toJson()).toList(),
      };
}

class BssViewport {
  final double lat;
  final double lon;

  const BssViewport({required this.lat, required this.lon})
      : assert(lat >= -90 && lat <= 90, 'Latitude must be between -90 and 90'),
        assert(lon >= -180 && lon <= 180, 'Longitude must be between -180 and 180');

  Map<String, dynamic> toJson() => {
        'lat': lat,
        'lon': lon,
      };
}
