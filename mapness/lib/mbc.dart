import 'package:flutter/material.dart';

class MapWithPanel extends StatefulWidget {
  final Widget child;

  const MapWithPanel({required this.child, super.key});

  @override
  State<MapWithPanel> createState() => _MapWithPanelState();
}

class _MapWithPanelState extends State<MapWithPanel> {
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();

  final double _minChildSize = 0.0;
  final double _maxChildSize = 0.45;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.black,
        body: AnimatedBuilder(
          animation: _sheetController,
          builder: (context, _) {
            final double currentSize = _sheetController.isAttached
                ? _sheetController.size
                : _minChildSize;

            final double progress =
                (currentSize - _minChildSize) / (_maxChildSize - _minChildSize);

            final double mapOffset = -420 * progress;

            return Stack(
              children: [
                Transform.translate(
                  offset: Offset(0, mapOffset),
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(50),
                      ),
                    ),
                    child: widget.child,
                  ),
                ),

                /// Panel
                DraggableScrollableSheet(
                  controller: _sheetController,
                  initialChildSize: _minChildSize,
                  minChildSize: _minChildSize,
                  maxChildSize: _maxChildSize,
                  builder: (context, scrollController) => Container(
                    decoration: const BoxDecoration(
                      color: Colors.black,
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 60,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(36),
                          ),
                        ),
                        Expanded(
                          child: ListView(
                            controller: scrollController,
                            children: const [
                              Center(
                                child: Text(
                                  '🎵 Music Player / Panel',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ), // filler
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );

  /// Toggles the panel between open and closed states
  void togglePanel() {
    if (_sheetController.isAttached) {
      final currentSize = _sheetController.size;
      final targetSize = currentSize > (_minChildSize + _maxChildSize) / 2
          ? _minChildSize
          : _maxChildSize;

      _sheetController.animateTo(
        targetSize,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}
