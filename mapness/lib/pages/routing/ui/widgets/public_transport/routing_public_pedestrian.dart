part of 'routing_public_transport_content.dart';

class RoutingPublicPedestrian extends StatelessWidget {
  final RouteDetailsPublicTransportPedestrian data;
  final double? topPadding;
  final double? bottomPadding;
  final double? horizontalPadding;

  const RoutingPublicPedestrian({
    required this.data,
    this.topPadding,
    this.bottomPadding,
    this.horizontalPadding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = context.textStyles.bodyLargeRegular;
    return Padding(
      padding: EdgeInsetsDirectional.only(
        top: topPadding ?? 0.0,
        bottom: bottomPadding ?? 0.0,
        start: horizontalPadding ?? Spacing.$10x,
        end: horizontalPadding ?? Spacing.$10x,
      ),
      child: Row(
        children: [
          Row(
            children: [
              Icon(
                TransportIcons.pedestrianLTR,
                color: context.colors.foregroundSoft,
                size: 16,
              ),
              Text(
                data.isTransfer ? context.l10n.toSwitch : context.l10n.onFoot,
                style: textStyle.copyWith(color: context.colors.foregroundSoft),
              ),
              Text(' · ', style: textStyle.copyWith(color: context.colors.foregroundSoft)),
              Text(
                '${data.duration} ${context.l10n.min}',
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
