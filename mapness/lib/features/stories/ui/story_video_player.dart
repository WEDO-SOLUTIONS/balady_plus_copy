import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:mapness/features/stories/models/story_frame_theme_data.dart';
import 'package:mapness/features/stories/ui/fullscreen_strory_error.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:video_player/video_player.dart';

part 'models/video_story_state.dart';

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
  final ValueNotifier<bool> _showVolumeIcon = ValueNotifier<bool>(false);
  Timer? _volumeIconTimer;

  /// Notifier to track the current state of the video player
  final ValueNotifier<VideoStoryState> _currentState = ValueNotifier<VideoStoryState>(VideoStoryLoading());

  /// Notifier to track the progress of the video player
  final ValueNotifier<(double, double)> _progressNotifier = ValueNotifier<(double, double)>((0, 0));

  @override
  void initState() {
    super.initState();
    _loadVideo();
  }

  Future<void> _loadVideo() async {
    _showVolumeIcon.value = false;
    _volumeIconTimer?.cancel();
    _progressNotifier.value = (0, 0);
    _currentState.value = VideoStoryLoading();
    final url = widget.videoUrls[_currentIndex];

    final manager = DefaultCacheManager();

    try {
      final cachedFile = await manager.getFileFromCache(url);

      var file = cachedFile?.file;

      if (cachedFile == null) {
        final downloadedFile = await manager.getSingleFile(url);
        file = await manager.putFile(url, await downloadedFile.readAsBytes(),
            maxAge: const Duration(days: 7), fileExtension: 'mp4');
      }

      if (file == null) {
        throw Exception('File not found');
      }

      if (_controller != null) {
        await _controller!.dispose();
      }

      _controller = VideoPlayerController.file(file);
      await _controller?.initialize();
      _currentState.value = VideoStoryReady();
      await _controller?.play();
      await _controller?.setVolume(_isMuted ? 0 : 1);
      _controller?.addListener(_onVideoEnd);
    } catch (e) {
      _currentState.value = VideoStoryError(e.toString(), VidoErrorType.network);

      return;
    }
  }

  void _onVideoEnd() {
    _progressNotifier.value = (
      _controller?.value.position.inMilliseconds.toDouble() ?? 0,
      _controller?.value.duration.inMilliseconds.toDouble() ?? 0
    );

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

    /// Check if the tap is on the left or right side of the screen
    final isNext = context.isLTR ? dx > width * 0.75 : dx < width * 0.25;
    final isPrev = context.isLTR ? dx < width * 0.25 : dx > width * 0.75;

    if (isPrev) {
      _previousVideo();
    } else if (isNext) {
      _nextVideo();

      /// Mute/unmute the video click
    } else {
      setState(() {
        _isMuted = !_isMuted;
        _controller?.setVolume(_isMuted ? 0 : 1);
      });
      _showVolumeIcon.value = true;
      _volumeIconTimer?.cancel();
      _volumeIconTimer = Timer(const Duration(seconds: 3), () {
        _showVolumeIcon.value = false;
      });
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_onVideoEnd);
    _controller?.dispose();
    _volumeIconTimer?.cancel();
    _showVolumeIcon.dispose();
    _currentState.dispose();
    _progressNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<VideoStoryState>(
      valueListenable: _currentState,
      builder: (context, state, _) {
        final isLoading = state is VideoStoryLoading;

        if (state is VideoStoryError) {
          return FullscreenStroryError(
            errorTitle: context.l10n.somethingWentWrong,
            errorLabel: context.l10n.saudiPassSomethingWentWrongHint,
            onRetry: () {
              _loadVideo();
            },
            onClose: () {
              context.router.popForced();
            },
          );
        }

        final noSoundIc = context.isLTR ? GeneralIcons.noSoundLTR : GeneralIcons.noSoundRTL;
        final soundIc = context.isLTR ? GeneralIcons.soundLTR : GeneralIcons.soundRTL;

        return LayoutBuilder(
            builder: (context, contraints) => SizedBox.fromSize(
                  size: contraints.biggest,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.paddingOf(context).top,
                      bottom: MediaQuery.paddingOf(context).bottom,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(RadiusBorder.xl),
                      child: Material(
                          color: Colors.transparent,
                          child: GestureDetector(
                            onTapDown: (details) => _onTapDown(details, context),
                            child: Stack(
                              children: [
                                if (isLoading)
                                  const Center(
                                    child: Loading(
                                      size: LoaderSize.large,
                                    ),
                                  )
                                else if (_controller != null && _controller!.value.isInitialized)
                                  Center(child: VideoPlayer(_controller!)),
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  right: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x, vertical: Spacing.$4x),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: ValueListenableBuilder<(double, double)>(
                                              valueListenable: _progressNotifier,

                                              /// progressData $1 = position, $2 = duration
                                              builder: (context, progressData, _) => Row(
                                                    children: List.generate(widget.videoUrls.length, (index) {
                                                      double progress = 0;
                                                      if (index < _currentIndex) {
                                                        progress = 1;
                                                      } else if (index == _currentIndex &&
                                                          _controller != null &&
                                                          _controller!.value.isInitialized) {
                                                        final position = progressData.$1;
                                                        final duration = progressData.$2;

                                                        progress =
                                                            duration > 0 ? (position / duration).clamp(0.0, 1.0) : 0.0;
                                                      }
                                                      return Expanded(
                                                        child: Container(
                                                          margin: const EdgeInsets.symmetric(horizontal: 2),
                                                          height: 3,
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(RadiusBorder.xl),
                                                            child: LinearProgressIndicator(
                                                              value: progress,
                                                              backgroundColor:
                                                                  context.colorsV3.staticWhite.withOpacity(0.3),
                                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                                  context.colorsV3.staticWhite),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                                  )),
                                        ),
                                        const SizedBox(width: Spacing.$3x),
                                        AppButton.close(
                                          onTap: () {
                                            context.router.popForced();
                                          },
                                          innerPadding: const EdgeInsets.all(Spacing.$2x),
                                          padding: EdgeInsets.zero,
                                          buttonColorScheme: ButtonColorScheme.onColor,
                                          color: StoryCloseButtonThemeData.baseTheme().backgroundColor,
                                          iconColor: StoryCloseButtonThemeData.baseTheme().iconColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  top: 0,
                                  child: ValueListenableBuilder<bool>(
                                    valueListenable: _showVolumeIcon,
                                    builder: (context, show, _) => !show
                                        ? const SizedBox.shrink()
                                        : Align(
                                            child: Container(
                                              width: 80,
                                              height: 80,
                                              decoration: BoxDecoration(
                                                color: context.colorsV3.staticBlack.withOpacity(0.5),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  _isMuted ? noSoundIc : soundIc,
                                                  color: context.colorsV3.staticWhite,
                                                  size: 24,
                                                ),
                                              ),
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                  ),
                ));
      });
}
