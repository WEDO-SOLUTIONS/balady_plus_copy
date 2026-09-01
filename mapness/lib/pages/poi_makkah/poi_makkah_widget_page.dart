import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:balady_plus/app/core/utils/extensions/str_conversion.dart';
import 'package:balady_uikit/balady_uikit.dart'
    show AppButton, ButtonColorScheme, ButtonSize, ButtonType, RadiusBorder, SliverFillAfter, Spacing;
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/favourites/favourite_item.dart';
import 'package:mapness/entities/makkah_places/makkah_place_model.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/entities/routing/route_search_point.dart';
import 'package:mapness/features/app_analytics/models/datafinder_mappers.dart';
import 'package:mapness/features/app_analytics/models/datafinder_models.dart';
import 'package:mapness/features/favourites/mappers/directory_object_message_mapper.dart';
import 'package:mapness/features/favourites/providers/favourite_cache.dart';
import 'package:mapness/features/makkah_places/makkah_multilingual_helper.dart';
import 'package:mapness/features/poi_card/data/poi_data_google.dart';
import 'package:mapness/features/poi_card/domain/model/poi_camera_config.dart';
import 'package:mapness/features/poi_card/domain/poi_card_state_mapper.dart';
import 'package:mapness/features/poi_card/enums/poi_card_bottom_sheet_state.dart';
import 'package:mapness/features/poi_card/extensions/date_time_ext.dart';
import 'package:mapness/features/poi_card/extensions/geopoint_mapper.dart';
import 'package:mapness/features/poi_card/widgets/photos_header/header_component.dart';
import 'package:mapness/features/poi_card/widgets/poi_card_header/header.dart';
import 'package:mapness/features/poi_card/widgets/poi_card_map_controls_wrapper.dart';
import 'package:mapness/features/poi_card/widgets/poi_photos_stories.dart';
import 'package:mapness/features/special_themes/core/places_activation_config.dart';
import 'package:mapness/features/special_themes/core/special_theme_mode.dart';
import 'package:mapness/widgets/landing/kaaba_virtual_journey_card.dart';
import 'package:mapness/features/special_themes/modes/mekkah_base/makkah_poi_constants.dart';
import 'package:mapness/shared/entities/coordinates.dart';
import 'package:mapness/shared/extensions/brief_route_info_message_ext.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/share_util.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/find_brief_route_info.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/features/parking_spot/parking_manage.dart';
import 'package:mapness/widgets/landing/place_preview_makkah.dart';
import 'package:mapness/widgets/search/ui/working_hours.dart';
import 'package:mapness/widgets/search/ui/working_hours_strings.dart';
import 'package:sheetify/sheetify.dart';
import 'package:urbi_utils/urbi_utils.dart';
import 'package:url_launcher/url_launcher.dart';

part 'poi_card_content.dart';
part 'poi_card_content_colors.dart';
part 'poi_card_content_footer.dart';
part 'poi_card_content_header.dart';
part 'poi_card_content_info.dart';
part 'poi_card_content_photos.dart';
part 'poi_content_working_hours_card.dart';

DirectoryObjectMessage _createDummyDirectoryObject({
  required BuildContext context,
  required int objectId,
  required LatLng? closestPoint,
  MakkahPlace? makkahPlace,
}) {
  final resolvedLatLng = (makkahPlace?.lat != null && makkahPlace?.lon != null)
      ? LatLng(latitude: makkahPlace!.lat!, longitude: makkahPlace.lon!)
      : closestPoint;

  final markerPosition = resolvedLatLng != null
      ? GeoPointWithElevationMessage(
          latitude: resolvedLatLng.latitude,
          longitude: resolvedLatLng.longitude,
          elevation: 0,
        )
      : GeoPointWithElevationMessage(
          // Default coordinates: Masjid al-Haram, Makkah
          latitude: 21.4225,
          longitude: 39.8262,
          elevation: 0,
        );

  final direction = Directionality.of(context);
  final title = makkahPlace == null
      ? context.l10n.exploreNearby
      : MakkahMultilingualHelper.getTitle(makkahPlace, direction, defaultValue: context.l10n.exploreNearby);
  final description = makkahPlace == null
      ? context.l10n.whatIsNewInBalady
      : MakkahMultilingualHelper.getDescription(makkahPlace, direction);

  return DirectoryObjectMessage(
    types: const [],
    title: title,
    titleAddition: '',
    subtitle: description,
    about: description,
    attributes: const [],
    contextAttributes: const [],
    contactInfos: const [],
    buildingInfo: BuildingInfoMessage(buildingName: title),
    entrances: const [],
    rubricIds: const [],
    routeInfos: const [],
    group: const [],
    id: DgisObjectIdMessage(objectId: objectId, entranceId: 0),
    markerPosition: markerPosition,
    platformIds: const [],
  );
}

Widget _makkahFooterSvgIcon(
  BuildContext context,
  String assetName, {
  Color? color,
  bool matchTextDirection = true,
}) {
  return SvgPicture.asset(
    assetName,
    width: 24,
    height: 24,
    colorFilter: ColorFilter.mode(color ?? context.colors.foregroundDefault, BlendMode.srcIn),
    matchTextDirection: matchTextDirection,
  );
}

@RoutePage()
class PoiMakkahWidgetPage extends StatelessWidget {
  final DgisObjectIdMessage? objectId;
  final int? dGisObjectId;
  final LatLng? closestPoint;
  final PoiCameraConfig? cameraConfig;
  final PoiCardDataFromGoogle? poiCardDataFromGoogle;
  final MakkahPlace? makkahPlace;

  const PoiMakkahWidgetPage({
    this.objectId,
    @QueryParam('dgis-object-id') this.dGisObjectId,
    this.closestPoint,
    this.cameraConfig,
    this.poiCardDataFromGoogle,
    this.makkahPlace,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedObjectId = objectId ?? DgisObjectIdMessage(objectId: dGisObjectId ?? 0, entranceId: 0);

    final photoUrls = (makkahPlace?.photoUrls ?? <String>[]).where((e) => e.trim().isNotEmpty).toList();

    final data = _createDummyDirectoryObject(
      context: context,
      objectId: resolvedObjectId.objectId,
      closestPoint: closestPoint,
      makkahPlace: makkahPlace,
    );

    return _PoiCardContent(
      data: data,
      objectId: resolvedObjectId.objectId,
      closestPoint: closestPoint,
      cameraConfig: cameraConfig,
      poiCardDataFromGoogle: poiCardDataFromGoogle,
      photoUrls: photoUrls,
      makkahPlace: makkahPlace,
    );
  }
}
