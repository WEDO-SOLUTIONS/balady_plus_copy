import 'dart:math' as math;

import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/poi_card/enums/poi_card_bottom_sheet_state.dart';
import 'package:mapness/features/stories/models/story_frame_theme_data.dart';
import 'package:mapness/features/stories/ui/frame/story_frame_widget.dart';
import 'package:mapness/shared/utils/text_utils/arabic_numerals.dart';

class PoiPhotosStories extends StatefulWidget {
  final Widget Function(ScrollController, ScrollPhysics?) builder;
  final int itemCount;
  final PoiCardBottomSheetState? state;
  final double? interpolation;

  const PoiPhotosStories({required this.builder, required this.itemCount, this.state, this.interpolation, super.key});

  @override
  State<PoiPhotosStories> createState() => _PoiPhotosStoriesState();
}

class _PoiPhotosStoriesState extends State<PoiPhotosStories> with TickerProviderStateMixin, WidgetsBindingObserver {
  int currentIndex = 0;
  double screenWidth = 1;
  int itemCount = 0;
  double? opacity;

  double opacityOfNextButton = 0;
  double opacityOfPreviousButton = 0;
  late final AnimationController _controller;
  late final Animation<double> _progress;
  late final ScrollController _scrollController;

  void _onProgressListener() {
    if (_progress.status == AnimationStatus.completed) {
      _onNext();
    }
  }

  @override
  void initState() {
    super.initState();
    itemCount = math.min(widget.itemCount, 10);
    _scrollController = ScrollController();
    _controller = AnimationController(duration: const Duration(seconds: 5), vsync: this);
    _progress = Tween<double>(begin: 0, end: 1).animate(_controller);
    _progress.addListener(_onProgressListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      screenWidth = MediaQuery.of(context).size.width;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (!_controller.isAnimating) {
        _controller.forward();
      }
      return;
    }
    if (_controller.isAnimating) {
      _controller.stop();
    }
  }

  void _onNext() {
    _controller.reset();

    setState(() {
      currentIndex = (currentIndex + 1) % itemCount;
      _scrollController.animateTo(
        currentIndex * screenWidth,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeInOutCirc,
      );
      _controller.forward();
    });
  }

  void _onPrevious() {
    _progress.removeListener(_onProgressListener);
    _controller.stop();

    setState(() {
      currentIndex = (currentIndex - 1) % itemCount;
      _scrollController.animateTo(
        currentIndex * screenWidth,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeInOutCirc,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant PoiPhotosStories oldWidget) {
    super.didUpdateWidget(oldWidget);
    opacity = _interpolation(initialValue: 0, finalValue: 1, state: widget.state, interpolation: widget.interpolation);

    setState(() {
      if (widget.interpolation != null &&
          widget.interpolation! > 0.1 &&
          widget.state == PoiCardBottomSheetState.halfOpen) {
        _scrollController.jumpTo(0);
      }
      if (widget.state == PoiCardBottomSheetState.open) {
        _controller.forward();
      } else {
        _controller.reset();
      }
    });
  }

  @override
  // ignore: prefer_expression_function_bodies
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        widget.builder(
          _scrollController,
          widget.state == PoiCardBottomSheetState.open ? const NeverScrollableScrollPhysics() : null,
        ),
        IgnorePointer(
          ignoring: widget.state == PoiCardBottomSheetState.halfOpen,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: GestureDetector(
                  onTapDown: (details) {
                    setState(() {
                      opacityOfPreviousButton = 1;
                    });
                  },
                  onTapUp: (details) {
                    setState(() {
                      opacityOfPreviousButton = 0;
                    });
                  },
                  onTap: _onPrevious,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.easeInOut,
                    opacity: opacityOfPreviousButton,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            context.colors.neutralDefault.withOpacity(0.9),
                            context.colors.neutralDefault.withOpacity(0.3),
                            context.colors.neutralDefault.withOpacity(0),
                          ],
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Center tap area - next photo
              Flexible(
                flex: 2,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _onNext,
                  child: const SizedBox.expand(),
                ),
              ),
              // Right tap area - next photo
              Flexible(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapDown: (details) {
                    setState(() {
                      opacityOfNextButton = 1;
                    });
                  },
                  onTapUp: (details) {
                    setState(() {
                      opacityOfNextButton = 0;
                    });
                  },
                  onTap: _onNext,
                  child: const SizedBox.expand(),
                ),
              ),
            ],
          ),
        ),
        Opacity(
          opacity: opacity ?? 1,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // Gradient overlay below progress bar (107px height) - only in open/expanded states
              if (widget.state == PoiCardBottomSheetState.open || widget.state == PoiCardBottomSheetState.expanded)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: IgnorePointer(
                    child: Opacity(
                      opacity: 0.2,
                      child: Container(
                        height: 107,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.black.withOpacity(0), Colors.black.withOpacity(0.8)],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              Padding(
                // $4x - is padding for hidden part of photo and $4x - is padding from top of header
                // You can find first padding as [topHeaderOffset]
                padding: const EdgeInsetsDirectional.only(bottom: Spacing.$8x, start: Spacing.$3x, end: Spacing.$3x),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          context.digits(widget.itemCount.toString()),
                          style: context.textStyles.captionLargeSemiBold.copyWith(color: context.colors.staticWhite),
                        ),
                        const SizedBox(width: Spacing.$1x),
                        Icon(General16Icons.photoSolid, size: 16, color: context.colors.staticWhite),
                      ],
                    ),
                    const SizedBox(height: Spacing.$2x),
                    FrameProgressIndicator(
                      frameIndex: currentIndex,
                      framesLength: itemCount,
                      animation: _progress,
                      trackTheme: StoryTrackThemeData(
                        backgroundColor: const Color(0xFFFFFFFF).withOpacity(0.3),
                        color: const Color(0xFFFFFFFF),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  double _interpolation({
    required double initialValue,
    required double finalValue,
    double? expandedValue,
    PoiCardBottomSheetState? state,
    double? interpolation,
  }) {
    if (state == null || interpolation == null) {
      return finalValue;
    }

    if (state == PoiCardBottomSheetState.hidden) {
      return initialValue;
    }

    if (state == PoiCardBottomSheetState.open || state == PoiCardBottomSheetState.expanded) {
      return expandedValue ?? finalValue;
    }

    return (finalValue - initialValue) * interpolation + initialValue;
  }
}
