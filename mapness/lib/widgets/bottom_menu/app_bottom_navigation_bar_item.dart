import 'package:flutter/material.dart';
import 'package:mapness/widgets/bottom_menu/default_label.dart';

class AppBottomNavigationBarItem extends StatelessWidget {
  final bool selected;
  final Widget Function(BuildContext, bool) iconBuilder;
  final String? label;

  const AppBottomNavigationBarItem({required this.selected, required this.iconBuilder, super.key, this.label});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Column(
          children: [
            iconBuilder.call(context, selected),
            const SizedBox(height: 2),
            DefaultLabel(label: label!, selected: selected),
          ],
        ),
      );
}
