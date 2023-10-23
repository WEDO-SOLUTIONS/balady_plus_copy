import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mapness/features/landing/widgets/map_control.dart';
import 'package:mapness/features/map/providers/zoom_state.dart';

class ZoomControl extends ConsumerWidget {
  const ZoomControl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final zoomState = ref.watch(zoomStateProvider);
    final zoomNotifier = ref.watch(zoomStateProvider.notifier);

    return Column(
      children: [
        GestureDetector(
          onTapUp: (_) => zoomState.zoomInEnabled
              ? zoomNotifier.onTapUp(ZoomControlType.zoomIn)
              : null,
          onTapDown: (_) => zoomState.zoomInEnabled
              ? zoomNotifier.onTapDown(ZoomControlType.zoomIn)
              : null,
          child: MapControl(
            SvgPicture.asset(
              "assets/icons/svg/ic_control_zoom_in.svg",
              semanticsLabel: 'MinApps Screen',
              package: "mapness",
              width: 24,
              height: 24,
            ),
            disabled: !zoomState.zoomInEnabled,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        GestureDetector(
          onTapUp: (_) {
            zoomState.zoomOutEnabled
                ? zoomNotifier.onTapUp(ZoomControlType.zoomOut)
                : null;
          },
          onTapDown: (_) => zoomState.zoomOutEnabled
              ? zoomNotifier.onTapDown(ZoomControlType.zoomOut)
              : null,
          child: MapControl(
            SvgPicture.asset(
              "assets/icons/svg/ic_control_zoom_out.svg",
              semanticsLabel: 'MinApps Screen',
              package: "mapness",
            ),
            disabled: !zoomState.zoomOutEnabled,
          ),
        ),
      ],
    );
  }
}
