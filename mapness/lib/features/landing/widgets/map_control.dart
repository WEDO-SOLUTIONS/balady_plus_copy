import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/landing/providers/map_controls.dart';

class MapControl extends ConsumerWidget {
  final Widget child;
  final bool disabled;
  final BorderRadius borderRadius;
  final void Function()? onTap;
  final void Function(TapUpDetails)? onTapUp;
  final void Function(TapDownDetails)? onTapDown;

  MapControl({
    required this.child,
    this.onTap,
    this.onTapUp,
    this.onTapDown,
    bool? disabled,
    BorderRadius? borderRadius,
    super.key,
  })  : disabled = disabled ?? false,
        borderRadius = borderRadius ?? BorderRadius.circular(10);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sheetState = ref.watch(mapControlsProvider);

    return AnimatedOpacity(
      opacity: sheetState is! MapControlsStateIdle ? 0 : (disabled ? 0.5 : 1),
      duration: const Duration(milliseconds: 250),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              spreadRadius: 0,
              blurRadius: 1,
              offset: const Offset(0, 0),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Material(
          borderRadius: borderRadius,
          color: Colors.white,
          child: InkWell(
            borderRadius: borderRadius,
            onTap: onTap,
            onTapUp: onTapUp,
            onTapDown: onTapDown,
            child: Container(
              constraints: const BoxConstraints(minWidth: 48),
              height: 48,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  child,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
