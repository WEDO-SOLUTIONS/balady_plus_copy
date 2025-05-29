part of 'navi_eta_header.dart';

class _FinishedStateTitle extends StatelessWidget {
  const _FinishedStateTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Text(
        context.l10n.youArrived,
        style: context.textStyle.heading1,
        textAlign: TextAlign.center,
      );
}
