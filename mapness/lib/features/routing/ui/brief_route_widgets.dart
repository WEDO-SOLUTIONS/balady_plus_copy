import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/entities/routing/route_search_point.dart';
import 'package:mapness/shared/extensions/brief_route_info_message_ext.dart';
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
    this.type = BriefRouteInfoType.duration,
  });

  final VoidCallback onTap;
  final RouteSearchOptionsMessage routeType;
  final RouteSearchPoint? startPoint;
  final RouteSearchPoint? finishPoint;
  final EdgeInsetsGeometry? padding;
  final Color? foreground;
  final Color? background;
  final BriefRouteInfoType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appFeatures = ref.watch(appFeaturesProvider);
    final briefInfo = ref.watch(
      briefRouteInfoProvider(
        startPoint: startPoint,
        finishPoint: finishPoint,
        navType: routeType,
      ),
    );

    return appFeatures.naviEnabled
        ? Padding(
            padding: padding ?? const EdgeInsets.all(0),
            child: Material(
              color: background ?? context.colors.accentOnContainer,
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
                    type: type,
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

enum BriefRouteInfoType {
  duration,
  distance,
}

class BriefRouteInfo extends ConsumerWidget {
  const BriefRouteInfo({
    required this.routeType,
    this.type = BriefRouteInfoType.duration,
    super.key,
    this.startPoint,
    this.finishPoint,
  });

  final BriefRouteInfoType? type;
  final RouteSearchOptionsMessage routeType;
  final RouteSearchPoint? startPoint;
  final RouteSearchPoint? finishPoint;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appFeatures = ref.watch(appFeaturesProvider);
    final briefInfo = ref.watch(
      briefRouteInfoProvider(
        startPoint: startPoint,
        finishPoint: finishPoint,
        navType: routeType,
      ),
    );

    return (briefInfo != null && appFeatures.naviEnabled)
        ? _BriefRouteInfo(
            type: type,
            iconSize: 16,
            iconColor: context.colors.foregroundMuted,
            textColor: context.colors.foregroundDefault,
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
    required this.type,
  });

  final List<BriefRouteInfoMessage>? briefInfo;

  final BriefRouteInfoType? type;
  final Color iconColor;
  final Color textColor;
  final double iconSize;

  String obtainText(BuildContext context) => switch (type) {
        BriefRouteInfoType.duration => briefInfo?.first.getBriefRouteDescription(context.l10n) ?? '',
        BriefRouteInfoType.distance => briefInfo?.first.getBriefRouteDistanceDescription(context.l10n) ?? '',
        _ => '',
      };

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            Assets.icons.svg.icCarPoi.keyName,
            height: iconSize,
            width: iconSize,
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
              obtainText(context),
              style: context.textStyle.footNoteBold.copyWith(
                color: textColor,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.right,
            ),
          ],
        ],
      );
}
