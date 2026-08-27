import 'package:flutter/material.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/widgets/debug_overlay/bug_button.dart';
import 'package:mapness/widgets/debug_overlay/debug_sheet.dart';

class DebugOverlay extends StatefulWidget {
  const DebugOverlay({super.key});

  @override
  State<DebugOverlay> createState() => _DebugOverlayState();
}

class _DebugOverlayState extends State<DebugOverlay> {
  late DraggableScrollableController _draggableController;

  @override
  void initState() {
    super.initState();
    _draggableController = DraggableScrollableController();
  }

  @override
  Widget build(BuildContext context) => Theme(
    data: Theme.of(rootNavigatorKey.currentContext!),
    child: Stack(
      children: [
        BugButton(
          onTap: () {
            _draggableController.animateTo(
              0.8,
              duration: const Duration(milliseconds: 250),
              curve: Curves.linear,
            );
          },
        ),
        DebugSheet(
          draggableController: _draggableController,
        ),
      ],
    ),
  );
}
