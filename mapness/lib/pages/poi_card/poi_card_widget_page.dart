import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart'
    show
        ConfettiAnimation,
        ConfettiGeneratorConfig,
        General16Icons,
        GeneralIcons,
        ShiningShape,
        SliverFillAfter,
        Spacing;
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/city_event/city_event.dart';
import 'package:mapness/entities/favourites/favourite_item.dart';
import 'package:mapness/entities/feedback/page_params/feedback_route_params.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/entities/routing/route_search_point.dart';
import 'package:mapness/entities/routing/route_search_point_mapper.dart';
import 'package:mapness/entities/wrc/wrc_event.dart';
import 'package:mapness/features/ai_summary/domain/ai_summary_scope.dart';
import 'package:mapness/features/ai_summary/state/ai_summary_notifier.dart';
import 'package:mapness/features/city_event/active_city_event.dart';
import 'package:mapness/features/cityscape/cityscape.dart';
import 'package:mapness/features/favourites/mappers/directory_object_message_mapper.dart';
import 'package:mapness/features/favourites/providers/favourite_cache.dart';
import 'package:mapness/features/founding_day/founding_day.dart';
import 'package:mapness/features/leap/leap.dart';
import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:mapness/features/parking_spot/parking_manage.dart';
import 'package:mapness/features/poi_card/data/poi_data_google.dart';
import 'package:mapness/features/poi_card/domain/model/loading_or_failure_model.dart';
import 'package:mapness/features/poi_card/domain/model/poi_camera_config.dart';
import 'package:mapness/features/poi_card/domain/model/poi_content/src/poi_content_feedback.dart';
import 'package:mapness/features/poi_card/domain/poi_card_state_mapper.dart';
import 'package:mapness/features/poi_card/enums/contacts_info_type.dart';
import 'package:mapness/features/poi_card/enums/poi_card_bottom_sheet_state.dart';
import 'package:mapness/features/poi_card/enums/poi_tabs_type.dart';
import 'package:mapness/features/poi_card/extensions/geopoint_mapper.dart';
import 'package:mapness/features/poi_card/extensions/poi_content/poi_content_ext.dart';
import 'package:mapness/features/poi_card/provider/poi_card_actions_provider.dart';
import 'package:mapness/features/poi_card/provider/poi_card_closing.dart';
import 'package:mapness/features/poi_card/provider/poi_card_provider.dart';
import 'package:mapness/features/poi_card/provider/poi_photo_provider.dart';
import 'package:mapness/features/poi_card/widgets/footer/poi_card_footer.dart';
import 'package:mapness/features/poi_card/widgets/photos_header/header_component.dart';
import 'package:mapness/features/poi_card/widgets/photos_header/poi_photos_header.dart';
import 'package:mapness/features/poi_card/widgets/poi_card_header/header.dart';
import 'package:mapness/features/poi_card/widgets/poi_card_map_controls_wrapper.dart';
import 'package:mapness/features/poi_card/widgets/poi_content/src/poi_content_about_card.dart';
import 'package:mapness/features/poi_card/widgets/poi_content/src/poi_content_contacts_card.dart';
import 'package:mapness/features/poi_card/widgets/poi_content/src/poi_content_feedback_banner.dart';
import 'package:mapness/features/poi_card/widgets/poi_content_sliver.dart';
import 'package:mapness/features/poi_card/widgets/poi_inbuilding_sliver.dart';
import 'package:mapness/features/poi_card/widgets/poi_photo_card_sliver.dart';
import 'package:mapness/features/routing/lib/active_navigation_helper.dart';
import 'package:mapness/features/routing/providers/current_route.dart';
import 'package:mapness/features/wrc/wrc.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/pages/feedback/quick_feedback_page.dart';
import 'package:mapness/pages/path_nav/path_nav_page.dart';
import 'package:mapness/pages/poi_card/parking_content.dart';
import 'package:mapness/pages/poi_card/poi_card_error_or_loading.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/brief_route_info_message_ext.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/extensions/parking_store_model_ext.dart';
import 'package:mapness/shared/hooks/toggle_sheet_controller_hook.dart';
import 'package:mapness/shared/lib/auth/auth_methods.dart';
import 'package:mapness/shared/lib/make_address.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/analytic/bss_service.dart';
import 'package:mapness/shared/providers/analytic/models/bss_request.dart';
import 'package:mapness/shared/providers/analytic/models/extensions/directory_obj_ext.dart';
import 'package:mapness/features/app_analytics/models/datafinder_mappers.dart';
import 'package:mapness/features/app_analytics/models/datafinder_models.dart';
import 'package:mapness/shared/providers/analytic/models/payload/bss_payload.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/camera_padding.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/find_brief_route_info.dart';
import 'package:mapness/shared/providers/map/find_brief_route_info_v2.dart';
import 'package:mapness/shared/providers/map/highlight.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/providers/map/point_of_interest.dart';
import 'package:mapness/shared/providers/map/selected_marker.dart';
import 'package:mapness/shared/providers/regular_poi_active.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:sheetify/sheetify.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:urbi_utils/urbi_utils.dart';

part 'cityscape_card_content.dart';
part 'founding_day_card_content.dart';
part 'poi_card_content.dart';
part 'poi_card_no_info.dart';
part 'poi_card_wrapper.dart';
part 'poi_functions.dart';
part 'wrc_card_content.dart';

@RoutePage()
class PoiCardWidgetPage extends StatelessWidget {
  final DgisObjectIdMessage? objectId;
  final int? dGisObjectId;
  final LatLng? closestPoint;
  final PoiCameraConfig? cameraConfig;
  final PoiCardDataFromGoogle? poiCardDataFromGoogle;
  final bool showHighlight;

  const PoiCardWidgetPage({
    this.objectId,
    @QueryParam('dgis-object-id') this.dGisObjectId,
    this.closestPoint,
    this.cameraConfig,
    this.poiCardDataFromGoogle,
    this.showHighlight = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) => PopScope(
    onPopInvokedWithResult: (didPop, result) {
      final container = ProviderScope.containerOf(context, listen: false);
      container.read(regularPoiActiveProvider.notifier).setActive(false);
    },
    child: _PoiCardWrapper(
      objectId: objectId ?? DgisObjectIdMessage(objectId: dGisObjectId ?? 0, entranceId: 0),
      cameraConfig: cameraConfig,
      poiCardDataFromGoogle: poiCardDataFromGoogle,
      closestPoint: closestPoint,
      showHighlight: showHighlight,
      key: key,
    ),
  );
}
