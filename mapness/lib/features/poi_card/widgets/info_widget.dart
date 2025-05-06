import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/feedback/page_params/feedback_route_params.dart';
import 'package:mapness/entities/routing/route_search_point.dart';
import 'package:mapness/features/favourites/providers/favourite_cache.dart';
import 'package:mapness/features/poi_card/domain/model/qr_trade_license.dart';
import 'package:mapness/features/poi_card/extensions/directory_object_ext.dart';
import 'package:mapness/features/poi_card/extensions/geopoint_mapper.dart';
import 'package:mapness/features/poi_card/provider/poi_card_actions_provider.dart';
import 'package:mapness/pages/feedback/quick_feedback_page.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/map/find_brief_route_info.dart';

class InfoWidget extends ConsumerWidget {
  final DirectoryObjectMessage? objectInfo;
  final QrLicenseMessage? qrTradeLicense;
  final VoidCallback onEntrancesTap;
  final RouteSearchPoint? finishPoint;

  InfoWidget({
    required this.objectInfo,
    required this.qrTradeLicense,
    required this.onEntrancesTap,
    super.key,
  }) : finishPoint = objectInfo != null
            ? RouteSearchPoint(
                coordinates: objectInfo.markerPosition?.toGeoPointMessage() ??
                    GeoPointMessage(
                      latitude: 0,
                      longitude: 0,
                    ),
                dgisObjectId: objectInfo.id!,
              )
            : null;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = objectInfo;

    if (data == null) {
      return const SizedBox.shrink();
    }

    final briefInfo = ref.watch(
      briefRouteInfoProvider(
        finishPoint: finishPoint,
        navType: RouteSearchOptionsMessage.car,
      ),
    );

    final favouritesState = ref.watch(favouriteCacheProvider);

    // On press the favourites we open the favourites page
    final void Function() onFavouritePressed = () {
      Metrics.logEventAdvanced(
        MetricsConstants.poiKeys.favorites,
        group: MetricsConstants.poiTag,
        action: MetricAction.tap.toString(),
      );

      context.router.push(const FavouritesRoute());
    };

    // On phone card tap handler
    final void Function(String) onPhoneTap = (phone) {
      ref.read(poiCardActionsProvider.notifier).callPhone(phone);
    };

    // On social media button tap handler
    final void Function(PoiContentSocialMediaType, String) onSocialMediaTap = (type, link) {
      if (type == PoiContentSocialMediaType.email) {
        ref.read(poiCardActionsProvider.notifier).sendEmail(link);
      } else {
        ref.read(poiCardActionsProvider.notifier).launch(link);
      }
    };

    final objectId = data.id?.objectId.toString();

    final feedback = PoiContentFeedback(
      onFeedbackTap: () {
        if (objectId == null) {
          return;
        }
        final objectIdInt = int.tryParse(objectId);
        if (objectIdInt == null) {
          return;
        }

        context.router.push(
          QuickFeedbackRoute(
            type: QuickFeedbackType.editCompany,
            params: FeedbackObjectIdParams(objectIdInt),
          ),
        );
      },
      title: context.l10n.dataIsIncorrect,
    );

    final poiContentData = PoiContentData(
      favourite: data.getFavourites(favouritesState, context.l10n, onFavouritePressed),
      fullAddress: data.getFullAddress(briefInfo, context.l10n, onEntrancesTap),
      about: data.getAbout(context.l10n),
      workTime: data.getOpeningHours(context.l10n),
      contacts: data.getContacts(onPhoneTap, onSocialMediaTap, context.l10n),
      license: data.getLicense(context.l10n),
      accessibilityInfo: data.getAccessibility(context.l10n, qrTradeLicense),
      parking: data.getParking(context.l10n),
      feedback: objectId != null ? feedback : null,
    );

    return PoiContent(
      padding: const EdgeInsets.all(Spacing.$4x).copyWith(top: Spacing.$3x),
      data: poiContentData,
    );
  }
}
