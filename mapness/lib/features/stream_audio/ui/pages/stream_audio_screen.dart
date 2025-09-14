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
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(streamAudioProvider).getLiveNow());
  }

  final DraggableScrollableController _sheetController = DraggableScrollableController();

  final double _minChildSize = 0.0;
  final double _maxChildSize = 0.34;
  bool _showRemovalZone = false;

  /// Timer for 8-second auto-close
  Timer? _autoCloseTimer;

  /// Track if we've already triggered the 150px threshold
  bool _hasTriggeredHeightThreshold = false;
  bool _isPanelFullyOpened = false;

  @override
  void dispose() {
    _autoCloseTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(streamAudioProvider);
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedBuilder(
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
              Transform.translate(
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
              ),

              if (currentSize == _minChildSize && provider.isPlaying)
                Center(
                  child: DraggableFloatingPlayerControls(
                    onTap: togglePanel,
                    onChange: (isHolding, mustRemove) {
                      setState(() => _showRemovalZone = isHolding);
                      if (mustRemove) {
                        ref.read(streamAudioProvider.notifier).exitPlayer();
                        setState(() => _showRemovalZone = false);
                      }
                    },
                  ),
                ),

              /// Panel
              DraggableScrollableSheet(
                controller: _sheetController,
                initialChildSize: _minChildSize,
                minChildSize: _minChildSize,
                maxChildSize: _maxChildSize,
                builder: (context, scrollController) => Container(
                  decoration: const BoxDecoration(color: Colors.black),
                  child: GestureDetector(
                    onTap: (){
                      print("shady ammar tap");
                    },
                    child: SingleChildScrollView(
                      controller: scrollController,
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
                          const SizedBox(height: 16),
                          const PlayingAudioTile(),
                          const SizedBox(height: 32),
                          MediaCatalogList(needReset: () {
                            //reset the timer
                            _autoCloseTimer?.cancel();
                            _autoCloseTimer = Timer(const Duration(seconds: 8), () {
                              if (_sheetController.isAttached && _sheetController.size > _minChildSize) {
                                _sheetController.animateTo(
                                  _minChildSize,
                                  duration: const Duration(milliseconds: 800),
                                  curve: Curves.easeInOut,
                                );
                              }
                            });
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
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
                          colors: [Colors.black.withOpacity(0.20), Colors.black.withOpacity(0)],
                        ),
                      ),
                      child: Center(
                        child: Container(
                          width: 226,
                          height: 40,
                          padding: const EdgeInsets.only(top: 8, left: 8, right: 16, bottom: 8),
                          decoration: ShapeDecoration(
                            color: Colors.black.withOpacity(0.65),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.white.withOpacity(0.20)),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            shadows: const [BoxShadow(color: Color(0x19000000), blurRadius: 24, offset: Offset(0, 8))],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.close, color: Colors.white.withOpacity(0.80), size: 22),
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
              )
            ],
          );
        },
      ),
    );
  }

  /// Toggles the panel between open and closed states
  void togglePanel() {
    if (_sheetController.isAttached) {
      final currentSize = _sheetController.size;
      final targetSize = currentSize > (_minChildSize + _maxChildSize) / 2 ? _minChildSize : _maxChildSize;

      /// Cancel any existing timer
      _autoCloseTimer?.cancel();

      /// If opening the panel, start the 8-second timer
      if (targetSize == _maxChildSize) {
        setState(() => _showRemovalZone = false);
        _autoCloseTimer = Timer(const Duration(seconds: 8), () {
          if (_sheetController.isAttached && _sheetController.size > _minChildSize) {
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
