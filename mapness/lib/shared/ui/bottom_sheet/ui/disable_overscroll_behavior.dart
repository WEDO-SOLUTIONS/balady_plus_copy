import 'package:flutter/material.dart';

class DisabledOverscrollScrollBehavior extends ScrollBehavior {
  const DisabledOverscrollScrollBehavior();
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) => const ClampingScrollPhysics();
}

class NeverScrollableConfiguration extends ScrollBehavior {
  const NeverScrollableConfiguration();
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) => const NeverScrollableScrollPhysics();
}
