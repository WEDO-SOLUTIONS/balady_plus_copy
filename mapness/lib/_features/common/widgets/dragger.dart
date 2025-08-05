import 'package:balady_uikit/core/widgets/dragger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Temporary solution for dragger from UIKit
/// With new Bottom sheet we have to remove it and use Bottom sheet
class SheetDragger extends StatelessWidget {
  const SheetDragger({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox(
        width: double.infinity,
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(padding: EdgeInsets.only(top: 6.0, bottom: 6.0), child: Dragger()),
        ),
      );
}
