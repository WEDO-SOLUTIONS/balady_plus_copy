import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';

class RotationBasedLanguageWidget extends StatelessWidget {
  final Widget child;
  const RotationBasedLanguageWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: CommonFunctions.isAppAR ? 0 : 2,
      child: child,
    );
  }
}
