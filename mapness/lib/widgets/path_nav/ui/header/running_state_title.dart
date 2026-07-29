part of 'navi_eta_header.dart';

class _RunningStateTitle extends StatelessWidget {
  final PathNavEta? eta;
  const _RunningStateTitle({required this.eta, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final eta = this.eta;

    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
          child: _NaviTime(
            title: eta != null ? context.digits(eta.timeEta) : '--',
            subTitle: eta != null ? eta.timeEtaUnits.getDescription(context) : '--',
          ),
        ),
        Expanded(
          flex: 2,
          child: _NaviTime(title: eta != null ? context.digits(eta.arrivalTime) : '--', subTitle: context.l10n.arrival),
        ),
        Expanded(
          child: _NaviTime(
            title: eta != null ? context.digits(formatDistance(eta.distanceEta)) : '--',
            subTitle: eta != null ? eta.distanceEtaUnits.getDescription(context) : '--',
          ),
        ),
      ].insertBetween(Spacing.$1x.widthBox).toList(),
    );
  }
}

class _NaviTime extends StatelessWidget {
  final String title;
  final String subTitle;

  const _NaviTime({required this.title, required this.subTitle});

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        title,
        style: context.textStyles.h3SemiBold.copyWith(color: context.colors.foregroundDefault),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      Text(
        subTitle,
        style: context.textStyles.captionMediumRegular.copyWith(color: context.colors.foregroundSoft),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    ],
  );
}
