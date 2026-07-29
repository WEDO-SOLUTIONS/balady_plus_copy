part of 'navi_eta_header.dart';

class _PausedStateTitle extends StatelessWidget {
  final PathNavEta? eta;
  const _PausedStateTitle({
    required this.eta,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = context.textStyles.captionMediumRegular.copyWith(
      color: context.color.textAndIconsBaseInversePrimary,
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          context.l10n.continueTrip,
          style: context.textStyles.h4SemiBold.copyWith(color: context.color.textAndIconsBaseInversePrimary),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              eta == null ? '--' : context.digits(eta!.distanceEta),
              style: textStyle,
            ),
            const SizedBox(width: Spacing.$1x),
            Text(
              eta?.distanceEtaUnits.getDescription(context) ?? '--',
              style: textStyle,
            ),
            const SizedBox(width: Spacing.$1x),
            Text(
              '·',
              style: textStyle,
            ),
            const SizedBox(width: Spacing.$1x),
            Text(
              eta == null ? '--' : context.digits(eta!.timeEta),
              style: textStyle,
            ),
            const SizedBox(width: Spacing.$1x),
            Text(
              eta?.timeEtaUnits.getDescription(context) ?? '--',
              style: textStyle,
            ),
          ],
        ),
      ],
    );
  }
}
