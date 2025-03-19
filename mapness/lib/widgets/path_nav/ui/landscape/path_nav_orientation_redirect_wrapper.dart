import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class PathNavOrientationRedirectWrapper extends StatefulWidget {
  final Widget child;

  const PathNavOrientationRedirectWrapper({
    required this.child,
    super.key,
  });

  @override
  State<PathNavOrientationRedirectWrapper> createState() => _PathNavOrientationRedirectWrapperState();
}

class _PathNavOrientationRedirectWrapperState extends State<PathNavOrientationRedirectWrapper> {
  Orientation? orientation;

  @override
  void didChangeDependencies() {
    final orientation = MediaQuery.orientationOf(context);
    if (this.orientation != orientation) {
      if (this.orientation != null) {
        Future(context.router.popForced);
      }
      this.orientation = orientation;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
