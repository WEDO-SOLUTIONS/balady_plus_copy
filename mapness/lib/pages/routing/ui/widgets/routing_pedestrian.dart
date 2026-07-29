import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:mapness/pages/routing/ui/models/routing_details_ui_model.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/utils/text_utils/arabic_numerals.dart';
import 'package:mapness/widgets/routing/lib/duration_distance_fmt.dart';

class RoutingPedestrian extends StatelessWidget {
  final RouteDetailsPublicTransportPedestrian data;
  const RoutingPedestrian({
    required this.data,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorLine = context.colors.neutralDefault;
    final textStyle = context.textStyles.bodyLargeRegular;
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          Spacing.$3x.widthBox,
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 2,
                height: 48,
                color: colorLine,
              ),
              Container(
                width: 24,
                height: 24,
                color: context.colors.backgroundSurface1,
                child: Icon(getStepIcon(context), color: colorLine, size: 16),
              ),
            ],
          ),
          Spacing.$3x.widthBox,
          Row(
            children: [
              if (data.isTransfer)
                Text(
                  context.l10n.changeLine,
                  style: textStyle.copyWith(color: context.colors.foregroundDefault),
                )
              else
                Text(
                  '${data.lengthInMeters.formatDistance(context.l10n)} ${context.l10n.onFoot}',
                  style: textStyle.copyWith(color: context.colors.foregroundDefault),
                ),
              Text(' · ', style: textStyle.copyWith(color: context.colors.foregroundSoft)),
              Text(
                '${context.l10n.number(data.duration)} ${context.l10n.min}',
                style: textStyle.copyWith(color: context.colors.foregroundSoft),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData getStepIcon(BuildContext context) {
    if (Directionality.of(context) == TextDirection.ltr) {
      return TransportIcons.pedestrianLTR;
    } else {
      return TransportIcons.pedestrianRTL;
    }
  }
}

class RoutingPedestrianV2 extends StatelessWidget {
  final RouteDetailsPublicTransportPedestrian data;
  const RoutingPedestrianV2({
    required this.data,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = context.textStyles.bodyLargeRegular;
    if (data.isTransfer) {
      return const SizedBox(height: 58);
    }
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          Spacing.$10x.widthBox,
          Row(
            children: [
              Icon(
                TransportIcons.pedestrianLTR,
                color: context.colors.foregroundSoft,
                size: 16,
              ),
              Text(
                '${data.lengthInMeters.formatDistance(context.l10n)} ${context.l10n.onFoot}',
                style: textStyle.copyWith(color: context.colors.foregroundSoft),
              ),
              Text(' · ', style: textStyle.copyWith(color: context.colors.foregroundSoft)),
              Text(
                '${context.l10n.number(data.duration)} ${context.l10n.min}',
                style: textStyle.copyWith(color: context.colors.foregroundSoft),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData getStepIcon(BuildContext context) {
    if (Directionality.of(context) == TextDirection.ltr) {
      return TransportIcons.pedestrianLTR;
    } else {
      return TransportIcons.pedestrianRTL;
    }
  }
}
