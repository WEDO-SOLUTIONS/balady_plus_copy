import 'package:flutter/material.dart';
import 'package:mapness/shared/ui/dismissible/dismissible_background.dart';

/// Custom wrapper for Dismissible widget with custom background, direction, movementDuration and key
class AppDismissible extends StatelessWidget {
  /// Key for the sorting and detecting value from the list
  final ValueKey elementKey;

  /// For border radius and right drawing
  final bool isFirst;

  /// For border radius and right drawing
  final bool isLast;

  /// The child widget that will be wrapped with Dismissible
  final Widget child;

  /// If the Dismissible is enabled or not
  final bool isDismissibleEnabled;

  /// Callback when the Dismissible is dismissed. Works only when [isDismissibleEnabled] is true
  /// Called as confirmation with bottom sheet with options "Delete" or "Cancel"
  final VoidCallback onDismiss;

  const AppDismissible({
    required this.elementKey,
    required this.isFirst,
    required this.isLast,
    required this.child,
    required this.onDismiss,
    this.isDismissibleEnabled = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) => isDismissibleEnabled
      ? Dismissible(
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) async {
            // Here we call "confirmation" sheet. This sheet and method overall will decide: delete or not
            // [Dismissible] class will not delete or dismiss any widget. We should do it only by providers and
            // controllers
            onDismiss();
            // Return false to not remove this item from the list. [Dismissible] class visually remove item
            // but do not delete it from the cache or database.
            return false;
          },
          movementDuration: const Duration(milliseconds: 300),
          key: elementKey,
          background: AppDismissibleBackground(
            isFirst: isFirst,
            isLast: isLast,
          ),
          child: child,
        )
      : child;
}
