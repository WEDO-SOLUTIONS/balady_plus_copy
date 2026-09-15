import 'package:flutter/material.dart';
import 'package:mapness/widgets/bottom_menu/default_label.dart';

class AppBottomNavigationBarItem extends StatelessWidget {
  final bool selected;
  final Widget Function(BuildContext context, {required bool selected}) iconBuilder;
  final String? label;

  const AppBottomNavigationBarItem({required this.selected, required this.iconBuilder, super.key, this.label});

  @override
  Widget build(BuildContext context) {
    final labelText = label ?? '';
    return Semantics(
      container: true,
      button: true,
      selected: selected,
      label: labelText,
      child: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ExcludeSemantics(child: iconBuilder(context, selected: selected)),
            const SizedBox(height: 2),
            ExcludeSemantics(
              child: DefaultLabel(label: labelText, selected: selected),
            ),
          ],
        ),
      ),
    );
  }
}
