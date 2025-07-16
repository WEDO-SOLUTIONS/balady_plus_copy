// ignore_for_file: public_member_api_docs

import 'dart:developer';

import 'package:dgis_map_platform_interface/library.dart';
import '../utils/public_transport_ext.dart';

/// Event fired when public transport routes change
class PublicTransportRoutesChangedEvent {
  const PublicTransportRoutesChangedEvent(this.routes);

  static const name = "onPublicTransportRoutesChanged";

  final List<BriefPublicTransportModel> routes;
}

/// Event fired when the active public transport route changes
class PublicTransportActiveRouteChanged {
  const PublicTransportActiveRouteChanged(this.route);

  static const name = "onPublicTransportActiveRouteChanged";

  final PublicTransportModel route;
}

/// Types of transport icons that can be displayed
enum TransportIconType {
  /// Icon based on transport type (e.g., metro, bus)
  ofType,

  /// Combined icon for multiple transport types
  combined,

  /// Special icon (e.g., custom route logo)
  special
}

/// Represents a transport icon with type, value, and optional color
class TransportIcon {
  const TransportIcon({
    required this.type,
    required this.value,
    this.color,
  });

  /// Creates a TransportIcon from a map representation
  factory TransportIcon.fromMap(Map<dynamic, dynamic> map) {
    try {
      final typeString = map['type'] as String? ?? 'ofType';
      final type = _parseTransportIconType(typeString);

      return TransportIcon(
        type: type,
        value: map['value'] as String? ?? '',
        color: map['color'] as int?,
      );
    } catch (error) {
      log('Error parsing TransportIcon: $error');
      rethrow;
    }
  }

  final TransportIconType type;
  final String value;
  final int? color;

  /// Parses transport icon type from string
  static TransportIconType _parseTransportIconType(String typeString) {
    switch (typeString.toLowerCase()) {
      case 'oftype':
        return TransportIconType.ofType;
      case 'combined':
        return TransportIconType.combined;
      case 'special':
        return TransportIconType.special;
      default:
        log('Unknown transport icon type: $typeString, defaulting to ofType');
        return TransportIconType.ofType;
    }
  }
}

/// Represents a transport with icon and names
class Transport {
  const Transport({
    required this.icon,
    required this.names,
  });

  /// Creates a Transport from a map representation
  factory Transport.fromMap(Map<dynamic, dynamic> map) {
    try {
      final iconMap = map['icon'] as Map<dynamic, dynamic>?;
      if (iconMap == null) {
        throw ArgumentError('Transport icon is required');
      }

      return Transport(
        icon: TransportIcon.fromMap(iconMap),
        names: List<String>.from(map['names'] as List<dynamic>? ?? []),
      );
    } catch (error) {
      log('Error parsing Transport: $error');
      rethrow;
    }
  }

  final TransportIcon icon;
  final List<String> names;
}

/// Brief model for public transport route information
class BriefPublicTransportModel {
  const BriefPublicTransportModel({
    required this.duration,
    required this.transports,
    required this.transferCount,
    required this.onFootDuration,
    required this.publicTransportTransferRouteLongEntry,
  });

  /// Creates a BriefPublicTransportModel from a map representation
  factory BriefPublicTransportModel.fromMap(Map<dynamic, dynamic> map) {
    try {
      final transfers = map['publicTransportTransferRouteLongEntry'];
      log('Parsing transfers: ${transfers.runtimeType}');

      final transferRouteEntries = _parseTransferRouteEntries(transfers);

      return BriefPublicTransportModel(
        duration: map['duration'] as int? ?? 0,
        transports: _parseTransports(map['transports']),
        transferCount: map['transferCount'] as int? ?? 0,
        onFootDuration: map['onFootDuration'] as int? ?? 0,
        publicTransportTransferRouteLongEntry: transferRouteEntries,
      );
    } catch (error) {
      log('Error parsing BriefPublicTransportModel: $error');
      rethrow;
    }
  }

  final int duration;
  final List<Transport> transports;
  final int transferCount;
  final int onFootDuration;
  final List<PublicTransportTransferRouteLongEntryMessage> publicTransportTransferRouteLongEntry;

  /// Parses transport list from map
  static List<Transport> _parseTransports(dynamic transportsData) {
    if (transportsData is! List) {
      log('Transports data is not a list: ${transportsData.runtimeType}');
      return [];
    }

    return transportsData
        .whereType<Map<dynamic, dynamic>>()
        .map((transportMap) => Transport.fromMap(transportMap))
        .toList();
  }

  /// Parses transfer route entries from map
  static List<PublicTransportTransferRouteLongEntryMessage> _parseTransferRouteEntries(dynamic transfers) {
    if (transfers is! List) {
      log('Transfers is not a list: ${transfers.runtimeType}');
      return [];
    }

    return transfers.whereType<Map<dynamic, dynamic>>().map((transferMap) {
      try {
        return PublicTransportTransferRouteLongEntryMessageExt.fromJson(
          Map<String, dynamic>.from(transferMap),
        );
      } catch (error) {
        log('Error parsing transfer route entry: $error');
        rethrow;
      }
    }).toList();
  }
}

/// Types of transfer descriptions
enum TransferDescriptionType {
  /// Walking transfer
  onFoot,

  /// Metro transfer
  metro,

  /// Transport type transfer
  ofType,

  /// Final destination
  finish
}

/// Description of a transfer with type, color, and optional value
class TransferDescription {
  const TransferDescription({
    required this.type,
    required this.color,
    this.value,
  });

  /// Creates a TransferDescription from a map representation
  factory TransferDescription.fromMap(Map<dynamic, dynamic> map) {
    final typeString = map['type'];
    final type = _parseTransferDescriptionType(typeString);

    return TransferDescription(
      type: type,
      value: map['value'],
      color: _parseTextColor(map['color']),
    );
  }

  final TransferDescriptionType type;
  final dynamic value;
  final TextColor color;

  /// Parses transfer description type from string
  static TransferDescriptionType _parseTransferDescriptionType(dynamic typeString) {
    if (typeString is! String) {
      throw ArgumentError('Transfer description type must be a string: $typeString');
    }

    switch (typeString.toLowerCase()) {
      case 'onfoot':
        return TransferDescriptionType.onFoot;
      case 'metro':
        return TransferDescriptionType.metro;
      case 'oftype':
        return TransferDescriptionType.ofType;
      case 'finish':
        return TransferDescriptionType.finish;
      default:
        throw ArgumentError('Invalid TransferDescriptionType: $typeString');
    }
  }

  /// Parses text color from map
  static TextColor _parseTextColor(dynamic colorData) {
    if (colorData == null) {
      return const TextColor(
        type: TextColorType.normal,
        value: null,
      );
    }

    if (colorData is! Map<dynamic, dynamic>) {
      throw ArgumentError('Color data must be a map: $colorData');
    }

    return TextColor.fromMap(Map<String, dynamic>.from(colorData));
  }
}

/// Types of text color styling
enum TextColorType {
  /// Normal text color
  normal,

  /// Highlighted text color
  highlighted,

  /// Text color with specific value
  withValue
}

/// Represents text color with type and optional value
class TextColor {
  const TextColor({
    required this.type,
    this.value,
  });

  /// Creates a TextColor from a map representation
  factory TextColor.fromMap(Map<dynamic, dynamic> map) {
    final typeString = map['type'];
    final type = _parseTextColorType(typeString);

    return TextColor(
      type: type,
      value: map['value'],
    );
  }

  final TextColorType type;
  final dynamic value;

  /// Parses text color type from string
  static TextColorType _parseTextColorType(dynamic typeString) {
    if (typeString is! String) {
      throw ArgumentError('Text color type must be a string: $typeString');
    }

    switch (typeString.toLowerCase()) {
      case 'normal':
        return TextColorType.normal;
      case 'highlighted':
        return TextColorType.highlighted;
      case 'withvalue':
        return TextColorType.withValue;
      default:
        throw ArgumentError('Invalid TextColorType: $typeString');
    }
  }
}

/// Types of route colors
enum RouteColorType { normal, dimmed, withValue }

/// Represents route color with type and optional value
class RouteColor {
  const RouteColor({
    required this.type,
    this.value,
  });

  /// Creates a RouteColor from a map representation
  factory RouteColor.fromMap(Map<dynamic, dynamic> map) {
    final typeString = map['type'];
    final type = _parseRouteColorType(typeString);

    return RouteColor(
      type: type,
      value: map['value'] as int?,
    );
  }

  final RouteColorType type;
  final int? value;

  /// Parses route color type from string
  static RouteColorType _parseRouteColorType(dynamic typeString) {
    if (typeString is! String) {
      throw ArgumentError('Route color type must be a string: $typeString');
    }

    switch (typeString.toLowerCase()) {
      case 'normal':
        return RouteColorType.normal;
      case 'dimmed':
        return RouteColorType.dimmed;
      case 'withvalue':
        return RouteColorType.withValue;
      default:
        throw ArgumentError('Invalid RouteColorType: $typeString');
    }
  }
}

/// Types of transfer icons
enum TransferIconType {
  start,
  finish,
  empty,
  transport,
}

/// Represents a transfer icon with type and optional value
class TransferIcon {
  const TransferIcon({
    required this.type,
    this.value,
  });

  /// Creates a TransferIcon from a map representation
  factory TransferIcon.fromMap(Map<dynamic, dynamic> map) {
    final typeString = map['type'];
    final type = _parseTransferIconType(typeString);

    return TransferIcon(
      type: type,
      value: map['value'],
    );
  }

  final TransferIconType type;
  final dynamic value;

  /// Parses transfer icon type from string
  static TransferIconType _parseTransferIconType(dynamic typeString) {
    if (typeString is! String) {
      throw ArgumentError('Transfer icon type must be a string: $typeString');
    }

    switch (typeString.toLowerCase()) {
      case 'start':
        return TransferIconType.start;
      case 'finish':
        return TransferIconType.finish;
      case 'empty':
        return TransferIconType.empty;
      case 'transport':
        return TransferIconType.transport;
      default:
        throw ArgumentError('Invalid TransferIconType: $typeString');
    }
  }
}

/// Represents a car with highlighting information
class Car {
  const Car({
    required this.highlighted,
  });

  /// Creates a Car from a map representation
  factory Car.fromMap(Map<dynamic, dynamic> map) {
    return Car(
      highlighted: map['highlighted'] as bool? ?? false,
    );
  }

  final bool highlighted;
}

/// Represents a transfer with all its details
class Transfer {
  const Transfer({
    this.title,
    this.duration,
    required this.icon,
    this.lineColor,
    this.description,
    this.transports,
    this.stopCount,
    this.useStationsInsteadOfStops = false,
    this.getOffAfter,
    this.stops,
    this.boardingDescription,
    this.cars,
  });

  /// Creates a Transfer from a map representation
  factory Transfer.fromMap(Map<dynamic, dynamic> map) {
    return Transfer(
      title: map['title'] as String?,
      duration: map['duration'] as int?,
      icon: TransferIcon.fromMap(map['icon'] as Map<dynamic, dynamic>),
      lineColor: map['lineColor'] != null ? RouteColor.fromMap(map['lineColor'] as Map<dynamic, dynamic>) : null,
      description:
          map['description'] != null ? TransferDescription.fromMap(map['description'] as Map<dynamic, dynamic>) : null,
      transports: map['transports'] != null
          ? List<Transport>.from(
              (map['transports'] as List<dynamic>).map((x) => Transport.fromMap(x as Map<dynamic, dynamic>)),
            )
          : null,
      stopCount: map['stopCount'] as int?,
      useStationsInsteadOfStops: map['useStationsInsteadOfStops'] as bool? ?? false,
      getOffAfter: map['getOffAfter'] as String?,
      stops: map['stops'] != null ? List<String>.from((map['stops'] as List<dynamic>).map((x) => x as String)) : null,
      boardingDescription: map['boardingDescription'] as String?,
      cars: map['cars'] != null
          ? List<Car>.from((map['cars'] as List<dynamic>).map((x) => Car.fromMap(x as Map<dynamic, dynamic>)))
          : null,
    );
  }

  final String? title;
  final int? duration;
  final TransferIcon icon;
  final RouteColor? lineColor;
  final TransferDescription? description;
  final List<Transport>? transports;
  final int? stopCount;
  final bool useStationsInsteadOfStops;
  final String? getOffAfter;
  final List<String>? stops;
  final String? boardingDescription;
  final List<Car>? cars;
}

/// Complete public transport model with brief info and detailed transfers
class PublicTransportModel {
  const PublicTransportModel({
    required this.brief,
    required this.transfers,
  });

  /// Creates a PublicTransportModel from a map representation
  factory PublicTransportModel.fromMap(Map<dynamic, dynamic> map) {
    return PublicTransportModel(
      brief: BriefPublicTransportModel.fromMap(map['brief'] as Map<dynamic, dynamic>),
      transfers: List<Transfer>.from(
        (map['transfers'] as List<dynamic>).map((x) => Transfer.fromMap(x as Map<dynamic, dynamic>)),
      ),
    );
  }

  final BriefPublicTransportModel brief;
  final List<Transfer> transfers;
}
