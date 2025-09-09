import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/stream_audio_prov.dart';

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
    _streamAudioProvider = ChangeNotifierProvider<StreamAudioProvider>(
        (ref) => StreamAudioProvider());
    super.initState();
  }

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

                Positioned(
                  top: 40,
                  right: 49,
                  child: ElevatedButton(
                    onPressed: togglePanel,
                    child: const Text('open'),
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
