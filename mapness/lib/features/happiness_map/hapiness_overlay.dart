import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/happiness_map/presentation/happines_overlay_content.dart';
import 'package:mapness/features/landing/providers/map_controls.dart';

class HapinessOverlay extends ConsumerStatefulWidget {
  const HapinessOverlay({
    super.key,
  });

  @override
  ConsumerState<HapinessOverlay> createState() => _HapinessOverlayState();
}

class _HapinessOverlayState extends ConsumerState<HapinessOverlay> {
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () => open(context));
  }

  void open(BuildContext context) {
    if (_overlayEntry != null) return;
    _overlayEntry = OverlayEntry(
      builder: (context) => Directionality(
        textDirection: TextDirection.ltr,
        child: ProviderScope(
          parent: ProviderScope.containerOf(context),
          child: HappinesOverlayContent(onClose: close),
        ),
      ),
    );

    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
  }

  void close() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    // final cameraState = ref.watch(cameraStateProvider);
    // final position = ref.watch(cameraPositionProvider);
    ref.listen(mapControlsProvider, (previous, nextState) {
      switch (nextState) {
        case MapControlsStateHappinessMap():
          break;

        case _:
          Future.delayed(Duration.zero, close);
          break;
      }
      ;
    });

    return const SizedBox.shrink();
  }
}
