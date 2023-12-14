import 'dart:ui';

import 'package:dgis_map/library.dart';
import 'package:mapness/_features/favourites/domain/favourite_item.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

enum RoutePointType { object, myLocation }

sealed class RoutePoint {
  String get icon;

  String? title(AppLocalizations locale);

  Color get titleColor;

  bool get isNotEmpty;

  double? get latitude;

  double? get longitude;
}

class RoutePointMyLocation extends RoutePoint {
  @override
  String get icon => "assets/icons/svg/ic_routing_location.svg";

  @override
  bool get isNotEmpty => true;

  @override
  double? get latitude => null;

  @override
  double? get longitude => null;

  @override
  String? title(AppLocalizations locale) {
    return locale.myLocation;
  }

  @override
  Color get titleColor => const Color(0xFF1E2A36);
}

class RoutePointDirectoryObject extends RoutePoint {
  final DirectoryObjectMessage? object;

  RoutePointDirectoryObject(this.object);

  @override
  String get icon => "assets/icons/svg/ic_routing_circle.svg";

  @override
  bool get isNotEmpty => object != null;

  @override
  double? get latitude => object?.markerPosition?.latitude;

  @override
  double? get longitude => object?.markerPosition?.longitude;

  @override
  String? title(AppLocalizations locale) {
    return object?.title;
  }

  @override
  Color get titleColor =>
      object == null ? const Color(0x801E2A36) : const Color(0xFF1E2A36);
}

class RoutePointFavouriteItem extends RoutePoint {
  final FavouriteItem? item;

  RoutePointFavouriteItem(this.item);

  @override
  String get icon => "assets/icons/svg/ic_routing_circle.svg";

  @override
  bool get isNotEmpty => item != null;

  @override
  double? get latitude => item?.coordinates.latitude;

  @override
  double? get longitude => item?.coordinates.longitude;

  @override
  String? title(AppLocalizations locale) {
    return item?.title;
  }

  @override
  Color get titleColor =>
      item == null ? const Color(0x801E2A36) : const Color(0xFF1E2A36);
}
