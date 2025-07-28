part of 'path_card.dart';

/// Icon and text in one line. Used in the path card.
class _PathBadge extends StatelessWidget {
  final PathCardStatus info;
  const _PathBadge(this.info);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            info.type.icon(context),
            color: info.priority.iconColor(context),
            size: 16,
          ),
          Spacing.$1x.widthBox,
          Text(
            info.text,
            style: context.textStyles.captionMediumRegular.copyWith(
              color: info.priority.textColor(context),
            ),
          ),
        ],
      );
}
