part of 'ab_route.dart';

class _AbRouteAddPoint extends StatelessWidget {
  final VoidCallback? onTap;

  const _AbRouteAddPoint(this.onTap);

  @override
  Widget build(BuildContext context) {
    final color = onTap != null ? context.colors.accentDefault : context.colors.foregroundMuted;
    return ContentRow(
      onTap: onTap,
      leading: Icon(SystemIcons.plusCircleFilled, color: color, size: 24),
      text: ContentRowTextOptions(
        title: context.l10n.stopBy,
        titleOptions: ContentRowTextOption(
          baseColor: color,
        ),
      ),
    );
  }
}
