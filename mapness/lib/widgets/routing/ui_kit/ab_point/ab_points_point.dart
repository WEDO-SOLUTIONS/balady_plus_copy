part of 'ab_points.dart';

class _Point extends StatelessWidget {
  final bool isLast;
  const _Point({required this.isLast});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.all(2),
        height: 12,
        width: 12,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isLast ? context.color.textAndIconsStatusAccent : context.color.textAndIconsStatusPositive,
            width: 3.5,
          ),
        ),
      );
}
