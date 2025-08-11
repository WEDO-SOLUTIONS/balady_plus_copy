import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/entities/favourites/favourite_item.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';

enum RoutePointType { object, myLocation }

sealed class RoutePoint {
  String get icon;

  String? title(AppLocalizations locale);

  Color titleColor(BuildContext context);

  bool get isNotEmpty;

  double? get latitude;

  double? get longitude;

  int? get objectId;

  int? get entranceId;

  int? get levelId;

  String? get label;
}

class RoutePointMyLocation extends RoutePoint {
  @override
  String get icon => Assets.icons.svg.icRoutingLocation.keyName;

  @override
  bool get isNotEmpty => true;

  @override
  double? get latitude => null;

  @override
  double? get longitude => null;

  @override
  int? get objectId => null;

  @override
  int? get entranceId => null;

  @override
  int? get levelId => null;

  @override
  String? title(AppLocalizations locale) => locale.myLocation;

  @override
  Color titleColor(BuildContext context) => context.color.textAndIconsBasePrimary;

  @override
  String? get label => null;
}

class RoutePointCoordinates extends RoutePoint {
  RoutePointCoordinates(this.coords, this.address, this.levelIdParam);

  final GeoPointMessage coords;
  final String? address;
  final int? levelIdParam;

  @override
  String get icon => Assets.icons.svg.icRoutingCircle.keyName;

  @override
  bool get isNotEmpty => true;

  @override
  double? get latitude => coords.latitude;

  @override
  double? get longitude => coords.longitude;

  @override
  int? get entranceId => null;

  @override
  int? get levelId => levelIdParam;

  @override
  int? get objectId => null;

  @override
  String? title(AppLocalizations locale) => label;

  @override
  Color titleColor(BuildContext context) => context.color.textAndIconsBasePrimary;

  @override
  String? get label => address;
}

class RoutePointDirectoryObject extends RoutePoint {
  RoutePointDirectoryObject(this.object);
  final DirectoryObjectMessage? object;

  @override
  String get icon => Assets.icons.svg.icRoutingCircle.keyName;

  @override
  bool get isNotEmpty => object != null;

  @override
  double? get latitude => object?.markerPosition?.latitude;

  @override
  double? get longitude => object?.markerPosition?.longitude;

  @override
  int? get objectId => object?.id?.objectId;

  @override
  int? get entranceId => object?.id?.entranceId;

  @override
  int? get levelId => object?.levelId;

  @override
  String? title(AppLocalizations locale) => object?.title;

  @override
  Color titleColor(BuildContext context) =>
      object == null ? context.color.textAndIconsBaseTertiary : context.color.textAndIconsBasePrimary;

  @override
  String? get label => null;
}

class RoutePointFavouriteItem extends RoutePoint {
  RoutePointFavouriteItem(this.item);
  final FavouriteItem? item;

  @override
  String get icon => Assets.icons.svg.icRoutingCircle.keyName;

  @override
  bool get isNotEmpty => item != null;

  @override
  double? get latitude => item?.coordinates.latitude;

  @override
  double? get longitude => item?.coordinates.longitude;

  @override
  int? get objectId => null;

  @override
  int? get entranceId => null;

  @override
  int? get levelId => null;

  @override
  String? title(AppLocalizations locale) => item?.title;

  @override
  Color titleColor(BuildContext context) =>
      item == null ? context.color.textAndIconsBaseTertiary : context.color.textAndIconsBasePrimary;

  @override
  String? get label => null;
}
