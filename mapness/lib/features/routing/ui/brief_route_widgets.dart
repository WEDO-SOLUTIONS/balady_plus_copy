import 'package:balady_uikit/core/typography/text_theme_styles.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/entities/routing/route_search_point.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/app_features.dart';
import 'package:mapness/shared/providers/map/find_brief_route_info.dart';

class BriefRouteButton extends ConsumerWidget {
  const BriefRouteButton({
    required this.routeType,
    required this.onTap,
    this.startPoint,
    this.finishPoint,
    this.padding,
    this.foreground,
    this.background,
    super.key,
  });

  final VoidCallback onTap;
  final RouteSearchOptionsMessage routeType;
  final RouteSearchPoint? startPoint;
  final RouteSearchPoint? finishPoint;
  final EdgeInsetsGeometry? padding;
  final Color? foreground;
  final Color? background;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appFeatures = ref.watch(appFeaturesProvider);
    final briefInfo = ref.watch(briefRouteInfoProvider(
      startPoint: startPoint,
      finishPoint: finishPoint,
      navType: routeType,
    ),);

    return appFeatures.naviEnabled
        ? Padding(
            padding: padding ?? const EdgeInsets.all(0),
            child: Material(
              color: background ?? context.color.strokeAccent,
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 9,
                  ),
                  child: _BriefRouteInfo(
                    iconSize: 24,
                    iconColor: foreground ?? Colors.white,
                    textColor: foreground ?? Colors.white,
                    briefInfo: briefInfo,
                  ),
                ),
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}

class BriefRouteInfo extends ConsumerWidget {
  const BriefRouteInfo({
    required this.routeType,
    super.key,
    this.startPoint,
    this.finishPoint,
  });

  final RouteSearchOptionsMessage routeType;
  final RouteSearchPoint? startPoint;
  final RouteSearchPoint? finishPoint;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appFeatures = ref.watch(appFeaturesProvider);
    final briefInfo = ref.watch(briefRouteInfoProvider(
      startPoint: startPoint,
      finishPoint: finishPoint,
      navType: routeType,
    ),);

    return (briefInfo != null && appFeatures.naviEnabled)
        ? _BriefRouteInfo(
            iconSize: 16,
            iconColor: context.color.textAndIconsBaseTertiary,
            textColor: context.color.textAndIconsBasePrimary,
            briefInfo: briefInfo,
          )
        : const SizedBox.shrink();
  }
}

class _BriefRouteInfo extends StatelessWidget {
  const _BriefRouteInfo({
    required this.iconColor,
    required this.iconSize,
    required this.textColor,
    required this.briefInfo,
  });

  final List<BriefRouteInfoMessage>? briefInfo;

  final Color iconColor;
  final Color textColor;
  final double iconSize;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/svg/ic_car_poi.svg',
            height: iconSize,
            width: iconSize,
            package: PackageConfig.packageName,
            matchTextDirection: true,
            colorFilter: ColorFilter.mode(
              iconColor,
              BlendMode.srcATop,
            ),
          ),
          if (briefInfo != null) ...[
            const SizedBox(
              width: 4,
            ),
            Text(
              getBriefRouteDescription(briefInfo!, context.l10n),
              style: Theme.of(context)
                  .extension<ThemeTextStyles>()!
                  .footNoteBold
                  .copyWith(
                    color: textColor,
                  ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.right,
            ),
          ],
        ],
      );

  String getBriefRouteDescription(
      List<BriefRouteInfoMessage> briefInfo, AppLocalizations l10n,) {
    final int = briefInfo.first.duration.toInt();
    final duration = Duration(seconds: int);
    final inMinutes = duration.inMinutes;
    if (inMinutes < 60) {
      return '$inMinutes ${l10n.min}';
    } else {
      final inHours = duration.inHours;
      return '$inHours ${l10n.hrs}';
    }
  }
}
