import 'package:flutter/material.dart';

import '../../../home_exports.dart' show HomeSectionTitle;

class HomeSection extends StatelessWidget {
  final String title;
  final Widget child;
  final bool isNew;

  const HomeSection({
    super.key,
    required this.title,
    required this.child,
    this.isNew = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsetsDirectional.only(top: 16, start: 16, end: 16),
          child: HomeSectionTitle(title: title, isNew: isNew),
        ),
        child,
      ],
    );
  }
}
