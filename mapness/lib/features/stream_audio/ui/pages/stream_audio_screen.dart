import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/stream_audio/ui/providers/stream_audio_prov.dart';
import 'package:mapness/features/stream_audio/ui/widgets/draggable_floating_player_controls.dart';
import 'package:mapness/features/stream_audio/ui/widgets/media_catalog_list.dart';
import 'package:mapness/features/stream_audio/ui/widgets/playing_audio_tile.dart';

class StreamAudio extends ConsumerStatefulWidget {
  final Widget child;

  const StreamAudio({required this.child, super.key});

  @override
  ConsumerState<StreamAudio> createState() => _StreamAudioState();
}

class _StreamAudioState extends ConsumerState<StreamAudio> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final DraggableScrollableController _sheetController = DraggableScrollableController();

  final double _minChildSize = 0.0;
  final double _maxChildSize = 0.34;
  bool _showRemovalZone = false;

  /// Timer for 8-second auto-close
  Timer? _autoCloseTimer;

  /// Track if we've already triggered the 150px threshold
  bool _hasTriggeredHeightThreshold = false;
  bool _isPanelFullyOpened = false;

  /// Landscape mode properties
  double _landscapeSheetWidth = 0.0; // 0 = closed, 1 = fully open (in percentage)
  final double _landscapeMaxWidth = 0.4; // 30% of screen width

  /// Track previous orientation to handle transitions
  Orientation? _previousOrientation;
  bool _isTransitioningOrientation = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(streamAudioProvider).getChannels());
  }

  @override
  void dispose() {
    _autoCloseTimer?.cancel();
    super.dispose();
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
        _autoCloseTimer = Timer(const Duration(seconds: 80), () {
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
          _autoCloseTimer = Timer(const Duration(seconds: 80), () {
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

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      body: OrientationBuilder(
        builder: (context, orientation) {
          final isLandscape = orientation == Orientation.landscape;

          // Handle orientation change after frame
          if (_previousOrientation != null && _previousOrientation != orientation && !_isTransitioningOrientation) {
            _isTransitioningOrientation = true;

            WidgetsBinding.instance.addPostFrameCallback((_) async {
              if (!mounted) {
                _isTransitioningOrientation = false;
                return;
              }

              try {
                // Small delay to let the layout settle
                await Future.delayed(const Duration(milliseconds: 50));
                if (!mounted) {
                  return;
                }

                if (isLandscape) {
                  // Switching to landscape: if portrait sheet was open, open landscape sheet
                  if (_sheetController.isAttached && _sheetController.size > _minChildSize) {
                    if (mounted) {
                      setState(() {
                        _landscapeSheetWidth = _landscapeMaxWidth;
                        _isTransitioningOrientation = false;
                      });
                    }
                  } else {
                    if (mounted) {
                      setState(() => _isTransitioningOrientation = false);
                    }
                  }
                } else {
                  // Switching to portrait: if landscape sheet was open, open portrait sheet
                  if (_landscapeSheetWidth > 0) {
                    if (mounted) {
                      setState(() {
                        _landscapeSheetWidth = 0;
                        _isTransitioningOrientation = false;
                      });
                    }

                    // Wait a frame before animating the portrait sheet
                    await Future.delayed(const Duration(milliseconds: 100));
                    if (mounted && _sheetController.isAttached) {
                      await _sheetController.animateTo(
                        _maxChildSize,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOutCubic,
                      );
                    }
                  } else {
                    if (mounted) {
                      setState(() => _isTransitioningOrientation = false);
                    }
                  }
                }
              } catch (e) {
                // Silently handle any state transition errors during orientation change
                debugPrint('StreamAudio orientation change error: $e');
                if (mounted) {
                  setState(() => _isTransitioningOrientation = false);
                }
              }
            });
          }

          // Update orientation tracking after frame to avoid build-time mutation
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _previousOrientation = orientation;
          });

          // Show a simple black screen during rapid transitions to avoid layer disposal errors
          if (_isTransitioningOrientation) {
            return Container(
              color: Colors.black,
              child: Center(
                child: widget.child,
              ),
            );
          }

          return isLandscape ? _buildLandscapeLayout(provider) : _buildPortraitLayout(provider);
        },
      ),
    );
  }

  Widget _buildPortraitLayout(StreamAudioProvider provider) => AnimatedBuilder(
        animation: _sheetController,
        builder: (context, _) {
          final double currentSize = _sheetController.isAttached ? _sheetController.size : _minChildSize;

          final double progress = (currentSize - _minChildSize) / (_maxChildSize - _minChildSize);

          final double mapOffset = -320 * progress;

          /// Calculate current sheet height in pixels
          final screenHeight = MediaQuery.of(context).size.height;
          final currentHeightPx = currentSize * screenHeight;

          if (currentSize >= _maxChildSize - 0.01) {
            /// Small tolerance for floating point
            _isPanelFullyOpened = true;
          }

          /// Check for 150px threshold (only trigger once during opening)
          if (_isPanelFullyOpened &&
              currentHeightPx <= 150 &&
              !_hasTriggeredHeightThreshold &&
              currentSize > _minChildSize &&
              currentSize < _maxChildSize &&
              _autoCloseTimer != null &&
              _autoCloseTimer!.isActive) {
            _hasTriggeredHeightThreshold = true;

            WidgetsBinding.instance.addPostFrameCallback((_) {
              /// Cancel any existing timer since we're closing early
              _autoCloseTimer?.cancel();

              /// Directly close the panel instead of toggling
              if (_sheetController.isAttached) {
                _sheetController.animateTo(
                  _minChildSize,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            });
          }

          /// Reset threshold flag when panel is fully closed
          if (currentSize == _minChildSize) {
            _hasTriggeredHeightThreshold = false;
            _isPanelFullyOpened = false;
          }

          return Stack(
            children: [
              /// Passed [child] widget, can be anything it pushed from the bottom sheet when it's opened
              _buildChild(mapOffset, currentSize, false),

              /// Player controls widget, it's only visible when the panel is fully opened and there is a program selected
              _buildFloatingControls(provider, currentSize, false),

              /// Details Radio Controls Sheet (can be dragged to close)
              _buildDetailsControlsSheet(provider),

              /// Removal zone widget, it's only visible when the panel is fully opened and there is a program selected
              _buildRemovalZone(),
            ],
          );
        },
      );

  Widget _buildLandscapeLayout(StreamAudioProvider provider) {
    final screenWidth = MediaQuery.of(context).size.width;
    final sheetWidthPx = screenWidth * _landscapeSheetWidth;
    final childOffset = -sheetWidthPx;

    return Stack(
      children: [
        /// Passed [child] widget, pushed to left when sheet opens
        AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
          transform: Matrix4.translationValues(childOffset, 0, 0),
          child: widget.child,
        ),

        /// Player controls widget
        if (_landscapeSheetWidth == 0 && provider.selectedChannel != null)
          Center(
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
          ),

        /// Side sheet from right
        AnimatedPositioned(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
          right: _landscapeSheetWidth == 0 ? -screenWidth * _landscapeMaxWidth : 0,
          top: 0,
          bottom: 0,
          width: screenWidth * _landscapeMaxWidth,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.black,
              border: Border(left: BorderSide(color: Colors.white24, width: 1)),
            ),
            child: Expanded(
              child: _buildLandscapeSheetContent(provider),
            ),
          ),
        ),

        /// Removal zone widget
        _buildRemovalZone(),
      ],
    );
  }

  Widget _buildChild(double mapOffset, double currentSize, bool isLandscape) => Transform.translate(
        offset: Offset(0, mapOffset),
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(currentSize == _minChildSize ? 0 : 32),
            ),
          ),
          child: widget.child,
        ),
      );

  Widget _buildFloatingControls(StreamAudioProvider provider, double currentSize, bool isLandscape) {
    if (currentSize != _minChildSize || provider.selectedChannel == null) {
      return const SizedBox.shrink();
    }
    return Center(
      child: DraggableFloatingPlayerControls(
        onTap: togglePanel,
        onChange: ({required isHolding, required mustRemove}) {
          if (mounted) {
            setState(() => _showRemovalZone = isHolding);
            if (mustRemove) {
              // Only exit the player, don't reset immediately
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
                  _autoCloseTimer = Timer(const Duration(seconds: 80), () {
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

  Widget _buildDetailsControlsSheet(StreamAudioProvider provider) => DraggableScrollableSheet(
        controller: _sheetController,
        initialChildSize: _minChildSize,
        minChildSize: _minChildSize,
        maxChildSize: _maxChildSize,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(color: Colors.black),
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
                      color: Colors.red.withValues(alpha: 0.1),
                      border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Audio Error: ${provider.errorMessage ?? "Unknown error"}',
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
                    _autoCloseTimer = Timer(const Duration(seconds: 80), () {
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
      );

  Widget _buildRemovalZone() => Positioned(
        top: 0,
        right: 0,
        left: 0,
        child: AnimatedOpacity(
          opacity: _showRemovalZone ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: IgnorePointer(
            ignoring: !_showRemovalZone,
            child: Container(
              height: 160,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: const Alignment(0.50, -0.00),
                  end: const Alignment(0.50, 1.00),
                  colors: [Colors.black.withValues(alpha: 0.20), Colors.black.withValues(alpha: 0)],
                ),
              ),
              child: Center(
                child: Container(
                  width: 226,
                  height: 40,
                  padding: const EdgeInsets.only(top: 8, left: 8, right: 16, bottom: 8),
                  decoration: ShapeDecoration(
                    color: Colors.black.withValues(alpha: 0.65),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white.withValues(alpha: 0.20)),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    shadows: const [BoxShadow(color: Color(0x19000000), blurRadius: 24, offset: Offset(0, 8))],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.close, color: Colors.white.withValues(alpha: 0.80), size: 22),
                      const Text(
                        'Drag here to exit audio player',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: 'Golos Text',
                          fontWeight: FontWeight.w500,
                          height: 1.33,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
