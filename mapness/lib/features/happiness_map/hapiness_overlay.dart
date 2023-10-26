import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/features/common/config/package_config.dart';
import 'package:mapness/features/happiness_map/happines_map_bottom_sheet.dart';
import 'package:mapness/features/landing/providers/map_controls.dart';
import 'package:mapness/features/map/providers/camera_position.dart';
import 'package:mapness/features/map/providers/camera_state.dart';

class HapinessOverlay extends ConsumerWidget {
  const HapinessOverlay({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameraState = ref.watch(cameraStateProvider);
    ref.watch(cameraPositionProvider);

    return LayoutBuilder(
      builder: (context, constraints) => Stack(
        children: [
          AnimatedAlign(
            alignment: Alignment(
              0,
              -48 /
                  constraints.biggest.height *
                  (cameraState == CameraState.free ? 1 : 2),
            ),
            duration: const Duration(milliseconds: 250),
            child: SvgPicture.asset(
              'assets/icons/svg/ic_pin.svg',
              height: 48,
              width: 38,
              package: PackageConfig.packageName,
            ),
          ),
          HappinessBottomSheet(
            biggestHeight: constraints.biggest.height,
            onClose: () => ref
                .read(mapControlsProvider.notifier)
                .update(MapControlsStateIdle()),
          ),
        ],
      ),
    );
  }
}
