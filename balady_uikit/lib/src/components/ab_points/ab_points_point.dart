part of 'ab_points.dart';

class _Point extends StatelessWidget {
  final bool isLast;

  const _Point({required this.isLast});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(Spacing.$0_5x),
        child: SizedBox(
          height: 12,
          width: 12,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isLast ? context.colors.extra01Default : context.colors.accentDefault,
                width: 3.5,
              ),
            ),
          ),
        ),
      );
}
