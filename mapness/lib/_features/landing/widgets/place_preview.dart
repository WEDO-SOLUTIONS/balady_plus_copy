import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_features/landing/providers/interesting_places.dart';
import 'package:mapness/_features/landing/widgets/slider_list_view.dart';
import 'package:mapness/_generated/protocol/protocol.pb.dart' as proto;
import 'package:mapness/app/router.dart';
import 'package:mapness/app/routes/poi_map.dart';
import 'package:mapness/l10n/generated/app_localizations_en.dart';
import 'package:mapness/shared/config/package_config.dart';
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
              .where((e) =>
                  e.tags.contains(
                    proto.InterestingPlaceTag.INTERESTING_PLACE_CATEGORY_IMMERSIVE_MODEL,
                  ) &&
                  e.preview.image.url.isNotEmpty)
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

              PoiMapRoute.open(ref.read(goRouterProvider), objectId, zoom: 17);
            },
            itemBuilder: (item) => _PlaceCard(item),
          );
        },
        error: (error, trace) => ErrorSheet(
          onRetry: () => ref.invalidate(interestingPlacesProvider),
        ),
        loading: () => const LoadingSheet(),
      );
}

class _PlaceCard extends StatelessWidget {
  final proto.InterestingPlace item;

  const _PlaceCard(this.item);

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(RadiusBorder.xl),
        child: Stack(
          children: [
            ShaderMask(
              blendMode: BlendMode.srcATop,
              shaderCallback: (bounds) => LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [const Color(0x00000000), Colors.black.withOpacity(0.6)],
              ).createShader(bounds),
              child: CachedNetworkImage(
                height: 347,
                imageUrl: item.preview.image.url,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, progress) => ColoredBox(
                  color: context.colorsV2.backgroundSurface1,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: progress.progress,
                      color: context.color.strokePrimary,
                    ),
                  ),
                ),
                errorWidget: (context, error, _) => ColoredBox(
                  color: context.colorsV2.backgroundSurface1,
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images_svg/sad_face.svg',
                          package: PackageConfig.packageName,
                        ),
                        const SizedBox(height: Spacing.$4x),
                        Text(context.l10n.somethingWentWrong, style: context.textStyleV3.h2Medium),
                        const SizedBox(height: Spacing.$1x),
                        Text(context.l10n.pleaseTryAgainLater),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: context.isLTR ? Alignment.bottomLeft : Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(Spacing.$6x),
                child: Text(
                  item.titleOrFallback(locale: AppLocalizationsEn()),
                  style: context.textStyleV3.h2SemiBold.copyWith(
                    color: context.colorsV2.staticWhite,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
