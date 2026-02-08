part of 'ab_points.dart';

class _Line extends StatelessWidget {
  const _Line();

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 9,
        width: 1,
        child: ColoredBox(
          color: context.colors.borderDefault,
        ),
      );
}
