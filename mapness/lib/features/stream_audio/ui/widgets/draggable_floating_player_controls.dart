import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/features/stream_audio/ui/providers/stream_audio_prov.dart';
import 'package:mapness/features/stream_audio/ui/widgets/audio_wave_icon.dart';

class DraggableFloatingPlayerControls extends StatefulWidget {
  const DraggableFloatingPlayerControls(
      {required this.onTap, required this.onChange, super.key});

  final Function onTap;
  final Function(bool isHolding, bool mustRemove) onChange;

  @override
  State<DraggableFloatingPlayerControls> createState() =>
      _DraggableFloatingPlayerControlsState();
}

class _DraggableFloatingPlayerControlsState
    extends State<DraggableFloatingPlayerControls>
    with TickerProviderStateMixin {
  // Position tracking
  Offset _position = const Offset(0, 0);
  Offset _initialPosition = const Offset(0, 0);
  Offset _dragStartPosition = Offset.zero;

  // Animation controllers
  late AnimationController _scaleController;
  late AnimationController _snapController;
  late AnimationController _shapeController;
  late AnimationController _momentumController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shapeAnimation;
  Animation<Offset>? _snapAnimation;
  Animation<Offset>? _momentumAnimation;

  // Widget dimensions
  static const double widgetWidth = 220;
  static const double widgetHeight = 48;
  static const double circleSize = 60;
  static const double edgeThreshold = 50;
  static const double removeThreshold = 50;

  // States
  bool _isDragging = false;
  bool isCollapsed = false;
  bool _inRemovalZone = false;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 0.95).animate(_scaleController);

    _snapController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _shapeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _shapeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_shapeController);

    _momentumController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _momentumController
      ..addListener(() {
        if (_momentumAnimation != null && _momentumController.isAnimating) {
          setState(() {
            _position = _momentumAnimation!.value;
          });
        }
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _checkPositionAndTransform();
        }
      });

    _snapAnimation = Tween<Offset>(begin: Offset.zero, end: Offset.zero)
        .animate(_snapController);
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _snapController.dispose();
    _shapeController.dispose();
    _momentumController.dispose();
    super.dispose();
  }

  void _expandToCenter() {
    _snapAnimation = Tween<Offset>(
      begin: _position,
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(parent: _snapController, curve: Curves.easeOut));

    setState(() => isCollapsed = false);

    _shapeController.reverse();
    _snapController.forward(from: 0).then((_) {
      setState(() {
        _position = const Offset(0, 0);
      });
    });
  }

  void _collapseToEdge(bool toLeft, double yPosition) {
    final screenWidth = MediaQuery.of(context).size.width;
    final targetX = toLeft
        ? -screenWidth / 2 + circleSize / 2
        : screenWidth / 2 - circleSize / 2;

    setState(() {
      _position = Offset(targetX, yPosition);
      isCollapsed = true;
    });

    _shapeController.forward();
    HapticFeedback.lightImpact();
  }

  void _checkPositionAndTransform() {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    // Calculate boundaries
    final leftBoundaryRect = -screenWidth / 2 + widgetWidth / 2;
    final rightBoundaryRect = screenWidth / 2 - widgetWidth / 2;
    final bottomBoundary = screenHeight / 2 - widgetHeight / 2 - bottomPadding;

    // Check if at bottom edge
    final distanceFromBottom = (bottomBoundary - _position.dy).abs();
    if (distanceFromBottom < 10) {
      // Hit bottom edge - triggering onTap
      widget.onChange(false, false);
      widget.onTap();
      setState(() {
        _position = Offset(_position.dx, bottomBoundary - 20);
      });
      HapticFeedback.mediumImpact();
      return;
    }

    // For expanded controls, check if near edges to collapse
    if (!isCollapsed) {
      final distanceFromLeft = (_position.dx - leftBoundaryRect).abs();
      final distanceFromRight = (_position.dx - rightBoundaryRect).abs();

      if (distanceFromLeft < edgeThreshold) {
        _collapseToEdge(true, _position.dy);
      } else if (distanceFromRight < edgeThreshold) {
        _collapseToEdge(false, _position.dy);
      }
    } else {
      // For collapsed controls, determine which edge we're closest to
      final leftEdge = -screenWidth / 2 + circleSize / 2;
      final rightEdge = screenWidth / 2 - circleSize / 2;
      final distanceFromLeft = (_position.dx - leftEdge).abs();
      final distanceFromRight = (rightEdge - _position.dx).abs();

      // If we're close to either edge, stay collapsed and snap to the nearest edge
      if (distanceFromLeft < edgeThreshold ||
          distanceFromRight < edgeThreshold) {
        final snapToLeft = distanceFromLeft < distanceFromRight;
        _collapseToEdge(snapToLeft, _position.dy);
      } else {
        setState(() => isCollapsed = false);
        _shapeController.reverse();
      }
    }
  }

  void _applyMomentum(Velocity velocity) {
    final pixelsPerSecond = velocity.pixelsPerSecond;
    final screenSize = MediaQuery.of(context).size;

    // Subtle momentum
    const decelerationFactor = 0.15;
    final endPosition = Offset(
      _position.dx + pixelsPerSecond.dx * decelerationFactor,
      _position.dy + pixelsPerSecond.dy * decelerationFactor,
    );

    // Apply boundaries based on current shape
    final currentWidth = isCollapsed ? circleSize : widgetWidth;
    final currentHeight = isCollapsed ? circleSize : widgetHeight;

    final leftBoundary = -screenSize.width / 2 + currentWidth / 2;
    final rightBoundary = screenSize.width / 2 - currentWidth / 2;
    final topBoundary = -screenSize.height / 2 +
        currentHeight / 2 +
        MediaQuery.of(context).padding.top;
    final bottomBoundary = screenSize.height / 2 -
        currentHeight / 2 -
        MediaQuery.of(context).padding.bottom;

    final constrainedEnd = Offset(
      endPosition.dx.clamp(leftBoundary, rightBoundary),
      endPosition.dy.clamp(topBoundary, bottomBoundary),
    );

    _momentumAnimation = Tween<Offset>(
      begin: _position,
      end: constrainedEnd,
    ).animate(CurvedAnimation(
      parent: _momentumController,
      curve: Curves.decelerate,
    ));

    _momentumController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: Listenable.merge([
          _scaleAnimation,
          _snapController,
          _shapeAnimation,
          _momentumController
        ]),
        builder: (context, child) {
          final currentPosition =
              _snapController.isAnimating && _snapAnimation != null
                  ? _snapAnimation!.value
                  : _position;

          final currentWidth =
              widgetWidth + (circleSize - widgetWidth) * _shapeAnimation.value;
          final currentHeight = widgetHeight +
              (circleSize - widgetHeight) * _shapeAnimation.value;
          final currentBorderRadius =
              12.0 + (circleSize / 2 - 12.0) * _shapeAnimation.value;

          return Transform.translate(
            offset: currentPosition,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  if (!isCollapsed) {
                    widget.onTap();
                  } else {
                    _expandToCenter();
                  }
                },
                onPanStart: (details) {
                  _momentumController.stop();

                  // Notify parent that dragging started
                  widget.onChange(true, false);

                  setState(() {
                    _isDragging = true;
                    _initialPosition = _position;
                    _dragStartPosition = details.localPosition;
                    _inRemovalZone = false;
                  });
                  _scaleController.forward();
                },
                onPanUpdate: (details) {
                  final screenSize = MediaQuery.of(context).size;
                  final dragDelta = details.localPosition - _dragStartPosition;
                  final newPosition = _initialPosition + dragDelta;

                  // Get screen bounds
                  final screenWidth = screenSize.width;
                  final screenHeight = screenSize.height;
                  final topPadding = MediaQuery.of(context).padding.top;
                  final bottomPadding = MediaQuery.of(context).padding.bottom;

                  // Calculate boundaries based on current shape
                  final currentWidth = isCollapsed ? circleSize : widgetWidth;
                  final currentHeight = isCollapsed ? circleSize : widgetHeight;

                  final leftBoundary = -screenWidth / 2 + currentWidth / 2;
                  final rightBoundary = screenWidth / 2 - currentWidth / 2;
                  final topBoundary =
                      -screenHeight / 2 + currentHeight / 2 + topPadding;
                  final bottomBoundary =
                      screenHeight / 2 - currentHeight / 2 - bottomPadding;

                  // Constrain position (but allow going beyond top for removal)
                  final constrainedX =
                      newPosition.dx.clamp(leftBoundary, rightBoundary);
                  final constrainedY =
                      newPosition.dy.clamp(topBoundary, bottomBoundary);

                  setState(() {
                    _position = Offset(constrainedX, constrainedY);
                  });

                  // Check if dragging to top for removal
                  final distanceFromTop = (constrainedY - topBoundary).abs();

                  if (distanceFromTop < removeThreshold &&
                      constrainedY == topBoundary) {
                    // In removal zone - notify parent to show removal UI
                    if (!_inRemovalZone) {
                      _inRemovalZone = true;
                      widget.onChange(true, true);
                      HapticFeedback.selectionClick();
                    }
                  } else {
                    // Not in removal zone
                    if (_inRemovalZone) {
                      _inRemovalZone = false;
                      widget.onChange(true, false);
                    }
                  }

                  // Check for bottom edge hit during drag
                  if ((bottomBoundary - constrainedY).abs() < 5 &&
                      constrainedY != newPosition.dy) {
                    widget.onTap();
                    HapticFeedback.mediumImpact();
                  }

                  // For expanded controls, check if dragging to edges (similar to old code)
                  if (!isCollapsed) {
                    final leftBoundaryRect = -screenWidth / 2 + widgetWidth / 2;
                    final rightBoundaryRect = screenWidth / 2 - widgetWidth / 2;

                    final isAtLeftEdge =
                        (constrainedX - leftBoundaryRect).abs() < 0.5;
                    final isAtRightEdge =
                        (constrainedX - rightBoundaryRect).abs() < 0.5;
                    final wasConstrained = constrainedX != newPosition.dx;

                    if ((isAtLeftEdge || isAtRightEdge) && wasConstrained) {
                      final leftBoundaryCircle =
                          -screenWidth / 2 + circleSize / 2;
                      final rightBoundaryCircle =
                          screenWidth / 2 - circleSize / 2;
                      final adjustedX = isAtLeftEdge
                          ? leftBoundaryCircle
                          : rightBoundaryCircle;

                      setState(() {
                        _position = Offset(adjustedX, constrainedY);
                        isCollapsed = true;
                        _isDragging = false;
                      });

                      _shapeController.forward();
                      _scaleController.reverse();
                      HapticFeedback.lightImpact();
                    }
                  }
                },
                onPanEnd: (details) {
                  final screenSize = MediaQuery.of(context).size;
                  final topPadding = MediaQuery.of(context).padding.top;
                  final currentHeight = isCollapsed ? circleSize : widgetHeight;
                  final topBoundary =
                      -screenSize.height / 2 + currentHeight / 2 + topPadding;
                  final distanceFromTop = (_position.dy - topBoundary).abs();
                  if (distanceFromTop < removeThreshold && _inRemovalZone) {
                    widget.onChange(false, true);
                    HapticFeedback.mediumImpact();
                    return;
                  }

                  widget.onChange(false, false);

                  setState(() {
                    _isDragging = false;
                    _inRemovalZone = false;
                  });
                  _scaleController.reverse();

                  // Apply momentum if velocity is significant
                  if (details.velocity.pixelsPerSecond.distance > 100) {
                    _applyMomentum(details.velocity);
                  } else {
                    // No significant velocity - check position for transformation
                    _checkPositionAndTransform();
                  }
                },
                child: Container(
                  width: currentWidth,
                  height: currentHeight,
                  decoration: BoxDecoration(
                    // Debug visuals - remove for production
                    // color: Colors.red.withOpacity(0.2),
                    border:
                        Border.all(color: Colors.white.withValues(alpha: 0.15)),
                    borderRadius: BorderRadius.circular(currentBorderRadius),
                  ),
                  child: Container(
                    decoration: ShapeDecoration(
                      shadows: [
                        BoxShadow(
                          color: const Color(0x7F212222),
                          blurRadius: _isDragging ? 24 : 16,
                          offset: _isDragging
                              ? const Offset(0, 12)
                              : const Offset(0, 8),
                          spreadRadius: -8,
                        )
                      ],
                      gradient: const LinearGradient(
                        begin: Alignment(0.50, -0.00),
                        end: Alignment(0.50, 1.00),
                        colors: [Color(0xFF212222), Color(0xFF212222)],
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(currentBorderRadius)),
                        side: BorderSide(
                          width: 2,
                          color: Colors.white.withValues(alpha: 0.15),
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
        child: AudioWaveIcon(
          size: 50.0,
          showBackground: false,
          waveCount: 7,
        ),
      );
    }

    return const Content();
  }
}

class Content extends ConsumerStatefulWidget {
  const Content({super.key});

  @override
  ConsumerState<Content> createState() => _ContentState();
}

class _ContentState extends ConsumerState<Content> {
  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(streamAudioProvider);
    final selectedProgram = provider.selectedProgram;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Row(
        children: [
          Container(
            height: 32,
            width: 32,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(selectedProgram?.programImage.keyName ?? ''),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: Colors.white.withValues(alpha: 0.15), width: 1.5),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedProgram?.title ?? '-',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  selectedProgram?.sub ?? '-',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () async {
                  final audioProvider = ref.read(streamAudioProvider);
                  await audioProvider.togglePlayPause();
                },
                child: provider.isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : SvgPicture.asset(
                        provider.isPlaying
                            ? Assets.icons.svg.audio.pause.keyName
                            : Assets.icons.svg.audio.resume.keyName,
                      ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () async {
                  final audioProvider = ref.read(streamAudioProvider);
                  await audioProvider.seekForward();
                },
                child: SvgPicture.asset(
                    Assets.icons.svg.audio.seekForward.keyName),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
