import 'package:balady_uikit/core/extensions/build_context_ext.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sheetify/widgets/dragger_contrainer.dart';

/// Temporary solution for dragger from UIKit
/// With new Bottom sheet we have to remove it and use Bottom sheet
class SheetDragger extends StatelessWidget {
  final Color? draggerColor;
  final Color? backgroundColor;

  const SheetDragger({
    this.draggerColor,
    this.backgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) => DraggerContainer(
        draggerColor: draggerColor ?? context.colors.backgroundSurface5,
        backgroundColor: backgroundColor ?? Colors.transparent,
      );
}
