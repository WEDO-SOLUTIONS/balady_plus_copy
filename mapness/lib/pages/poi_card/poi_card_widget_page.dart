import 'dart:async';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/favourites/domain/extensions/extensions.dart';
import 'package:mapness/_features/favourites/domain/favourite_item.dart';
import 'package:mapness/_features/favourites/providers/favourite_cache.dart';
import 'package:mapness/_features/happiness_map/domain/happiness_feedback.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/entities/routing/route_search_point.dart';
import 'package:mapness/features/poi_card/domain/model/poi_camera_config.dart';
import 'package:mapness/features/poi_card/domain/poi_card_state_mapper.dart';
import 'package:mapness/features/poi_card/enums/contacts_info_type.dart';
import 'package:mapness/features/poi_card/enums/poi_card_bottom_sheet_state.dart';
import 'package:mapness/features/poi_card/enums/poi_tabs_type.dart';
import 'package:mapness/features/poi_card/extensions/directory_message_ext.dart';
import 'package:mapness/features/poi_card/extensions/geopoint_mapper.dart';
import 'package:mapness/features/poi_card/provider/poi_card_actions_provider.dart';
import 'package:mapness/features/poi_card/provider/poi_card_provider.dart';
import 'package:mapness/features/poi_card/provider/poi_photo_provider.dart';
import 'package:mapness/features/poi_card/widgets/footer/poi_card_footer.dart';
import 'package:mapness/features/poi_card/widgets/info_widget.dart';
import 'package:mapness/features/poi_card/widgets/photos_header/poi_photos_header.dart';
import 'package:mapness/features/poi_card/widgets/poi_card_header/header.dart';
import 'package:mapness/features/poi_card/widgets/poi_card_map_controls_wrapper.dart';
import 'package:mapness/features/poi_card/widgets/poi_favorite_dialog.dart';
import 'package:mapness/features/poi_card/widgets/poi_inbuilding_sliver.dart';
import 'package:mapness/features/poi_card/widgets/poi_loading_sheet.dart';
import 'package:mapness/features/poi_card/widgets/poi_photo_card_sliver.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/auth/auth_methods.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/map/camera_padding.dart';
import 'package:mapness/shared/providers/map/highlight.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/providers/map/point_of_interest.dart';
import 'package:mapness/shared/providers/map/selected_marker.dart';
import 'package:mapness/shared/ui/sheets/error_sheet.dart';
import 'package:mapness/shared/ui/sheets/error_sheet_v2.dart';
import 'package:sliver_tools/sliver_tools.dart';

part 'poi_card_content.dart';

part 'poi_card_wrapper.dart';

@RoutePage()
class PoiCardWidgetPage extends StatelessWidget {
  final DgisObjectIdMessage? objectId;
  final int? dGisObjectId;
  final LatLng? closestPoint;
  final PoiCameraConfig? cameraConfig;

  const PoiCardWidgetPage({
    this.objectId,
    @QueryParam('dgis-object-id') this.dGisObjectId,
    this.closestPoint,
    this.cameraConfig,
    super.key,
  });

  @override
  Widget build(BuildContext context) => _PoiCardWrapper(
        objectId: objectId ??
            DgisObjectIdMessage(
              objectId: dGisObjectId ?? 0,
              entranceId: 0,
            ),
        cameraConfig: cameraConfig,
        closestPoint: closestPoint,
        key: key,
      );
}
