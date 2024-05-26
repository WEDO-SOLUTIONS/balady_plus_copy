part of 'path_card.dart';

class _IconAndTextBlock extends StatelessWidget {
  final IconData icon;
  final int value;
  final String label;

  const _IconAndTextBlock({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Icon(icon, color: context.staticColor.surfaceStatusPositive, size: 16),
          Spacing.horizontalGapBetweenChipContent.widthBox,
          Text(value.toString(), style: context.textStyle.caption),
          NumericBase.$0_5x.widthBox,
          Text(
            label.toString(),
            style: context.textStyle.caption.copyWith(color: context.color.textAndIconsBaseSecondary),
          ),
        ],
      );
}
