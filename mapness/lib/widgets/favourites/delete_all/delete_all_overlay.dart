import 'package:flutter/material.dart';

class DeleteAllOverlay {
  OverlayEntry? _overlayEntry;

  void show(BuildContext context, Widget child) {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
    }
    _overlayEntry = OverlayEntry(
      builder: (context) => Material(
        color: Colors.transparent,
        child: child,
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
