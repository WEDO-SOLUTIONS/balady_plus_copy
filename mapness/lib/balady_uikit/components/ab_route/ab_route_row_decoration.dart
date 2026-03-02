part of 'ab_route.dart';

class _ABRouteRowDecoration extends StatelessWidget {
  final Widget leading;
  final String title;
  final int index;
  final VoidCallback onTap;
  final bool isDividerEnabled;
  final VoidCallback? onDeletePressed;

  const _ABRouteRowDecoration({
    required this.leading,
    required this.title,
    required this.index,
    required this.onTap,
    required this.isDividerEnabled,
    this.onDeletePressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final actionColor = context.colors.foregroundMuted;
    return Material(
      color: Colors.transparent,
      child: SizedBox(
        height: 44,
        child: CupertinoButton(
          padding: EdgeInsets.zero,
          minSize: 0,
          onPressed: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x, vertical: 9),
                child: Row(
                  children: [
                    leading,
                    Expanded(
                      child: Text(
                        title,
                        style: context.textStyles.bodyLargeRegular.copyWith(color: context.colors.foregroundDefault),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    _ActionsContainer([
                      if (onDeletePressed != null)
                        GestureDetector(
                          onTap: onDeletePressed,
                          child: Icon(SystemIcons.closeSmall, color: actionColor),
                        ),
                      ReorderableDragStartListener(
                        index: index,
                        child: Icon(SystemIcons.dragMenu, color: actionColor),
                      ),
                    ]),
                  ].insertBetween(Spacing.$3x.widthBox).toList(),
                ),
              ),
              if (isDividerEnabled)
                Divider(color: context.colors.borderSoft, height: 0.5, thickness: 0.5, indent: Spacing.$12x.toDouble()),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionsContainer extends StatelessWidget {
  final List<Widget> actions;

  const _ActionsContainer(this.actions);

  @override
  Widget build(BuildContext context) => Row(children: actions.insertBetween(Spacing.$2x.widthBox).toList());
}
