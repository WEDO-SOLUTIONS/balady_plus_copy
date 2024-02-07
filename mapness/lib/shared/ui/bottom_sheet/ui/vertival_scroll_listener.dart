import 'package:flutter/material.dart';

class VerticalScrollListener extends StatelessWidget {
  final GestureDragUpdateCallback onVerticalDragUpdate;
  final GestureDragEndCallback onVerticalDragEnd;
  final Widget child;

  const VerticalScrollListener({
    required this.onVerticalDragUpdate,
    required this.onVerticalDragEnd,
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onVerticalDragUpdate: onVerticalDragUpdate,
        onVerticalDragEnd: onVerticalDragEnd,
        // ignore: sized_box_for_whitespace
        child: Container(
          width: double.infinity,
          child: Center(child: child),
        ),
      );
}
