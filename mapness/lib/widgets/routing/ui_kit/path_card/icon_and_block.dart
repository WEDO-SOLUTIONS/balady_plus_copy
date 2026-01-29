part of 'path_card.dart';

class _IconAndTextBlock extends StatelessWidget {
  final IconData icon;
  final int value;
  final String label;

  const _IconAndTextBlock({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, color: context.colors.neutralMuted, size: 16),
      Spacing.$1x.widthBox,
      Text(value.toString(), style: context.textStyle.caption.copyWith(color: context.colors.foregroundDefault)),
      Spacing.$0_5x.widthBox,
      Text(label.toString(), style: context.textStyle.caption.copyWith(color: context.colors.foregroundSoft)),
    ],
  );
}
