import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/common/image/loading_image/loading_image.dart';
import 'package:mapness/features/stories/models/story_fame_theme_data.dart';
import 'package:mapness/features/stories/models/story_frame_action.dart';
import 'package:mapness/features/stories/models/story_frame_controller.dart';
import 'package:mapness/features/stories/models/story_frame_data.dart';
import 'package:mapness/features/stories/models/story_localization.dart';
import 'package:mapness/features/stories/ui/frame_progress_indicator.dart';
import 'package:mapness/features/stories/ui/story_args_provider.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:url_launcher/url_launcher.dart';

part 'story_frame_action_button.dart';
part 'story_frame_content.dart';

class StoryFrameWidget extends StatefulWidget {
  final StoryFrameData frame;
  final int frameIndex;
  final int frameLength;
  final int duration;
  final StoryFrameController? controller;

  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const StoryFrameWidget({
    required this.duration,
    required this.frame,
    required this.frameIndex,
    required this.frameLength,
    required this.onNext,
    required this.onPrevious,
    super.key,
    this.controller,
  });

  @override
  State<StoryFrameWidget> createState() => _StoryFrameWidgetState();
}

class _StoryFrameWidgetState extends State<StoryFrameWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progress;
  late final StoryFrameData _frame;
  late final StoryFrameThemeData storyTheme = _frame.themeFromId(
    colorTheme: context.colorsV2,
    textTheme: context.textStyleV3,
  );

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
    _controller = AnimationController(
      duration: Duration(seconds: widget.duration),
      vsync: this,
    );

    widget.controller?.pause = _controller.stop;
    widget.controller?.play = _controller.forward;

    widget.controller?.nextPage = _onNext;
    widget.controller?.prevPage = _onPrevious;

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
      _controller.stop();
    }
    if (_frame != widget.frame) {
      _frame = widget.frame;
      _controller.reset();
    }
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
  Widget build(BuildContext context) => Material(
        color: storyTheme.backgroundColor,
        child: SafeArea(
          child: Directionality(
            textDirection: Directionality.of(context),
            child: LayoutBuilder(
                builder: (context, contraints) => SizedBox.fromSize(
                      size: contraints.biggest,
                      child: ColoredBox(
                        color: storyTheme.backgroundColor,
                        child: Stack(
                          children: [
                            if (storyTheme.gradientColor != null)
                              Align(
                                alignment: Alignment.topLeft,
                                child: SizedBox(
                                  height: MediaQuery.sizeOf(context).height / 2,
                                  width: double.infinity,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      gradient: RadialGradient(
                                        radius: 1,
                                        center: Alignment.topLeft,
                                        colors: [
                                          storyTheme.gradientColor!,
                                          storyTheme.backgroundColor,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            Column(
                              children: [
                                FrameProgressIndicator(
                                  onClose: StoryArgsProvider.of(context).onClose,
                                  frameIndex: widget.frameIndex,
                                  framesLength: widget.frameLength,
                                  animation: _progress,
                                  thumbnailTheme: storyTheme.thumbnailTheme,
                                ),
                                SizedBox(
                                  width: contraints.maxWidth,
                                  child: StoryFrameContent(
                                    frame: widget.frame,
                                  ),
                                ),
                                if (widget.frame.imageUrl != null)
                                  Expanded(
                                    child: LoadingImage(
                                      isAssetImg: widget.frame.isAssetImage,
                                      onImageReady: _imageLoaded,
                                      imageUrl: widget.frame.imageUrl!,
                                      fit: BoxFit.cover,
                                      loadingWidget: Container(
                                        color: storyTheme.backgroundColor,
                                        child: Center(
                                          child: Loading.large(
                                            style: Brightness.light,
                                            orientation: Axis.vertical,
                                            title: context.l10n.loading,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),

                            /// left right click handlers
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
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                    width: contraints.maxWidth,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: storyTheme.actionTheme.horizontalPadding,
                                      vertical: Spacing.$4x,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        stops: const [0, 0.5, 1],
                                        colors: [
                                          storyTheme.backgroundColor.withOpacity(0),
                                          storyTheme.backgroundColor,
                                          storyTheme.backgroundColor,
                                        ],
                                      ),
                                    ),
                                    child: StoryFrameActionButton(
                                      actionTheme: storyTheme.actionTheme,
                                      action: widget.frame.action!,
                                    )),
                              ),
                          ],
                        ),
                      ),
                    )),
          ),
        ),
      );
}
