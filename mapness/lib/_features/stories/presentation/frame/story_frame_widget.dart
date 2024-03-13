import 'package:flutter/material.dart';
import 'package:mapness/_features/common/image/loading_image/loading_image.dart';
import 'package:mapness/_features/stories/domain/frame/story_frame_action.dart';
import 'package:mapness/_features/stories/domain/frame/story_frame_data.dart';
import 'package:mapness/_features/stories/presentation/frame/frame_action_button.dart';
import 'package:mapness/_features/stories/presentation/frame/frame_progress_indicator.dart';
import 'package:mapness/_features/stories/presentation/frame/story_frame_content.dart';
import 'package:mapness/_features/stories/presentation/frame/story_frame_controller.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/loading/loading_circular.dart';

class StoryFrameWidget extends StatefulWidget {
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
  final StoryFrameData frame;
  final int frameIndex;
  final int frameLength;
  final int duration;
  final StoryFrameController? controller;

  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final VoidCallback onClose;

  final void Function(StoryFrameAction action)? onActionPressed;

  @override
  State<StoryFrameWidget> createState() => _StoryFrameWidgetState();
}

class _StoryFrameWidgetState extends State<StoryFrameWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progress;
  late final StoryFrameData _frame;

  DateTime _lastTap = DateTime.now();

  late bool isLoading = _frame.isAssetImage == false;

  @override
  void initState() {
    super.initState();
    widget.controller?.nextPage = _onNext;
    widget.controller?.prevPage = _onPrevious;
    _controller = AnimationController(
      duration: Duration(seconds: widget.duration),
      vsync: this,
    );

    _progress = Tween<double>(begin: 0, end: 1).animate(_controller);
    _frame = widget.frame;

    _progress.addListener(() {
      switch (_progress.status) {
        case AnimationStatus.completed:
          widget.onNext();

        // ignore: no_default_cases
        default:
          break;
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isLoading) {
      pauseProgress();
    }
    if (_frame != widget.frame) {
      _frame = widget.frame;
      resetProgress();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void pauseProgress() {
    _controller.stop();
  }

  void resumeProgress() {
    _controller.forward();
  }

  void resetProgress() {
    _controller.reset();
  }

  void imageLoaded() {
    setState(() {
      isLoading = false;
      _controller.forward();
    });
  }

  void _onNext() {
    resetProgress();
    widget.onNext();
  }

  void _onPrevious() {
    resetProgress();
    widget.onPrevious();
  }

  void onTapDown(_) {
    pauseProgress();
    _lastTap = DateTime.now();
  }

  void onTapUp(VoidCallback action) {
    if (DateTime.now().difference(_lastTap) <
        const Duration(milliseconds: 150)) {
      action();
    } else {
      resumeProgress();
      _lastTap = DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) => Material(
        child: Directionality(
          textDirection: Directionality.of(context),
          child: Stack(
            children: [
              Container(color: Colors.black),
              Positioned.fill(
                child: LoadingImage(
                  isAssetImg: widget.frame.isAssetImage,
                  onImageReady: imageLoaded,
                  imageUrl: widget.frame.imageUrl,
                  fit: BoxFit.cover,
                  loadingWidget: Container(
                    color: context.color.surface_base_primary,
                    child: const Center(
                      child: LoadingCircular(),
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Stack(
                  children: [
                    /// story content
                    if (!isLoading)
                      Padding(
                        padding: const EdgeInsets.only(top: 81),
                        child: StoryFrameContent(frame: widget.frame),
                      ),

                    /// left right click handlers
                    if (!isLoading)
                      Row(
                        children: [
                          Expanded(
                            flex: 30,
                            child: GestureDetector(
                              onTapDown: onTapDown,
                              onTapUp: (_) => onTapUp(_onPrevious),
                            ),
                          ),
                          Expanded(
                            flex: 70,
                            child: GestureDetector(
                              onTapDown: onTapDown,
                              onTapUp: (_) => onTapUp(_onNext),
                            ),
                          ),
                        ],
                      ),

                    /// progress indicator and exit button
                    AnimatedBuilder(
                      animation: _progress,
                      builder: (context, old) => FrameProgressIndicator(
                        onClose: widget.onClose,
                        progress: _progress.value,
                        frameIndex: widget.frameIndex,
                        framesLength: widget.frameLength,
                      ),
                    ),

                    /// action button
                    if (!isLoading &&
                        widget.frame.action != null &&
                        widget.onActionPressed != null &&
                        widget.frame.action!.deeplinkUrl.isNotEmpty)
                      Positioned(
                        bottom: 24,
                        left: 16,
                        right: 16,
                        child: FrameActionButton(
                          title: widget.frame.action!.title,
                          onPressed: () =>
                              widget.onActionPressed!(widget.frame.action!),
                          textStyle: widget.frame.action?.textStyle,
                          backgroundColor: widget.frame.action?.backgroundColor,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
