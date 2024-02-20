import 'dart:ui';

import 'package:dgis_map/library.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/_features/favourites/domain/favourite_item.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

enum RoutePointType { object, myLocation }

sealed class RoutePoint {
  String get icon;

  String? title(AppLocalizations locale);

  Color titleColor(BuildContext context);

  bool get isNotEmpty;

  double? get latitude;

  double? get longitude;
}

class RoutePointMyLocation extends RoutePoint {
  @override
  String get icon => 'assets/icons/svg/ic_routing_location.svg';

  @override
  bool get isNotEmpty => true;

  @override
  double? get latitude => null;

  @override
  double? get longitude => null;

  @override
  String? title(AppLocalizations locale) => locale.myLocation;

  @override
  Color titleColor(BuildContext context) => context.color.text_and_icons_base_primary;
}

class RoutePointCoordinates extends RoutePoint {
  final GeoPointMessage coords;

  RoutePointCoordinates(this.coords);

  @override
  String get icon => 'assets/icons/svg/ic_routing_circle.svg';

  @override
  bool get isNotEmpty => true;

  @override
  double? get latitude => coords.latitude;

  @override
  double? get longitude => coords.longitude;

  @override
  String? title(AppLocalizations locale) =>
      '${coords.latitude.toStringAsFixed(5)}, ${coords.longitude.toStringAsFixed(5)}';

  @override
  Color titleColor(BuildContext context) => context.color.text_and_icons_base_primary;
}

class RoutePointDirectoryObject extends RoutePoint {
  final DirectoryObjectMessage? object;

  RoutePointDirectoryObject(this.object);

  @override
  String get icon => 'assets/icons/svg/ic_routing_circle.svg';

  @override
  bool get isNotEmpty => object != null;

  @override
  double? get latitude => object?.markerPosition?.latitude;

  @override
  double? get longitude => object?.markerPosition?.longitude;

  @override
  String? title(AppLocalizations locale) => object?.title;

  @override
  Color titleColor(BuildContext context) =>
      object == null ? context.color.text_and_icons_base_tertiary :
      context.color.text_and_icons_base_primary;
}

class RoutePointFavouriteItem extends RoutePoint {
  final FavouriteItem? item;

  RoutePointFavouriteItem(this.item);

  @override
  String get icon => 'assets/icons/svg/ic_routing_circle.svg';

  @override
  bool get isNotEmpty => item != null;

  @override
  double? get latitude => item?.coordinates.latitude;

  @override
  double? get longitude => item?.coordinates.longitude;

  @override
  String? title(AppLocalizations locale) => item?.title;

  @override
  Color titleColor(BuildContext context) =>
      item == null ? context.color.text_and_icons_base_tertiary : context.color.text_and_icons_base_primary;
}
