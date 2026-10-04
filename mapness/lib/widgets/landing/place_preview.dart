import 'package:auto_route/auto_route.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart' hide ErrorWidget;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_generated/protocol/protocol.pb.dart' as proto;
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/app/auto_route/poi_card_ext.dart';
import 'package:mapness/features/landing/interesting_places.dart';
import 'package:mapness/features/poi_card/domain/model/poi_camera_config.dart';
import 'package:mapness/features/special_themes/modes/saudi_national_day/saudi_national_day.dart';
import 'package:mapness/l10n/generated/app_localizations_en.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/features/balady_analytics/metrics.dart';

const kPlaceCardSize = 300.0;

class PlacePreview extends ConsumerStatefulWidget {
  const PlacePreview({super.key});

  @override
  ConsumerState<PlacePreview> createState() => _PlacePreviewState();
}

class _PlacePreviewState extends ConsumerState<PlacePreview> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final isDGADark = context.read<ThemeController>().currentTheme == BaladyAppThemes.darkDGA;

    return ref
        .watch(interestingPlacesProvider)
        .when(
          data: (items) {
            final places = items
                .where(
                  (e) =>
                      e.tags.contains(proto.InterestingPlaceTag.INTERESTING_PLACE_CATEGORY_IMMERSIVE_MODEL) &&
                      e.preview.image.url.isNotEmpty,
                )
                .toList();

            return SliderListView(
              dotColor: isDGADark ? context.colors.staticWhite : context.colors.borderMuted,
              items: places,
              horizontalPadding: Spacing.$3x,
              separationWidth: Spacing.$2x,
              viewportWidth: MediaQuery.sizeOf(context).width,
              contentSize: kPlaceCardSize,
              activeDotColor: context.colors.accentDefault,

              ///todo must fix this with real color
              // activeDotColor: SaudiNationalDay.isNow() ? context.colors.staticWhite : null,
              onTap: (item) {
                final objectId = int.tryParse(item.entity.id) ?? 0;
                final point = item.location.point;
                Metrics.logEventAdvanced(
                  MetricsConstants.exploreKeys.placesToVisitBanner,
                  action: MetricAction.tap.name,
                  group: MetricsConstants.exploreTag,
                  props: {
                    'id': objectId,
                    'title': item.titleOrFallback(locale: AppLocalizationsEn()),
                  },
                );

                context.router.replaceOrPush(
                  route: PoiCardWidgetRoute(
                    objectId: DgisObjectIdMessage(objectId: objectId, entranceId: 0),
                    closestPoint: LatLng(latitude: point.latitude, longitude: point.longitude),
                    cameraConfig: const PoiCameraConfig(zoom: 20),
                  ),
                  toCompareRoutes: [PoiCardWidgetRoute.page],
                );
              },
              itemBuilder: (item) => _PlaceCard(item, key: ValueKey(item?.id)),
            );
          },
          error: (error, trace) => const Padding(
            padding: EdgeInsets.symmetric(horizontal: Spacing.$4x),
            child: _PlaceCard(null),
          ),
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(horizontal: Spacing.$4x),
            child: _PlaceCard(null),
          ),
        );
  }

  @override
  bool get wantKeepAlive => true;
}

class _PlaceCard extends StatelessWidget {
  final proto.InterestingPlace? item;

  const _PlaceCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(RadiusBorder.xl),
    child: Stack(
      children: [
        CachedNetworkImage(
          height: kPlaceCardSize,
          width: double.infinity,
          imageUrl: item?.preview.image.url ?? '',
          fit: BoxFit.cover,
          // Decode at display size instead of the full-resolution original. Only the height is set: with both
          // dimensions the image would be squeezed to the box (ignoring its aspect ratio) before `BoxFit.cover`.
          memCacheHeight: (kPlaceCardSize * MediaQuery.devicePixelRatioOf(context)).round(),
          imageBuilder: (context, imageProvider) => Stack(
            children: [
              // A foreground gradient instead of a `ShaderMask` (`srcATop` over an opaque image is a plain src-over
              // blend), which needed an offscreen layer for every card on each repaint of the sheet.
              DecoratedBox(
                position: DecorationPosition.foreground,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x00000000), Color(0x99000000)],
                  ),
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints.expand(),
                  child: Image(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
              Align(
                alignment: context.isLTR ? Alignment.bottomLeft : Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(Spacing.$6x),
                  child: Text(
                    item?.titleOrFallback(locale: context.l10n) ?? '',
                    style: context.textStyles.h2SemiBold.copyWith(color: context.colors.staticWhite),
                  ),
                ),
              ),
            ],
          ),
          progressIndicatorBuilder: (context, url, progress) => _ImagePlaceholder(progress: progress.progress),
          errorWidget: (context, error, _) => const _ImagePlaceholder(),
        ),
      ],
    ),
  );
}

class _ImagePlaceholder extends StatelessWidget {
  final double? progress;

  const _ImagePlaceholder({this.progress});

  @override
  Widget build(BuildContext context) => const ShimmerEffectWidget();
}
