import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/landing/providers/map_controls.dart';

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
    final sheetState = ref.watch(mapControlsProvider);

    return AnimatedOpacity(
      opacity: sheetState != MapControlsState.idle ? 0 : (disabled ? 0.5 : 1),
      duration: const Duration(milliseconds: 250),
      child: Container(
        constraints: const BoxConstraints(minWidth: 40),
        height: 40,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            content,
          ],
        ),
      ),
    );
  }
}
