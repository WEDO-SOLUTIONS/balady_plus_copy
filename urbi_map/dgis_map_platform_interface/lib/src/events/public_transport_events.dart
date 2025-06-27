class PublicTransportRoutesChangedEvent {
  PublicTransportRoutesChangedEvent(this.routes);

  static const name = "onPublicTransportRoutesChanged";

  final List<BriefPublicTransportModel> routes;
}

class PublicTransportActiveRouteChanged {
  PublicTransportActiveRouteChanged(this.route);

  static const name = "onPublicTransportActiveRouteChanged";

  final PublicTransportModel route;
}

enum TransportIconType { ofType, combined, special }

class TransportIcon {
  factory TransportIcon.fromMap(Map<dynamic, dynamic> map) {
    final String typeString = map['type'];
    TransportIconType type;
    switch (typeString) {
      case 'ofType':
        type = TransportIconType.ofType;
        break;
      case 'combined':
        type = TransportIconType.combined;
        break;
      case 'special':
        type = TransportIconType.special;
        break;
      default:
        throw ArgumentError('Invalid TransportIconType: $typeString');
    }
    return TransportIcon(
      type: type,
      value: map['value'],
      color: map['color'],
    );
  }

  TransportIcon({
    required this.type,
    required this.value,
    this.color,
  });

  final TransportIconType type;
  final String value;
  final int? color;
}

class Transport {
  factory Transport.fromMap(Map<dynamic, dynamic> map) {
    return Transport(
      icon: TransportIcon.fromMap(map['icon']),
      names: List<String>.from(map['names']),
    );
  }

  Transport({
    required this.icon,
    required this.names,
  });

  final TransportIcon icon;
  final List<String> names;
}

class BriefPublicTransportModel {
  factory BriefPublicTransportModel.fromMap(Map<dynamic, dynamic> map) {
    final transfers = map['publicTransportTransferRouteLongEntry'] as List<dynamic>?;
    return BriefPublicTransportModel(
      duration: map['duration'],
      transports: List<Transport>.from(
        (map['transports'] as List<dynamic>).map((x) => Transport.fromMap(x as Map<dynamic, dynamic>)),
      ),
      transferCount: map['transferCount'],
      onFootDuration: map['onFootDuration'],
      publicTransportTransferRouteLongEntry: map['publicTransportTransferRouteLongEntry'],
    );
  }

  const BriefPublicTransportModel({
    required this.duration,
    required this.transports,
    required this.transferCount,
    required this.onFootDuration,
    required this.publicTransportTransferRouteLongEntry,
  });

  final int duration;
  final List<Transport> transports;
  final int transferCount;
  final int onFootDuration;
  final List<Map<String, dynamic>> publicTransportTransferRouteLongEntry;
}

enum TransferDescriptionType { onFoot, metro, ofType, finish }

class TransferDescription {
  TransferDescription({
    required this.type,
    required this.color,
    this.value,
  });

  factory TransferDescription.fromMap(Map<dynamic, dynamic> map) {
    final typeString = map['type'];

    TransferDescriptionType type;
    switch (typeString) {
      case 'onFoot':
        type = TransferDescriptionType.onFoot;
        break;
      case 'metro':
        type = TransferDescriptionType.metro;
        break;
      case 'ofType':
        type = TransferDescriptionType.ofType;
        break;
      case 'finish':
        type = TransferDescriptionType.finish;
        break;
      default:
        throw ArgumentError('Invalid TransferDescriptionType: $typeString');
    }

    return TransferDescription(
      type: type,
      value: map['value'],
      color: map['color'] != null
          ? TextColor.fromMap(map['color'])
          : const TextColor(
              type: TextColorType.normal,
              value: null,
            ),
    );
  }
  final TransferDescriptionType type;
  final dynamic value;
  final TextColor color;
}

enum TextColorType { normal, highlighted, withValue }

class TextColor {
  const TextColor({
    required this.type,
    this.value,
  });

  factory TextColor.fromMap(Map<dynamic, dynamic> map) {
    final typeString = map['type'];

    TextColorType type;
    switch (typeString) {
      case 'normal':
        type = TextColorType.normal;
        break;
      case 'highlighted':
        type = TextColorType.highlighted;
        break;
      case 'withValue':
        type = TextColorType.withValue;
        break;
      default:
        throw ArgumentError('Invalid TextColorType: $typeString');
    }

    return TextColor(
      type: type,
      value: map['value'],
    );
  }
  final TextColorType type;
  final int? value;
}

enum RouteColorType {
  normal,
  dimmed,
  withValue,
}

class RouteColor {
  RouteColor({
    required this.type,
    this.value,
  });

  factory RouteColor.fromMap(Map<dynamic, dynamic> map) {
    final typeString = map['type'];

    RouteColorType type;
    switch (typeString) {
      case 'normal':
        type = RouteColorType.normal;
        break;
      case 'dimmed':
        type = RouteColorType.dimmed;
        break;
      case 'withValue':
        type = RouteColorType.withValue;
        break;
      default:
        throw ArgumentError('Invalid RouteColorType: $typeString');
    }

    return RouteColor(
      type: type,
      value: map['value'],
    );
  }
  final RouteColorType type;
  final int? value;
}

enum TransferIconType {
  start,
  finish,
  empty,
  transport,
}

class TransferIcon {
  TransferIcon({
    required this.type,
    this.value,
  });

  factory TransferIcon.fromMap(Map<dynamic, dynamic> map) {
    final typeString = map['type'];

    TransferIconType type;
    switch (typeString) {
      case 'start':
        type = TransferIconType.start;
        break;
      case 'finish':
        type = TransferIconType.finish;
        break;
      case 'empty':
        type = TransferIconType.empty;
        break;
      case 'transport':
        type = TransferIconType.transport;
        break;
      default:
        throw ArgumentError('Invalid RouteColorType: $typeString');
    }

    return TransferIcon(
      type: type,
      value: map['value'],
    );
  }
  final TransferIconType type;
  final dynamic value;
}

class Car {
  Car({
    required this.highlighted,
  });

  factory Car.fromMap(Map<dynamic, dynamic> map) {
    return Car(
      highlighted: map['highlighted'],
    );
  }
  final bool highlighted;
}

class Transfer {
  Transfer({
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

  factory Transfer.fromMap(Map<dynamic, dynamic> map) {
    return Transfer(
      title: map['title'],
      duration: map['duration'],
      icon: TransferIcon.fromMap(map['icon']),
      lineColor: map['lineColor'] != null ? RouteColor.fromMap(map['lineColor']) : null,
      description: map['description'] != null ? TransferDescription.fromMap(map['description']) : null,
      transports:
          map['transports'] != null ? List<Transport>.from(map['transports'].map((x) => Transport.fromMap(x))) : null,
      stopCount: map['stopCount'],
      useStationsInsteadOfStops: map['useStationsInsteadOfStops'],
      getOffAfter: map['getOffAfter'],
      stops: map['stops'] != null ? List<String>.from(map['stops'].map((x) => x as String)) : null,
      boardingDescription: map['boardingDescription'],
      cars: map['cars'] != null ? List<Car>.from(map['cars'].map((x) => Car.fromMap(x))) : null,
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

class PublicTransportModel {
  factory PublicTransportModel.fromMap(Map<dynamic, dynamic> map) {
    return PublicTransportModel(
      brief: BriefPublicTransportModel.fromMap(map['brief']),
      transfers: List<Transfer>.from(
        (map['transfers'] as List<dynamic>).map((x) => Transfer.fromMap(x as Map<dynamic, dynamic>)),
      ),
    );
  }

  const PublicTransportModel({
    required this.brief,
    required this.transfers,
  });

  final BriefPublicTransportModel brief;
  final List<Transfer> transfers;
}
