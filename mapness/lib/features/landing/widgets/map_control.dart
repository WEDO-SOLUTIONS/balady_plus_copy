import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/landing/dashboard_manager.dart';

class MapControl extends ConsumerWidget {
  final Widget content;
  final bool disabled;
  const MapControl(
    this.content, {
    disabled,
    super.key,
  }) : disabled = disabled ?? false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controlsVisibility = ref.watch(dashboardManagerProvider);
    return controlsVisibility != BottomSheetState.expanded
        ? Opacity(
            opacity: disabled ? 0.5 : 1,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(10.0),
              child: content,
            ),
          )
        : const SizedBox.shrink();
  }
}
