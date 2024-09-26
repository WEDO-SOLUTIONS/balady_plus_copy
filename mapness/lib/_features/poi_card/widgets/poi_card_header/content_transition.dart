import 'package:flutter/widgets.dart';

class ContentTransition extends StatelessWidget {
  final double interpolation;
  final Widget child;

  const ContentTransition({
    required this.interpolation,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Opacity(
        opacity: interpolation,
        child: SizeTransition(
          sizeFactor: AlwaysStoppedAnimation(interpolation),
          child: child,
        ),
      );
}
