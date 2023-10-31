import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/features/common/config/package_config.dart';
import 'package:mapness/features/happiness_map/happines_map_bottom_sheet.dart';
import 'package:mapness/features/landing/providers/map_controls.dart';

class HappinesOverlayContent extends ConsumerStatefulWidget {
  final VoidCallback onClose;

  const HappinesOverlayContent({required this.onClose, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _HapinessOverlayContentState();
}

class _HapinessOverlayContentState
    extends ConsumerState<HappinesOverlayContent> {
  final ValueNotifier<double> height = ValueNotifier(100);

  @override
  void dispose() {
    height.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxHeight = constraints.biggest.height;
        return Stack(
          children: [
            ValueListenableBuilder(
              valueListenable: height,
              builder: (context, height, child) => Positioned.fill(
                bottom: height,
                child: child!,
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/svg/ic_pin.svg',
                  height: 48,
                  width: 38,
                  package: PackageConfig.packageName,
                ),
              ),
            ),
            HappinessBottomSheet(
              onHeightChange: (height) {
                Future.delayed(
                  Duration.zero,
                  () => this.height.value = height * maxHeight,
                );
              },
              biggestHeight: maxHeight,
              onClose: () {
                ref
                    .read(mapControlsProvider.notifier)
                    .update(MapControlsStateIdle());
                widget.onClose();
              },
            ),
          ],
        );
      },
    );
  }
}
