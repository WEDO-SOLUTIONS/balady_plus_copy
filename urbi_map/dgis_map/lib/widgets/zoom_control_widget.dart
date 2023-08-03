import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';

///Widget with zoomIn and zoomOut buttons
class ZoomControlWidget extends StatelessWidget {
  ///no doc
  const ZoomControlWidget({
    required this.controller,
    super.key,
  });

  final NaviZoomController controller;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      child: Column(
        children: [
          _ZoomButton(
            state: controller.zoomInState,
            icon: Icons.add,
            onTapUp: () => unawaited(
              controller.onTapUp(ZoomControlType.zoomIn),
            ),
            onTapDown: () => unawaited(
              controller.onTapDown(ZoomControlType.zoomIn),
            ),
          ),
          const Divider(
            height: 1,
            color: Color(0x14141417),
          ),
          _ZoomButton(
            state: controller.zoomOutState,
            icon: Icons.remove,
            onTapUp: () => unawaited(
              controller.onTapUp(ZoomControlType.zoomOut),
            ),
            onTapDown: () => unawaited(
              controller.onTapDown(ZoomControlType.zoomOut),
            ),
          ),
        ],
      ),
    );
  }
}

class _ZoomButton extends StatelessWidget {
  const _ZoomButton({
    required this.state,
    required this.icon,
    required this.onTapUp,
    required this.onTapDown,
  });

  final ValueNotifier<bool> state;
  final IconData icon;
  final Function() onTapUp;
  final Function() onTapDown;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: state,
        builder: (_, isEnabled, __) {
          return InkWell(
            onTapUp: isEnabled ? (_) => onTapUp.call() : null,
            onTapDown: isEnabled ? (_) => onTapDown.call() : null,
            child: Container(
              width: 48,
              height: 48,
              color: Colors.white,
              child: Icon(
                icon,
                color: isEnabled ? Colors.black54 : Colors.black12,
              ),
            ),
          );
        });
  }
}
