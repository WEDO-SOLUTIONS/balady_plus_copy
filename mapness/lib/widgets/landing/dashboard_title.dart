import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';

class DashboardTitle extends StatelessWidget {
  final String title;

  const DashboardTitle(
    this.title, {
    super.key,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
        child: Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            title,
            textAlign: TextAlign.start,
            style: context.textStyles.h3SemiBold,
          ),
        ),
      );
}
