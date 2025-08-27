import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:video_player/video_player.dart';

class StoryVideoPlayer extends StatefulWidget {
  final List<String> videoUrls;
  final VoidCallback? onNextStory;
  final VoidCallback? onPreviousStory;

  const StoryVideoPlayer({
    required this.videoUrls,
    super.key,
    this.onNextStory,
    this.onPreviousStory,
  });

  @override
  State<StoryVideoPlayer> createState() => _StoryVideoPlayerState();
}

class _StoryVideoPlayerState extends State<StoryVideoPlayer> {
  int _currentIndex = 0;
  VideoPlayerController? _controller;
  bool _isMuted = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVideo();
  }

  Future<void> _loadVideo() async {
    setState(() => _isLoading = true);
    final url = widget.videoUrls[_currentIndex];

    final manager = DefaultCacheManager();

    final cachedFile = await manager.getFileFromCache(url);

    var file = cachedFile?.file;

    if (cachedFile == null) {
      final downloadedFile = await manager.getSingleFile(url);
      file = await manager.putFile(url, await downloadedFile.readAsBytes(),
          maxAge: const Duration(days: 7), fileExtension: 'mp4');
    }

    if (file == null) {
      setState(() => _isLoading = true);
      return;
    }

    if (_controller != null) {
      await _controller!.dispose();
    }
    _controller = VideoPlayerController.file(file);
    await _controller?.initialize();
    setState(() => _isLoading = false);
    await _controller?.play();
    await _controller?.setVolume(_isMuted ? 0 : 1);
    _controller?.addListener(_onVideoEnd);
  }

  void _onVideoEnd() {
    if (_controller?.value.position == _controller?.value.duration) {
      _nextVideo();
    }
  }

  void _previousVideo() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
      _loadVideo();
    } else {
      widget.onPreviousStory?.call();
    }
  }

  void _nextVideo() {
    if (_currentIndex < widget.videoUrls.length - 1) {
      setState(() {
        _currentIndex++;
      });
      _loadVideo();
    } else {
      widget.onNextStory?.call();
    }
  }

  void _onTapDown(TapDownDetails details, BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final dx = details.globalPosition.dx;
    if (dx < width * 0.25) {
      _previousVideo();
    } else if (dx > width * 0.75) {
      _nextVideo();
    } else {
      setState(() {
        _isMuted = !_isMuted;
        _controller?.setVolume(_isMuted ? 0 : 1);
      });
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_onVideoEnd);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
      builder: (context, contraints) => SizedBox.fromSize(
            size: contraints.biggest,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.paddingOf(context).bottom,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Material(
                    child: GestureDetector(
                  onTapDown: (details) => _onTapDown(details, context),
                  child: Stack(
                    children: [
                      if (_isLoading)
                        const Center(child: CircularProgressIndicator())
                      else if (_controller != null && _controller!.value.isInitialized)
                        Center(child: VideoPlayer(_controller!)),
                      // Topbar with progress indicators and close button
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Progress indicators for each video
                              Expanded(
                                child: Row(
                                  children: List.generate(widget.videoUrls.length, (index) {
                                    double progress = 0;
                                    if (index < _currentIndex) {
                                      progress = 1;
                                    } else if (index == _currentIndex &&
                                        _controller != null &&
                                        _controller!.value.isInitialized) {
                                      final duration = _controller!.value.duration.inMilliseconds;
                                      final position = _controller!.value.position.inMilliseconds;
                                      progress = duration > 0 ? (position / duration).clamp(0.0, 1.0) : 0.0;
                                    }
                                    return Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 2),
                                        height: 3,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: LinearProgressIndicator(
                                            value: progress,
                                            backgroundColor: Colors.white24,
                                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, color: Colors.white),
                                onPressed: () => Navigator.of(context).maybePop(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 24,
                        right: 24,
                        child: Icon(
                          _isMuted ? Icons.volume_off : Icons.volume_up,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                )),
              ),
            ),
          ));
}
