import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class BaladyVisibilityDetector extends StatefulWidget {
  final Key visibilityKey;
  final Widget child;

  /// onVisible is called when the [child] is fully visible on screen
  // ignore: avoid_positional_boolean_parameters
  final void Function(bool isFirstTimeVisible) onVisible;

  const BaladyVisibilityDetector({
    required this.visibilityKey,
    required this.child,
    required this.onVisible,
    super.key,
  });

  @override
  State<BaladyVisibilityDetector> createState() => _BaladyVisibilityDetectorState();
}

class _BaladyVisibilityDetectorState extends State<BaladyVisibilityDetector> {
  var _isFirstTimeVisible = true;

  @override
  Widget build(BuildContext context) => VisibilityDetector(
    key: widget.visibilityKey,
    onVisibilityChanged: (visibilityInfo) {
      final visiblePercentage = visibilityInfo.visibleFraction * 100;
      // consider widget fully visible at 90% of visibility
      if (visiblePercentage > 90) {
        widget.onVisible(_isFirstTimeVisible);
        if (!_isFirstTimeVisible) {
          _isFirstTimeVisible = false;
        }
      }
    },
    child: widget.child,
  );
}
