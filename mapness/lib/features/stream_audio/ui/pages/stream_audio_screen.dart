import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/stream_audio/ui/providers/stream_audio_prov.dart';
import 'package:mapness/features/stream_audio/ui/widgets/draggable_floating_player_controls.dart';
import 'package:mapness/features/stream_audio/ui/widgets/playing_audio_tile.dart';
import 'package:mapness/features/stream_audio/ui/widgets/sheet_channels_list.dart';

class StreamAudio extends ConsumerStatefulWidget {
  final Widget child;

  const StreamAudio({required this.child, super.key});

  @override
  ConsumerState<StreamAudio> createState() => _StreamAudioState();
}

class _StreamAudioState extends ConsumerState<StreamAudio> with WidgetsBindingObserver {
  final DraggableScrollableController _sheetController = DraggableScrollableController();

  final double _minChildSize = 0.0;
  final double _maxChildSize = 0.34;
  bool _showRemovalZone = false;

  /// Timer for 8-second auto-close
  Timer? _autoCloseTimer;

  /// Keyboard visibility detection
  late final StreamSubscription<bool> _keyboardVisibilitySubscription;
  final KeyboardVisibilityController _keyboardVisibilityController = KeyboardVisibilityController();

  /// Track if we've already triggered the 150px threshold
  bool _hasTriggeredHeightThreshold = false;
  bool _isPanelFullyOpened = false;

  /// Landscape mode properties
  double _landscapeSheetWidth = 0.0; // 0 = closed, 1 = fully open (in percentage)
  final double _landscapeMaxWidth = 0.4; // 30% of screen width

  /// Track previous orientation to handle transitions
  Orientation? _previousOrientation;

  /// Cached in initState: riverpod 3 forbids `ref` inside dispose (unmount
  /// runs before State.dispose), and the provider is a non-autoDispose global,
  /// so the instance is stable for the app's lifetime.
  StreamAudioProvider? _streamAudio;

  @override
  void initState() {
    super.initState();

    // Initialize keyboard visibility listener
    _keyboardVisibilitySubscription = _keyboardVisibilityController.onChange.listen(_onKeyboardToggle);
    WidgetsBinding.instance.addObserver(this);

    _streamAudio = ref.read(streamAudioProvider);
    Future.microtask(() {
      if (!mounted) {
        return;
      }
      _streamAudio
        ?..getChannels()
        // Register the togglePanel callback with the provider
        ..setTogglePanelCallback(togglePanel);
    });
  }

  @override
  void dispose() {
    _autoCloseTimer?.cancel();

    // Dispose keyboard visibility listener
    _keyboardVisibilitySubscription.cancel();
    WidgetsBinding.instance.removeObserver(this);

    // Unregister the callback when disposing (only if it is still ours)
    _streamAudio?.clearTogglePanelCallback(togglePanel);
    super.dispose();
  }

  /// Handles keyboard visibility changes
  void _onKeyboardToggle(bool isVisible) {
    if (!isVisible) {
      return; // Only act when keyboard opens, not when it closes
    }

    final screenSize = MediaQuery.of(context).size;
    final isLandscape = screenSize.width > screenSize.height;

    bool shouldClose = false;

    if (isLandscape) {
      // Check if landscape sheet is open
      shouldClose = _landscapeSheetWidth > 0;
    } else {
      // Check if portrait sheet is open
      final currentSize = _sheetController.isAttached ? _sheetController.size : _minChildSize;
      shouldClose = currentSize > _minChildSize;
    }

    // Close the sheet if it's open
    if (shouldClose) {
      togglePanel();
    }
  }

  /// Toggles the panel between open and closed states
  void togglePanel() {
    final screenSize = MediaQuery.of(context).size;
    final isLandscape = screenSize.width > screenSize.height;

    if (isLandscape) {
      // Toggle landscape side sheet
      final targetWidth = _landscapeSheetWidth > _landscapeMaxWidth / 2 ? 0.0 : _landscapeMaxWidth;

      /// Cancel any existing timer
      _autoCloseTimer?.cancel();

      /// If opening the panel, start the 8-second timer
      if (targetWidth == _landscapeMaxWidth) {
        if (mounted) {
          setState(() => _showRemovalZone = false);
        }
        _autoCloseTimer = Timer(const Duration(seconds: 8), () {
          if (mounted && _landscapeSheetWidth > 0) {
            setState(() => _landscapeSheetWidth = 0.0);
          }
        });
      }

      if (mounted) {
        setState(() => _landscapeSheetWidth = targetWidth);
      }
    } else {
      // Toggle portrait bottom sheet
      if (_sheetController.isAttached) {
        final currentSize = _sheetController.size;
        final targetSize = currentSize > (_minChildSize + _maxChildSize) / 2 ? _minChildSize : _maxChildSize;

        /// Cancel any existing timer
        _autoCloseTimer?.cancel();

        /// If opening the panel, start the 8-second timer
        if (targetSize == _maxChildSize) {
          if (mounted) {
            setState(() => _showRemovalZone = false);
          }
          _autoCloseTimer = Timer(const Duration(seconds: 8), () {
            if (mounted && _sheetController.isAttached && _sheetController.size > _minChildSize) {
              _sheetController.animateTo(
                _minChildSize,
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOut,
              );
            }
          });
        }
        _sheetController.animateTo(
          targetSize,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(streamAudioProvider);

    // Was an OrientationBuilder, which is a LayoutBuilder underneath. Because
    // StreamAudio wraps the whole app (app.dart), that gave every widget below
    // it a BuildScope owned by a LayoutBuilder - so *every* rebuild in the app
    // was flushed during layout. Any inherited change in that window that woke
    // a consumer inside a nested LayoutBuilder then marked layout dirty out of
    // turn (`_debugRelayoutBoundaryAlreadyMarkedNeedsLayout`).
    //
    // MediaQuery gives the same orientation for a full-screen wrapper through a
    // plain InheritedWidget, so rebuilds happen in the normal build phase.
    final orientation = MediaQuery.orientationOf(context);
    final isLandscape = orientation == Orientation.landscape;

    // Handle orientation change safely
    if (_previousOrientation != null && _previousOrientation != orientation) {
      final wasLandscape = _previousOrientation == Orientation.landscape;
      _previousOrientation = orientation;

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) {
          return;
        }

        try {
          if (isLandscape && !wasLandscape) {
            // Switching to landscape: if portrait sheet was open, open landscape sheet
            if (_sheetController.isAttached && _sheetController.size > _minChildSize) {
              setState(() {
                _landscapeSheetWidth = _landscapeMaxWidth;
              });
            }
          } else if (!isLandscape && wasLandscape) {
            // Switching to portrait: if landscape sheet was open, open portrait sheet
            if (_landscapeSheetWidth > 0) {
              setState(() {
                _landscapeSheetWidth = 0;
              });

              // Wait a frame before animating the portrait sheet
              await Future.delayed(const Duration(milliseconds: 50));
              if (mounted && _sheetController.isAttached) {
                await _sheetController.animateTo(
                  _maxChildSize,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                );
              }
            }
          }
        } catch (e) {
          debugPrint('StreamAudio orientation change error: $e');
        }
      });
    }

    // Update orientation tracking if it's the first build
    if (_previousOrientation == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _previousOrientation = orientation;
      });
    }

    return _buildUnifiedLayout(provider, isLandscape);
  }

  Widget _buildUnifiedLayout(StreamAudioProvider provider, bool isLandscape) => AnimatedBuilder(
    animation: _sheetController,
    builder: (context, _) {
      // Portrait calculations
      final double currentSize = _sheetController.isAttached ? _sheetController.size : _minChildSize;
      final double progress = (currentSize - _minChildSize) / (_maxChildSize - _minChildSize);
      final double portraitMapOffset = -320 * progress;

      final screenHeight = MediaQuery.of(context).size.height;
      final currentHeightPx = currentSize * screenHeight;

      if (currentSize >= _maxChildSize - 0.01) {
        _isPanelFullyOpened = true;
      }

      if (_isPanelFullyOpened &&
          currentHeightPx <= 150 &&
          !_hasTriggeredHeightThreshold &&
          currentSize > _minChildSize &&
          currentSize < _maxChildSize &&
          _autoCloseTimer != null &&
          _autoCloseTimer!.isActive) {
        _hasTriggeredHeightThreshold = true;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _autoCloseTimer?.cancel();
          if (_sheetController.isAttached) {
            _sheetController.animateTo(
              _minChildSize,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        });
      }

      if (currentSize == _minChildSize) {
        _hasTriggeredHeightThreshold = false;
        _isPanelFullyOpened = false;
      }

      // Landscape calculations
      final screenWidth = MediaQuery.of(context).size.width;
      final sheetWidthPx = screenWidth * _landscapeSheetWidth;
      final bool isRtl = Directionality.of(context) == TextDirection.rtl;
      final bool sheetFromLeft = isRtl;
      final double landscapeMapOffset = sheetFromLeft ? sheetWidthPx : -sheetWidthPx;

      // Unified values
      final double xOffset = isLandscape ? landscapeMapOffset : 0;
      final double yOffset = isLandscape ? 0 : portraitMapOffset;
      final double bottomRadius = (isLandscape || currentSize == _minChildSize) ? 0 : 32;

      return Container(
        color: const Color(0xff0D121C),
        child: Stack(
          children: [
            // 1. The Main App Content (widget.child)
            AnimatedContainer(
              duration: isLandscape ? const Duration(milliseconds: 350) : Duration.zero,
              curve: Curves.easeOutCubic,
              transform: Matrix4.translationValues(xOffset, yOffset, 0),
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(bottomRadius),
                  ),
                ),
                child: widget.child,
              ),
            ),

            // 2. Floating Controls
            _buildFloatingControls(provider, currentSize, isLandscape),

            // 3. Portrait Details Sheet
            if (!isLandscape) _buildDetailsControlsSheet(provider),

            // 4. Landscape Details Sheet
            if (isLandscape)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
                left: sheetFromLeft ? (_landscapeSheetWidth == 0 ? -screenWidth * _landscapeMaxWidth : 0) : null,
                right: !sheetFromLeft ? (_landscapeSheetWidth == 0 ? -screenWidth * _landscapeMaxWidth : 0) : null,
                top: 0,
                bottom: 0,
                width: screenWidth * _landscapeMaxWidth,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onHorizontalDragUpdate: (details) {
                    final bool shouldClose = sheetFromLeft ? (details.delta.dx < -6) : (details.delta.dx > 6);
                    if (shouldClose && mounted && _landscapeSheetWidth > 0) {
                      setState(() => _landscapeSheetWidth = 0.0);
                    }
                  },
                  onHorizontalDragEnd: (details) {
                    final double velocity = details.primaryVelocity ?? 0;
                    final bool shouldClose = sheetFromLeft ? (velocity < -300) : (velocity > 300);
                    if (shouldClose && mounted && _landscapeSheetWidth > 0) {
                      setState(() => _landscapeSheetWidth = 0.0);
                    }
                  },
                  child: Container(
                    decoration: const BoxDecoration(color: Color(0xff0D121C)),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: sheetFromLeft
                            ? const Border(right: BorderSide(color: Colors.white24))
                            : const Border(left: BorderSide(color: Colors.white24)),
                      ),
                      child: _buildLandscapeSheetContent(provider),
                    ),
                  ),
                ),
              ),

            // 5. Removal zone widget
            _buildRemovalZone(),
          ],
        ),
      );
    },
  );

  Widget _buildFloatingControls(StreamAudioProvider provider, double currentSize, bool isLandscape) {
    if (provider.selectedChannel == null || !provider.isFloatingPlayerVisible) {
      return const SizedBox.shrink();
    }

    // In portrait, it hides when the sheet is open
    if (!isLandscape && currentSize != _minChildSize) {
      return const SizedBox.shrink();
    }
    // In landscape, it hides when the sheet is open
    if (isLandscape && _landscapeSheetWidth > 0) {
      return const SizedBox.shrink();
    }

    return Center(
      child: DraggableFloatingPlayerControls(
        onTap: togglePanel,
        onChange: ({required isHolding, required mustRemove}) {
          if (mounted) {
            setState(() => _showRemovalZone = isHolding);
            if (mustRemove) {
              ref.read(streamAudioProvider.notifier).exitPlayer();
              setState(() => _showRemovalZone = false);
            }
          }
        },
      ),
    );
  }

  Widget _buildLandscapeSheetContent(StreamAudioProvider provider) => SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left side: PlayingAudioTile (vertical layout)
        const Expanded(
          flex: 2,
          child: PlayingAudioTile(isLandscape: true, instanceId: 'landscape_sheet'),
        ),
        const SizedBox(width: 16),
        // Right side: MediaCatalogList (vertical layout)
        SizedBox(
          width: 160,
          child: MediaCatalogList(
            isLandscape: true,
            needReset: () {
              //reset the timer
              _autoCloseTimer?.cancel();
              _autoCloseTimer = Timer(const Duration(seconds: 8), () {
                if (mounted && _landscapeSheetWidth > 0) {
                  setState(() => _landscapeSheetWidth = 0.0);
                }
              });
            },
          ),
        ),
      ],
    ),
  );

  Widget _buildDetailsControlsSheet(StreamAudioProvider provider) => AnimatedBuilder(
    animation: _sheetController,
    builder: (context, _) {
      final double currentSize = _sheetController.isAttached ? _sheetController.size : _minChildSize;
      final bool isVisible = currentSize > _minChildSize;

      return DraggableScrollableSheet(
        controller: _sheetController,
        initialChildSize: _minChildSize,
        minChildSize: _minChildSize,
        maxChildSize: _maxChildSize,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: isVisible ? const Color(0xff0D121C) : Colors.transparent,
          ),
          child: Opacity(
            opacity: isVisible ? 1.0 : 0.0,
            child: SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(0),
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 3,
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(36),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const PlayingAudioTile(instanceId: 'portrait_sheet'),
                  if (provider.hasError) ...[
                    const SizedBox(height: 16),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        border: Border.all(color: Colors.red.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              Directionality.of(context) == TextDirection.rtl
                                  ? 'لم يتم اكتشاف اتصال بالإنترنت ، يرجى التحقق منه والمحاولة مرة أخرى..'
                                  : 'No internet connection detected, please check it and try again.',
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  MediaCatalogList(
                    needReset: () {
                      //reset the timer
                      _autoCloseTimer?.cancel();
                      _autoCloseTimer = Timer(const Duration(seconds: 8), () {
                        if (mounted && _sheetController.isAttached && _sheetController.size > _minChildSize) {
                          _sheetController.animateTo(
                            _minChildSize,
                            duration: const Duration(milliseconds: 800),
                            curve: Curves.easeInOut,
                          );
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );

  Widget _buildRemovalZone() => Positioned(
    top: 0,
    right: 0,
    left: 0,
    child: AnimatedOpacity(
      opacity: _showRemovalZone ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 220),
      child: IgnorePointer(
        ignoring: !_showRemovalZone,
        child: Stack(
          children: [
            ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white, Colors.transparent],
                  ).createShader(bounds),
                  blendMode: BlendMode.dstOut,
                  child: Container(
                    height: 160,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: const Alignment(0.50, -0.00),
                        end: const Alignment(0.50, 1.00),
                        colors: [Colors.black.withOpacity(0.20), Colors.black.withOpacity(0)],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 80,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 240,
                  height: 40,
                  padding: const EdgeInsets.only(top: 8, left: 8, right: 16, bottom: 8),
                  decoration: ShapeDecoration(
                    color: Colors.black.withOpacity(0.65),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white.withOpacity(0.20)),
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.close, color: Colors.white.withOpacity(0.80), size: 22),
                      Text(
                        Directionality.of(context) == TextDirection.rtl
                            ? 'اسحب هنا للخروج من مشغل الصوت'
                            : 'Drag here to exit audio player',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 1.33,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
