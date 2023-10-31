import 'package:flutter/material.dart';
import 'package:mapness/features/common/image/loading_image/loading_image.dart';
import 'package:mapness/features/stories/domain/frame/story_frame_action.dart';
import 'package:mapness/features/stories/domain/frame/story_frame_data.dart';
import 'package:mapness/features/stories/presentation/frame/frame_action_button.dart';
import 'package:mapness/features/stories/presentation/frame/frame_progress_indicator.dart';
import 'package:mapness/features/stories/presentation/frame/story_frame_content.dart';

class StoryFrameWidget extends StatefulWidget {
  final StoryFrameData frame;
  final int frameIndex;
  final int frameLength;
  final int duration;

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
  });

  @override
  State<StoryFrameWidget> createState() => _StoryFrameWidgetState();
}

class _StoryFrameWidgetState extends State<StoryFrameWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progress;
  late final StoryFrameData _frame;

  DateTime _lastTap = DateTime.now();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
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
          break;
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

  onTapDown(_) {
    pauseProgress();
    _lastTap = DateTime.now();
  }

  onTapUp(Function action) {
    if (DateTime.now().difference(_lastTap) <
        const Duration(milliseconds: 150)) {
      action();
    } else {
      resumeProgress();
      _lastTap = DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Stack(
          children: [
            Container(color: Colors.black),
            Positioned.fill(
              child: LoadingImage(
                onImageReady: imageLoaded,
                imageUrl: widget.frame.imageUrl,
                fit: BoxFit.cover,
                loadingWidget: Container(
                  color: const Color(0xFFE9E9E9),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            if (!isLoading)
              SafeArea(
                child: Stack(
                  children: [
                    /// story content
                    Padding(
                      padding: const EdgeInsets.only(top: 81),
                      child: StoryFrameContent(frame: widget.frame),
                    ),

                    /// left right click handlers
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
                    if (widget.frame.action != null &&
                        widget.onActionPressed != null)
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
              )
          ],
        ),
      ),
    );
  }
}
