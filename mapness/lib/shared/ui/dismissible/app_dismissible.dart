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
  final VoidCallback onDismiss;

  /// Callback for confirming the dismiss action. Works only when [isDismissibleEnabled] is true
  final Future<bool?> Function(DismissDirection)? confirmDismiss;

  const AppDismissible({
    required this.elementKey,
    required this.isFirst,
    required this.isLast,
    required this.child,
    required this.onDismiss,
    this.isDismissibleEnabled = true,
    this.confirmDismiss,
    super.key,
  });

  @override
  Widget build(BuildContext context) => isDismissibleEnabled
      ? Dismissible(
          direction: DismissDirection.endToStart,
          confirmDismiss: confirmDismiss,
          movementDuration: const Duration(milliseconds: 300),
          key: elementKey,
          onDismissed: (_) => onDismiss(),
          background: AppDismissibleBackground(
            isFirst: isFirst,
            isLast: isLast,
          ),
          child: child,
        )
      : child;
}
