import 'package:auto_route/auto_route.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/advert_metrics/advert_metrics.dart';
import 'package:mapness/features/app_analytics/app_analytics.dart';
import 'package:mapness/features/stories/models/story_frame_action.dart';
import 'package:mapness/features/stories/models/story_frame_controller.dart';
import 'package:mapness/features/stories/models/story_frame_data.dart';
import 'package:mapness/features/balady_analytics/events/service_events.dart';
import 'package:mapness/features/stories/models/story_frame_theme_data.dart';
import 'package:mapness/features/stories/models/story_types.dart';
import 'package:mapness/features/stories/ui/story_args_provider.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/loading_image/loading_shimmer_image.dart';
import 'package:urbi_utils/urbi_utils.dart';
import 'package:url_launcher/url_launcher.dart';

part 'frame_progress_indicator.dart';

part 'story_frame_action_button.dart';

part 'story_frame_content.dart';

class StoryFrameWidget extends StatefulWidget {
  final StoryFrameData frame;
  final int frameIndex;
  final int frameLength;
  final int duration;
  final StoryFrameController? controller;
  final StoryTypes type;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final void Function(StoryFrameData)? onActionPressed;

  const StoryFrameWidget({
    required this.duration,
    required this.type,
    required this.frame,
    required this.frameIndex,
    required this.frameLength,
    required this.onNext,
    required this.onPrevious,
    this.onActionPressed,
    super.key,
    this.controller,
  });

  @override
  State<StoryFrameWidget> createState() => _StoryFrameWidgetState();
}

class _StoryFrameWidgetState extends State<StoryFrameWidget>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController _controller;
  late final Animation<double> _progress;
  late final StoryFrameData _frame;

  late final StoryFrameThemeData storyTheme = _frame.themeFromId(
    colorTheme: context.colorsV2,
    textTheme: context.textStyles,
  );
  late final StoryArgsProvider storyArgs = StoryArgsProvider.of(context);

  late DateTime _lastTap = DateTime.now();

  late bool _isLoading = _frame.isAssetImage == false;

  void _onProgressListener() {
    if (_progress.status == AnimationStatus.completed) {
      _onNext();
    }
  }

  @override
  void initState() {
    super.initState();
    _initController();
    if (_frame.isAssetImage == true) {
      _imageLoaded();
    }
    WidgetsBinding.instance.addObserver(this);
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

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    _controller.dispose();
    _progress.removeListener(_onProgressListener);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isLoading) {
      _controller.stop();
    }
    if (_frame != widget.frame) {
      _frame = widget.frame;
      _controller.reset();
    }
  }

  void _initController() {
    _controller = AnimationController(
      duration: Duration(seconds: widget.duration),
      vsync: this,
    );

    widget.controller?.pause = _controller.stop;
    widget.controller?.play = _controller.forward;

    widget.controller?.nextPage = _onNext;
    widget.controller?.prevPage = _onPrevious;

    _progress = Tween<double>(begin: 0, end: 1).animate(_controller);
    _progress.addListener(_onProgressListener);
    _frame = widget.frame;
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
    _controller.stop();
    _lastTap = DateTime.now();
  }

  void _onTapUp(VoidCallback action) {
    if (DateTime.now().difference(_lastTap) < const Duration(milliseconds: 150)) {
      action();
      return;
    }
    _controller.forward();

    _lastTap = DateTime.now();
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
            child: Stack(
              children: [
                if (widget.frame.imageUrl != null && widget.frame.fullscreenImage)
                  Positioned.fill(
                    child: _buildImage(
                      title: context.l10n.loading,
                    ),
                  ),
                if (storyTheme.gradientColor != null)
                  Align(
                    alignment: Alignment.topLeft,
                    child: SizedBox(
                      height: contraints.maxHeight / 2,
                      width: double.infinity,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            radius: 1,
                            center: Alignment.topLeft,
                            colors: [
                              storyTheme.gradientColor!,
                              const Color(0x00FFFFFF),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                const Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: kToolbarHeight + Spacing.$8x,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0x66000000),
                          Color(0x00000000),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildTopbar(context),
                      const SizedBox(
                        height: Spacing.$6x,
                      ),
                      SizedBox(
                        width: contraints.maxWidth,
                        child: StoryFrameContent(
                          frame: widget.frame,
                          storyTheme: storyTheme,
                        ),
                      ),
                      if (widget.frame.imageUrl != null && !widget.frame.fullscreenImage)
                        Expanded(
                          child: _buildImage(
                            title: context.l10n.loading,
                          ),
                        ),
                    ],
                  ),
                ),
                if (!_isLoading)
                  Padding(
                    padding: const EdgeInsets.only(top: kToolbarHeight),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: GestureDetector(
                            onTapDown: _onTapDown,
                            onTapUp: (_) => _onTapUp(_onPrevious),
                          ),
                        ),
                        Expanded(
                          flex: 7,
                          child: GestureDetector(
                            onTapDown: _onTapDown,
                            onTapUp: (_) => _onTapUp(_onNext),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (widget.frame.action != null)
                  _buildAction(
                    contraints,
                    widget.frame.imageUrl?.contains('saudi') == true ? const Color(0xff003449) : null,
                  ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  Align _buildAction(BoxConstraints contraints, [Color? actionColor]) => Align(
    alignment: Alignment.bottomCenter,
    child: Container(
      width: contraints.maxWidth,
      padding: storyTheme.actionTheme.padding,
      decoration: BoxDecoration(
        gradient: storyTheme.actionTheme.hasGradient
            ? LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0, 1],
                colors: [
                  storyTheme.backgroundColor.withOpacity(0),
                  storyTheme.backgroundColor,
                ],
              )
            : null,
      ),
      child: _frame.isButtonEnabled
          ? StoryFrameActionButton(
              actionTheme: storyTheme.actionTheme,
              action: widget.frame.action!,
              actionColor: actionColor,
              onNext: _onNext,
              onActionPressed: () => widget.onActionPressed?.call(widget.frame),
            )
          : const SizedBox.shrink(),
    ),
  );

  Padding _buildTopbar(BuildContext context) => Padding(
    padding: const EdgeInsets.only(
      top: Spacing.$4x,
      left: Spacing.$5x,
      right: Spacing.$4x,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (StoryTypes.saudiDay != widget.type)
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.only(end: Spacing.$4x),
              child: FrameProgressIndicator(
                frameIndex: widget.frameIndex,
                framesLength: widget.frameLength,
                animation: _progress,
                trackTheme: storyTheme.trackTheme,
              ),
            ),
          )
        else
          const Spacer(),
        Consumer(
          builder: (context, ref, _) => AppButton.close(
            onTap: () {
              if (widget.frameIndex == widget.frameLength - 1) {
                ref.read(advertMetricsProvider.notifier).sendEvent(AdvertMetricsKeys.onboardingStoriesCompleted);
                ref.read(appAnalyticsProvider).onboardingFlowCompleted();
              } else {
                ref.read(appAnalyticsProvider).onboardingFlowSkipped();
              }
              StoryArgsProvider.of(context).onClose();
            },
            innerPadding: const EdgeInsets.all(Spacing.$2x),
            padding: EdgeInsets.zero,
            buttonColorScheme: ButtonColorScheme.accentSecondary,
            color: storyTheme.closeButtonTheme.backgroundColor,
            iconColor: storyTheme.closeButtonTheme.iconColor,
          ),
        ),
      ],
    ),
  );

  LoadingShimmerImage _buildImage({required String title}) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;
    var imageUrl = widget.frame.imageUrl!;

    if (isArabic && widget.frame.arabicImageUrl != null) {
      imageUrl = widget.frame.arabicImageUrl!;
    }
    return LoadingShimmerImage(
      isAssetImg: widget.frame.isAssetImage,
      onImageReady: _imageLoaded,
      imageUrl: imageUrl,
      fit: BoxFit.cover,
    );
  }
}
