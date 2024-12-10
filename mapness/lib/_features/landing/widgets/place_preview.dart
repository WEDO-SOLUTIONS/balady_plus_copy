import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/landing/providers/interesting_places.dart';
import 'package:mapness/_features/landing/widgets/slider_list_view.dart';
import 'package:mapness/_generated/protocol/protocol.pb.dart' as proto;
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/app/auto_route/poi_card_ext.dart';
import 'package:mapness/features/poi_card/domain/model/poi_camera_config.dart';
import 'package:mapness/l10n/generated/app_localizations_en.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/ui/sheets/error_sheet.dart';
import 'package:mapness/shared/ui/sheets/loading_sheet.dart';

class PlacePreview extends ConsumerWidget {
  const PlacePreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => ref.watch(interestingPlacesProvider).when(
        data: (items) {
          final places = items
              .where(
                (e) =>
                    e.tags.contains(
                      proto.InterestingPlaceTag.INTERESTING_PLACE_CATEGORY_IMMERSIVE_MODEL,
                    ) &&
                    e.preview.image.url.isNotEmpty,
              )
              .toList();

          return SliderListView(
            items: places,
            contentHeight: 347,
            onTap: (item) {
              final objectId = int.tryParse(item.entity.id) ?? 0;
              Metrics.logEventAdvanced(
                MetricsConstants.exploreKeys.placesToVisitBanner,
                action: MetricAction.tap.name,
                group: MetricsConstants.exploreTag,
                props: {
                  'id': objectId,
                  'title': item.titleOrFallback(
                    locale: AppLocalizationsEn(),
                  ),
                },
              );

              context.router.replaceOrPush(
                route: PoiCardWidgetRoute(
                  objectId: DgisObjectIdMessage(
                    objectId: objectId,
                    entranceId: 0,
                  ),
                  cameraConfig: const PoiCameraConfig(zoom: 17),
                ),
                toCompareRoutes: [PoiCardWidgetRoute.page],
              );
            },
            itemBuilder: (item) => _PlaceCard(item, key: ValueKey(item?.id)),
          );
        },
        error: (error, trace) => ErrorSheet(
          onRetry: () => ref.invalidate(interestingPlacesProvider),
        ),
        loading: () => const LoadingSheet(),
      );
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
              height: 347,
              imageUrl: item?.preview.image.url ?? '',
              fit: BoxFit.cover,
              imageBuilder: (context, imageProvider) => Stack(
                children: [
                  ShaderMask(
                    blendMode: BlendMode.srcATop,
                    shaderCallback: (bounds) => LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [const Color(0x00000000), Colors.black.withOpacity(0.6)],
                    ).createShader(bounds),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints.expand(),
                      child: Image(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Align(
                    alignment: context.isLTR ? Alignment.bottomLeft : Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(Spacing.$6x),
                      child: Text(
                        item?.titleOrFallback(locale: context.l10n) ?? '',
                        style: context.textStyleV3.h2SemiBold.copyWith(
                          color: context.colorsV2.staticWhite,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              progressIndicatorBuilder: (context, url, progress) => _ImagePlaceholder(
                progress: progress.progress,
              ),
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
  Widget build(BuildContext context) => ColoredBox(
        color: context.colorsV2.backgroundSurface5,
        child: Center(
          child: SizedBox(
            child: CircularProgressIndicator(
              value: progress,
              color: context.colorsV2.borderDefault,
              backgroundColor: context.colorsV2.borderMuted,
              strokeCap: StrokeCap.round,
            ),
          ),
        ),
      );
}
