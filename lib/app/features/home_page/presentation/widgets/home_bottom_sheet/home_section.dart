import 'package:flutter/material.dart';

import '../../../home_exports.dart' show HomeSectionTitle;

class HomeSection extends StatelessWidget {
  final String title;
  final Widget child;
  final bool isNew;
  final double topPadding;

  const HomeSection({
    super.key,
    required this.title,
    required this.child,
    this.topPadding = 32,
    this.isNew = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.only(top: isNew ? 0 : topPadding, start: 16, end: 16),
          child: HomeSectionTitle(title: title, isNew: isNew),
        ),
        child,
      ],
    );
  }
}
