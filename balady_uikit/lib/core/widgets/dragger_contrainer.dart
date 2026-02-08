import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/widgets/dragger.dart';
import 'package:flutter/material.dart';

class DraggerContainer extends StatelessWidget {
  final Color? color;

  const DraggerContainer({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: color ?? context.colors.backgroundSurface1,
      child: const SizedBox(
        width: double.infinity,
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(padding: EdgeInsets.only(top: 6.0, bottom: 6.0), child: Dragger()),
        ),
      ),
    );
  }
}
