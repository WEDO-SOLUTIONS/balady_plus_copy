import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/stream_audio/ui/providers/stream_audio_prov.dart';

class StreamAudio extends ConsumerStatefulWidget {
  final Widget child;

  const StreamAudio({required this.child, super.key});

  @override
  ConsumerState<StreamAudio> createState() => _StreamAudioState();
}

class _StreamAudioState extends ConsumerState<StreamAudio> {
  late final ProviderBase<StreamAudioProvider> _streamAudioProvider;

  @override
  void initState() {
    _streamAudioProvider = ChangeNotifierProvider<StreamAudioProvider>((ref) => StreamAudioProvider());
    super.initState();
  }

  final DraggableScrollableController _sheetController = DraggableScrollableController();

  final double _minChildSize = 0.0;
  final double _maxChildSize = 0.45;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.black,
        body: AnimatedBuilder(
          animation: _sheetController,
          builder: (context, _) {
            final double currentSize = _sheetController.isAttached ? _sheetController.size : _minChildSize;

            final double progress = (currentSize - _minChildSize) / (_maxChildSize - _minChildSize);

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

                if (currentSize == _minChildSize) Center(child: DraggableFloatingPlayerControls(onTap: togglePanel)),

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
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
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
      final targetSize = currentSize > (_minChildSize + _maxChildSize) / 2 ? _minChildSize : _maxChildSize;

      _sheetController.animateTo(
        targetSize,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}

class DraggableFloatingPlayerControls extends StatefulWidget {
  const DraggableFloatingPlayerControls({required this.onTap, super.key});

  final Function onTap;

  @override
  State<DraggableFloatingPlayerControls> createState() => _DraggableFloatingPlayerControlsState();
}

class _DraggableFloatingPlayerControlsState extends State<DraggableFloatingPlayerControls>
    with TickerProviderStateMixin {
  // Position tracking
  Offset _position = const Offset(0, 0);
  Offset _initialPosition = const Offset(0, 0);
  Offset _dragStartPosition = Offset.zero;

  // Animation controllers
  late AnimationController _scaleController;
  late AnimationController _snapController;
  late AnimationController _shapeController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shapeAnimation;
  Animation<Offset>? _snapAnimation;

  // Widget dimensions
  static const double widgetWidth = 200;
  static const double widgetHeight = 48;
  static const double circleSize = 60;

  // States
  bool _isDragging = false;
  bool isOnTheEdge = false;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(_scaleController);

    _snapController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _shapeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _shapeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_shapeController);

    _snapAnimation = Tween<Offset>(begin: Offset.zero, end: Offset.zero).animate(_snapController);
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _snapController.dispose();
    _shapeController.dispose();
    super.dispose();
  }

  void _moveToCenter() {
    print("Moving to center and converting to rectangle");

    _snapAnimation = Tween<Offset>(
      begin: _position,
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(parent: _snapController, curve: Curves.easeOut));

    setState(() {
      isOnTheEdge = false;
    });

    _shapeController.reverse();
    _snapController.forward(from: 0).then((_) {
      setState(() {
        _position = const Offset(0, 0);
      });
    });
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: Listenable.merge([_scaleAnimation, _snapController, _shapeAnimation]),
        builder: (context, child) {
          final currentPosition =
              _snapController.isAnimating && _snapAnimation != null ? _snapAnimation!.value : _position;

          final currentWidth = widgetWidth + (circleSize - widgetWidth) * _shapeAnimation.value;
          final currentHeight = widgetHeight + (circleSize - widgetHeight) * _shapeAnimation.value;
          final currentBorderRadius = 12.0 + (circleSize / 2 - 12.0) * _shapeAnimation.value;

          return Transform.translate(
            offset: currentPosition,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  print("=== TAP DETECTED ===");
                  print("Shape mode: ${isOnTheEdge ? 'Circle' : 'Rectangle'}");
                  print("Position: $_position");
                  print("isOnTheEdge: $isOnTheEdge");
                  if (!isOnTheEdge) {
                    print("Rectangle tapped - toggling panel");
                    widget.onTap();
                  }

                  if (isOnTheEdge) {
                    print("Circle tapped - converting to rectangle");
                    _moveToCenter();
                  }
                },
                onPanStart: (details) {
                  print("=== PAN START ===");
                  print("Shape mode: ${isOnTheEdge ? 'Circle' : 'Rectangle'}");

                  // CHANGE 1: Completely block dragging when in circle shape
                  if (isOnTheEdge) {
                    print("Circle mode - dragging disabled");
                    return; // Simply return without doing anything
                  }

                  print("Rectangle mode - starting drag");
                  setState(() {
                    _isDragging = true;
                    _initialPosition = _position;
                    _dragStartPosition = details.localPosition;
                  });
                  _scaleController.forward();
                },
                onPanUpdate: (details) {
                  // CHANGE 1: Block drag updates when in circle shape
                  if (isOnTheEdge) {
                    return; // Don't process any drag updates
                  }

                  final screenSize = MediaQuery.of(context).size;
                  final dragDelta = details.localPosition - _dragStartPosition;
                  final newPosition = _initialPosition + dragDelta;

                  // Get screen bounds
                  final screenWidth = screenSize.width;
                  final screenHeight = screenSize.height;
                  final topPadding = MediaQuery.of(context).padding.top;
                  final bottomPadding = MediaQuery.of(context).padding.bottom;

                  // Calculate boundaries for RECTANGLE widget (using widgetWidth)
                  final leftBoundaryRect = -screenWidth / 2 + widgetWidth / 2;
                  final rightBoundaryRect = screenWidth / 2 - widgetWidth / 2;
                  final topBoundary = -screenHeight / 2 + widgetHeight / 2 + topPadding;
                  final bottomBoundary = screenHeight / 2 - widgetHeight / 2 - bottomPadding;

                  // Constrain position for rectangle
                  final constrainedX = newPosition.dx.clamp(leftBoundaryRect, rightBoundaryRect);
                  final constrainedY = newPosition.dy.clamp(topBoundary, bottomBoundary);

                  setState(() {
                    _position = Offset(constrainedX, constrainedY);
                  });

                  // Check if rectangle edge is exactly at screen edge
                  final isAtLeftEdge = (constrainedX - leftBoundaryRect).abs() < 0.5;
                  final isAtRightEdge = (constrainedX - rightBoundaryRect).abs() < 0.5;

                  // Check if user is trying to drag beyond the edge
                  final wasConstrained = constrainedX != newPosition.dx;

                  if ((isAtLeftEdge || isAtRightEdge) && wasConstrained && !isOnTheEdge) {
                    print("Hit exact edge! Converting to circle");

                    // Calculate the new position for CIRCLE to be exactly at screen edge
                    // Circle needs different boundary calculation
                    final leftBoundaryCircle = -screenWidth / 2 + circleSize / 2;
                    final rightBoundaryCircle = screenWidth / 2 - circleSize / 2;

                    // Adjust position so circle sits exactly at screen edge
                    final adjustedX = isAtLeftEdge ? leftBoundaryCircle : rightBoundaryCircle;

                    setState(() {
                      _position = Offset(adjustedX, constrainedY);
                      isOnTheEdge = true;
                      _isDragging = false; // Stop dragging when converting to circle
                    });

                    _shapeController.forward();
                    _scaleController.reverse(); // Reset scale when converting
                    HapticFeedback.lightImpact();

                    print("Circle position adjusted to: $adjustedX");
                    print("Left boundary for circle: $leftBoundaryCircle");
                    print("Right boundary for circle: $rightBoundaryCircle");
                  }
                },
                onPanEnd: (details) {
                  // CHANGE 1: Don't process pan end if in circle shape
                  if (isOnTheEdge) {
                    return;
                  }

                  print("Pan ended");
                  setState(() {
                    _isDragging = false;
                  });
                  _scaleController.reverse();
                },
                child: Container(
                  width: currentWidth,
                  height: currentHeight,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.2), // Debug background
                    borderRadius: BorderRadius.circular(currentBorderRadius),
                    border: Border.all(color: Colors.grey, width: 1), // Debug border
                  ),
                  child: Container(
                    decoration: ShapeDecoration(
                      shadows: [
                        BoxShadow(
                          color: const Color(0x7F212222),
                          blurRadius: _isDragging ? 24 : 16,
                          offset: _isDragging ? const Offset(0, 12) : const Offset(0, 8),
                          spreadRadius: -8,
                        )
                      ],
                      gradient: const LinearGradient(
                        begin: Alignment(0.50, -0.00),
                        end: Alignment(0.50, 1.00),
                        colors: [Color(0xFF212222), Color(0xFF212222)],
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(currentBorderRadius)),
                        side: BorderSide(
                          width: 2,
                          color: Colors.white.withOpacity(0.15),
                        ),
                      ),
                    ),
                    child: _buildContent(),
                  ),
                ),
              ),
            ),
          );
        },
      );

  Widget _buildContent() {
    if (_shapeAnimation.value > 0.1) {
      return const Center(
        child: Icon(
          Icons.graphic_eq,
          color: Color(0xff5FECFF),
          size: 24,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Hoda an Han',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Panorama FM',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.pause, color: Colors.white, size: 24),
              SizedBox(width: 4),
              Icon(Icons.skip_next, color: Colors.white, size: 24),
            ],
          ),
        ],
      ),
    );
  }
}
