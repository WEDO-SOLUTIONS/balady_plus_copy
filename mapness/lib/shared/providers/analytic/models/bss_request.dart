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
    required this.query,
    required this.eventId,
    required this.timestamp,
    required this.map,
    required this.common,
    required this.eventOrdinal,
    required this.eventType,
    required this.uiElement,
    this.payload,
    this.actionType,
  });

  /// Message code. For Balady - 434
  static const int type = 434;

  /// Globally unique event identifier in "uuid" format
  final Uuid eventId;

  /// Ordinal number of the event in the sequence starts from 0
  /// Min: 0
  /// [sessionId] + [eventOrdinal] allows to track the message in the unique way
  final int eventOrdinal;

  /// Type of the event; action of the user or application OR show up of the UI element
  /// Variants: action, view
  final BSSEventType eventType;

  /// IF [eventType] is [BSSEventType.action] then this field is required
  /// Variants: tap, scroll, textInput, dragAndDrop, deeplink
  final BSSActionType? actionType;

  /// Event time with millisecond accuracy.
  /// Defined as the number of milliseconds since Unix Epoch
  final int timestamp;

  /// Search query text
  final String query;

  /// The ui element that the user saw or interacted with.
  final BssUIElement uiElement;

  /// Description of the state of the card at the time the event was performed by the user.
  final BssMap map;

  /// General attribute block
  final BssCommon common;

  /// Block of additional attributes
  final BssPayload? payload;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'type': type,
      'eventId': eventId.toString(),
      'eventOrdinal': eventOrdinal,
      'eventType': eventType.name,
      'timestamp': timestamp.toString(),
      'query': query,
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
}

class BssUIElement {
  const BssUIElement({
    required this.name,
    this.ownerName,
    this.position,
  });

  /// The name of the ui element that the user saw or interacted with.
  final String name;

  /// The name of the parent ui element, needed to glue message chains together when there is a complex hierarchy of elements.
  /// For example: Column, Row, etc.
  final String? ownerName;

  /// The ordinal number of the element in the list. Required to be filled in for list elements (vertical or horizontal)
  final int? position;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'name': name,
    };
    if (ownerName != null) {
      data['ownerName'] = ownerName;
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
  });

  /// Start viewport when entering a query, specified by 4 (must be all 4) points
  /// Viewport of the screen where the user enters a query.
  /// Important: counter-clockwise traversal.
  /// Very important for the search team within the global map for both searches and card openings.
  final List<BssViewport> inviewport;

  Map<String, dynamic> toJson() {
    return {
      'inviewport': inviewport.map((e) => e.toJson()).toList(),
    };
  }
}

// TODO: Implement this
class BssViewport {
  const BssViewport();

  Map<String, dynamic> toJson() {
    return {};
  }
}
