import 'dart:ui';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/features/stream_audio/ui/providers/stream_audio_prov.dart';
import 'package:mapness/features/stream_audio/ui/stream_audio_colors.dart';
import 'package:mapness/features/stream_audio/ui/widgets/audio_wave_icon.dart';

class DraggableFloatingPlayerControls extends StatefulWidget {
  const DraggableFloatingPlayerControls({required this.onTap, required this.onChange, super.key});

  final Function onTap;
  final Function({required bool isHolding, required bool mustRemove}) onChange;

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
  static const double removeThreshold = 100;

  // States
  bool _isDragging = false;
  bool isCollapsed = false;
  bool _inRemovalZone = false;
  bool _openTriggeredThisDrag = false;

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

    _snapAnimation = Tween<Offset>(begin: Offset.zero, end: Offset.zero).animate(_snapController);
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
    final targetX = toLeft ? -screenWidth / 2 + circleSize / 2 : screenWidth / 2 - circleSize / 2;

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
    final isLandscape = screenWidth > screenHeight;
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;

    // Calculate boundaries
    final leftBoundaryRect = -screenWidth / 2 + widgetWidth / 2;
    final rightBoundaryRect = screenWidth / 2 - widgetWidth / 2;
    final bottomBoundary = screenHeight / 2 - widgetHeight / 2 - bottomPadding;

    // Check orientation-specific trigger edge
    if (isLandscape) {
      if (isRtl) {
        // RTL landscape: open when hitting the far LEFT edge
        final distanceFromLeft = (_position.dx - leftBoundaryRect).abs();
        if (distanceFromLeft < 10) {
          widget.onChange(isHolding: false, mustRemove: false);
          widget.onTap();
          setState(() {
            _position = Offset(leftBoundaryRect + 20, _position.dy);
          });
          HapticFeedback.mediumImpact();
          return;
        }
      } else {
        // LTR landscape: open when hitting the far RIGHT edge
        final distanceFromRight = (rightBoundaryRect - _position.dx).abs();
        if (distanceFromRight < 10) {
          widget.onChange(isHolding: false, mustRemove: false);
          widget.onTap();
          setState(() {
            _position = Offset(rightBoundaryRect - 20, _position.dy);
          });
          HapticFeedback.mediumImpact();
          return;
        }
      }
    } else {
      // In portrait, check bottom edge
      final distanceFromBottom = (bottomBoundary - _position.dy).abs();
      if (distanceFromBottom < 10) {
        // Hit bottom edge - triggering onTap
        widget.onChange(isHolding: false, mustRemove: false);
        widget.onTap();
        setState(() {
          _position = Offset(_position.dx, bottomBoundary - 20);
        });
        HapticFeedback.mediumImpact();
        return;
      }
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
      if (distanceFromLeft < edgeThreshold || distanceFromRight < edgeThreshold) {
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
    final topBoundary = -screenSize.height / 2 + currentHeight / 2 + MediaQuery.of(context).padding.top;
    final bottomBoundary = screenSize.height / 2 - currentHeight / 2 - MediaQuery.of(context).padding.bottom;

    final constrainedEnd = Offset(
      endPosition.dx.clamp(leftBoundary, rightBoundary),
      endPosition.dy.clamp(topBoundary, bottomBoundary),
    );

    _momentumAnimation =
        Tween<Offset>(
          begin: _position,
          end: constrainedEnd,
        ).animate(
          CurvedAnimation(
            parent: _momentumController,
            curve: Curves.decelerate,
          ),
        );

    _momentumController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: Listenable.merge([_scaleAnimation, _snapController, _shapeAnimation, _momentumController]),
    builder: (context, child) {
      final theme = context.streamAudioColors;
      final currentPosition = _snapController.isAnimating && _snapAnimation != null ? _snapAnimation!.value : _position;

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
              if (!isCollapsed) {
                widget.onTap();
              } else {
                _expandToCenter();
              }
            },
            onPanStart: (details) {
              _momentumController.stop();

              // Notify parent that dragging started
              widget.onChange(isHolding: true, mustRemove: false);

              setState(() {
                _isDragging = true;
                _initialPosition = _position;
                _dragStartPosition = details.localPosition;
                _inRemovalZone = false;
                _openTriggeredThisDrag = false;
              });
              _scaleController.forward();
            },
            onPanUpdate: (details) {
              final screenSize = MediaQuery.of(context).size;
              final bool isRtl = Directionality.of(context) == TextDirection.rtl;
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
              final topBoundary = -screenHeight / 2 + currentHeight / 2 + topPadding;
              final bottomBoundary = screenHeight / 2 - currentHeight / 2 - bottomPadding;

              // Constrain position (but allow going beyond top for removal)
              final constrainedX = newPosition.dx.clamp(leftBoundary, rightBoundary);
              final constrainedY = newPosition.dy.clamp(topBoundary, bottomBoundary);

              setState(() {
                _position = Offset(constrainedX, constrainedY);
              });

              // Check if dragging to top for removal
              final distanceFromTop = (constrainedY - topBoundary).abs();

              if (distanceFromTop <= removeThreshold) {
                // In removal zone - notify parent to show removal UI
                if (!_inRemovalZone) {
                  _inRemovalZone = true;
                  widget.onChange(isHolding: true, mustRemove: true);
                  HapticFeedback.selectionClick();
                }
              } else {
                // Not in removal zone
                if (_inRemovalZone) {
                  _inRemovalZone = false;
                  widget.onChange(isHolding: true, mustRemove: false);
                }
              }

              // Check for edge hit during drag (orientation-specific)
              final isLandscape = screenWidth > screenHeight;
              if (isLandscape) {
                if (isRtl) {
                  // RTL landscape: only open when reaching far LEFT edge
                  if ((constrainedX - leftBoundary).abs() < 5 &&
                      constrainedX != newPosition.dx &&
                      !_openTriggeredThisDrag) {
                    _openTriggeredThisDrag = true;
                    widget.onTap();
                    HapticFeedback.mediumImpact();
                  }
                } else {
                  // LTR landscape: open when reaching far RIGHT edge
                  if ((rightBoundary - constrainedX).abs() < 5 && constrainedX != newPosition.dx) {
                    widget.onTap();
                    HapticFeedback.mediumImpact();
                  }
                }
              } else {
                // Check for bottom edge hit in portrait
                if ((bottomBoundary - constrainedY).abs() < 5 && constrainedY != newPosition.dy) {
                  widget.onTap();
                  HapticFeedback.mediumImpact();
                }
              }

              // For expanded controls, check if dragging to edges (similar to old code)
              if (!isCollapsed) {
                final leftBoundaryRect = -screenWidth / 2 + widgetWidth / 2;
                final rightBoundaryRect = screenWidth / 2 - widgetWidth / 2;

                final isAtLeftEdge = (constrainedX - leftBoundaryRect).abs() < 0.5;
                final isAtRightEdge = (constrainedX - rightBoundaryRect).abs() < 0.5;
                final wasConstrained = constrainedX != newPosition.dx;

                if ((isAtLeftEdge || isAtRightEdge) && wasConstrained) {
                  final leftBoundaryCircle = -screenWidth / 2 + circleSize / 2;
                  final rightBoundaryCircle = screenWidth / 2 - circleSize / 2;
                  final adjustedX = isAtLeftEdge ? leftBoundaryCircle : rightBoundaryCircle;

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
              final topBoundary = -screenSize.height / 2 + currentHeight / 2 + topPadding;
              final distanceFromTop = (_position.dy - topBoundary).abs();
              if (distanceFromTop < removeThreshold && _inRemovalZone) {
                widget.onChange(isHolding: false, mustRemove: true);
                HapticFeedback.mediumImpact();
                return;
              }

              widget.onChange(isHolding: false, mustRemove: false);

              setState(() {
                _isDragging = false;
                _inRemovalZone = false;
                _openTriggeredThisDrag = false;
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
                border: Border.all(color: theme.playerBorder),
                borderRadius: BorderRadius.circular(currentBorderRadius),
              ),
              child: Container(
                decoration: ShapeDecoration(
                  shadows: [
                    BoxShadow(
                      color: theme.playerShadow,
                      blurRadius: _isDragging ? 24 : 16,
                      offset: _isDragging ? const Offset(0, 12) : const Offset(0, 8),
                      spreadRadius: -8,
                    ),
                  ],
                  color: theme.playerBackground,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(currentBorderRadius)),
                    side: BorderSide(
                      width: 2,
                      color: theme.playerBorder,
                    ),
                  ),
                ),
                child: _buildContent(theme),
              ),
            ),
          ),
        ),
      );
    },
  );

  Widget _buildContent(StreamAudioColors theme) {
    if (_shapeAnimation.value > 0.1) {
      return const Center(
        child: AudioWaveIcon(
          size: 50.0,
          showBackground: false,
          waveCount: 7,
        ),
      );
    }

    return Content(theme: theme);
  }
}

class Content extends ConsumerStatefulWidget {
  const Content({required this.theme, super.key});

  final StreamAudioColors theme;

  @override
  ConsumerState<Content> createState() => _ContentState();
}

class _ContentState extends ConsumerState<Content> {
  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(streamAudioProvider);
    final selectedChannel = provider.selectedChannel;
    final theme = widget.theme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Row(
        children: [
          buildProgramImage(provider, theme),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 1.0),
                  child: Text(
                    selectedChannel?.currentPlayedProgram?.name ??
                        (Directionality.of(context) == TextDirection.rtl ? 'على الهواء' : 'On Air'),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: theme.playerText,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                      fontFamily: GeneralKey.appFontType,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 1),
                  child: Text(
                    selectedChannel?.name ?? 'MBC Mood',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: theme.playerMutedText,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 1.2,
                      fontFamily: GeneralKey.appFontType,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Play/Pause button
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                  final audioProvider = ref.read(streamAudioProvider);
                  await audioProvider.togglePlayPause();
                },
                child: Container(
                  width: 48,
                  height: 48,
                  color: Colors.transparent,
                  alignment: Alignment.center,
                  child: _buildPlayPauseIcon(provider, theme),
                ),
              ),
              // Forward button
              Transform.flip(
                flipX: Directionality.of(context) == TextDirection.rtl,
                child: AnimatedOpacity(
                  opacity: provider.canGoToNextChannel ? 1.0 : 0.4,
                  duration: const Duration(milliseconds: 200),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: !provider.canGoToNextChannel ? null : () => ref.read(streamAudioProvider).goToNextChannel(),
                    child: Container(
                      width: 48,
                      height: 48,
                      color: Colors.transparent,
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        Assets.icons.svg.audio.seekForward.keyName,
                        width: 14,
                        height: 14,
                        colorFilter: ColorFilter.mode(theme.playerText, BlendMode.srcIn),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlayPauseIcon(StreamAudioProvider provider, StreamAudioColors theme) {
    if (provider.isLoading) {
      return SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(theme.playerText),
        ),
      );
    }

    final shouldShowPlayIcon = !provider.isPlaying || provider.hasError;

    return SvgPicture.asset(
      shouldShowPlayIcon ? Assets.icons.svg.audio.resume.keyName : Assets.icons.svg.audio.pause.keyName,
      width: 16,
      height: 16,
      colorFilter: ColorFilter.mode(theme.playerText, BlendMode.srcIn),
    );
  }

  Widget buildProgramImage(StreamAudioProvider provider, StreamAudioColors theme) {
    final channel = provider.selectedChannel;
    final hasProgram = channel?.currentPlayedProgram != null;
    final programLogo = channel?.currentPlayedProgram?.image;
    final bool hasProgramLogo = programLogo != null && programLogo.isNotEmpty;
    final url = hasProgramLogo ? programLogo : (channel?.logo ?? 'https://www.mbcmood.com/images/Logo.png');

    return Stack(
      children: [
        Container(
          height: 32,
          width: 32,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: !url.contains('svg')
              ? Padding(
                  padding: const EdgeInsets.all(2),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      url,
                      fit: BoxFit.fitWidth,
                      errorBuilder: (_, __, ___) => Padding(
                        padding: const EdgeInsets.all(4),
                        child: Assets.icons.svg.icMbcMood.svg(
                          colorFilter: ColorFilter.mode(theme.placeholderIcon, BlendMode.srcIn),
                        ),
                      ),
                    ),
                  ),
                )
              : SvgPicture.network(
                  url,
                  placeholderBuilder: (_) => Padding(
                    padding: const EdgeInsets.all(4),
                    child: Assets.icons.svg.icMbcMood.svg(
                      colorFilter: ColorFilter.mode(theme.placeholderIcon, BlendMode.srcIn),
                    ),
                  ),
                ),
        ),
        if (!hasProgram)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1.4, sigmaY: 1.4),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.00, 1.00],
                    colors: [Colors.black.withValues(alpha: 0.6), Colors.black.withValues(alpha: 0.2)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
