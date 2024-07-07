import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Temporary solution for dragger from UIKit
/// With new Bottom sheet we have to remove it and use Bottom sheet
class SheetDragger extends StatelessWidget {
  const SheetDragger({super.key});

  @override
  Widget build(BuildContext context) => Container(
        height: 4,
        width: 40,
        decoration: BoxDecoration(
          color: context.color.surfaceContrastMid,
          borderRadius: const BorderRadius.all(Radius.circular(99)),
        ),
      );
}
