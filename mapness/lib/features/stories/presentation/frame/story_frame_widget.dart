import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/_features/common/image/loading_image/loading_image.dart';
import 'package:mapness/features/stories/domain/frame/story_frame_action.dart';
import 'package:mapness/features/stories/domain/frame/story_frame_data.dart';
import 'package:mapness/features/stories/helper/locale_helper.dart';
import 'package:mapness/features/stories/presentation/frame/frame_progress_indicator.dart';
import 'package:mapness/features/stories/presentation/frame/story_frame_content.dart';
import 'package:mapness/features/stories/presentation/frame/story_frame_controller.dart';

class StoryFrameWidget extends StatefulWidget {
  final StoryFrameData frame;
  final int frameIndex;
  final int frameLength;
  final int duration;

  final StoryFrameController? controller;

  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final VoidCallback onClose;
  final void Function(StoryFrameAction action)? onActionPressed;

  const StoryFrameWidget({
    required this.duration,
    required this.frame,
    required this.frameIndex,
    required this.frameLength,
    required this.onClose,
    required this.onNext,
    required this.onPrevious,
    super.key,
    this.onActionPressed,
    this.controller,
  });

  @override
  State<StoryFrameWidget> createState() => _StoryFrameWidgetState();
}

class _StoryFrameWidgetState extends State<StoryFrameWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progress;
  late final StoryFrameData _frame;

  late DateTime _lastTap = DateTime.now();

  late bool _isLoading = _frame.isAssetImage == false;

  String _keyToLocale(String key) => switch (key) {
        'next' => StoryLocalization.of(context)?.l10n.next ?? '',
        'try_now' => StoryLocalization.of(context)?.l10n.tryNow ?? '',
        _ => ''
      };

  String get _actionTitleOrFailback {
    final action = widget.frame.action;
    return switch (action) {
      VerbatimStoryFrameAction() => action.title,
      LocaleKeyFrameAction() => _keyToLocale(action.titleLocaleKey),
      null => '',
    };
  }

  void _onProgressListener() {
    switch (_progress.status) {
      case AnimationStatus.completed:
        _onNext();
      // ignore: no_default_cases
      default:
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    widget.controller?.pause = _pauseProgress;
    widget.controller?.play = _resumeProgress;
    widget.controller?.nextPage = _onNext;
    widget.controller?.prevPage = _onPrevious;

    _controller = AnimationController(
      duration: Duration(seconds: widget.duration),
      vsync: this,
    );

    _progress = Tween<double>(begin: 0, end: 1).animate(_controller);
    _frame = widget.frame;

    _progress.addListener(_onProgressListener);

    if (_frame.isAssetImage == true) {
      _imageLoaded();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _progress.removeListener(_onProgressListener);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isLoading) {
      _pauseProgress();
    }
    if (_frame != widget.frame) {
      _frame = widget.frame;
      _resetProgress();
    }
  }

  void _pauseProgress() {
    _controller.stop();
  }

  void _resumeProgress() {
    _controller.forward();
  }

  void _resetProgress() {
    _controller.reset();
  }

  void _imageLoaded() {
    setState(() {
      _isLoading = false;
      _controller.forward();
    });
  }

  void _onNext() {
    _progress.removeListener(_onProgressListener);
    _controller.stop();

    widget.onNext();
  }

  void _onPrevious() {
    _progress.removeListener(_onProgressListener);
    _controller.stop();

    widget.onPrevious();
  }

  void _onTapDown(_) {
    _pauseProgress();
    _lastTap = DateTime.now();
  }

  void _onTapUp(VoidCallback action) {
    if (DateTime.now().difference(_lastTap) < const Duration(milliseconds: 150)) {
      action();
    } else {
      _resumeProgress();
      _lastTap = DateTime.now();
    }
  }

  void _onActionPressed() {
    final action = widget.frame.action;
    if (action != null) {
      widget.onActionPressed?.call(action);
    }
  }

  @override
  Widget build(BuildContext context) => Material(
        color: context.color.surfaceBaseInversePrimary,
        child: SafeArea(
          left: false,
          right: false,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Directionality(
              textDirection: Directionality.of(context),
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: context.color.surfaceBaseInversePrimary,
                  ),
                  Positioned.fill(
                    child: LoadingImage(
                      isAssetImg: widget.frame.isAssetImage,
                      onImageReady: _imageLoaded,
                      imageUrl: widget.frame.imageUrl,
                      fit: BoxFit.cover,
                      loadingWidget: Container(
                        color: context.color.textAndIconsBaseInverseTertiary,
                        child: Center(
                          child: Loading.large(
                            style: Brightness.light,
                            orientation: Axis.vertical,
                            title: StoryLocalization.of(context)?.l10n.loading,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    child: Container(
                      height: MediaQuery.of(context).size.height / 2,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          stops: const [0, 0.8, 1],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xff000000).withOpacity(0.4),
                            const Color(0xff000000).withOpacity(0.06),
                            const Color(0xff000000).withOpacity(0)
                          ],
                        ),
                      ),
                    ),
                  ),

                  /// story content
                  if (!_isLoading)
                    Positioned(
                      left: 16,
                      right: 16,
                      top: 100,
                      bottom: 64,
                      child: Align(
                        alignment: AlignmentDirectional.topStart,
                        child: StoryFrameContent(frame: widget.frame),
                      ),
                    ),

                  /// left right click handlers
                  if (!_isLoading)
                    Row(
                      children: [
                        Expanded(
                          flex: 30,
                          child: GestureDetector(
                            onTapDown: _onTapDown,
                            onTapUp: (_) => _onTapUp(_onPrevious),
                          ),
                        ),
                        Expanded(
                          flex: 70,
                          child: GestureDetector(
                            onTapDown: _onTapDown,
                            onTapUp: (_) => _onTapUp(_onNext),
                          ),
                        ),
                      ],
                    ),

                  /// progress indicator and exit button
                  FrameProgressIndicator(
                    onClose: widget.onClose,
                    frameIndex: widget.frameIndex,
                    framesLength: widget.frameLength,
                    animation: _progress,
                  ),

                  // action button
                  if (widget.frame.action != null &&
                      widget.onActionPressed != null &&
                      widget.frame.action!.deeplinkUrl.isNotEmpty)
                    Positioned(
                      bottom: 12,
                      left: 16,
                      right: 16,
                      child: AppButton(
                        color: widget.frame.action?.backgroundColor,
                        textColor: widget.frame.action?.textStyle?.color,
                        buttonColorScheme: widget.frame.action?.backgroundColor == null ||
                                widget.frame.action?.textStyle?.color == null
                            ? ButtonColorScheme.primary
                            : ButtonColorScheme.onColor,
                        primaryLabel: _actionTitleOrFailback,
                        onTap: _onActionPressed,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
}
