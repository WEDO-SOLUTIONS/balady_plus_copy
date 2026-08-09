import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/features/poi_card/domain/model/poi_content/poi_content.dart';

class PoiContentAboutCard extends StatefulWidget {
  final int collapsedLinesCount;
  final PoiContentAboutModel data;
  final Duration animationDuration;
  final Curve animationCurve;
  final bool isExpandable;

  const PoiContentAboutCard({
    required this.data,
    this.collapsedLinesCount = 3,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeInOut,
    this.isExpandable = true,
    super.key,
  });

  @override
  State<PoiContentAboutCard> createState() => _PoiContentAboutCardState();
}

class _PoiContentAboutCardState extends State<PoiContentAboutCard> with SingleTickerProviderStateMixin {
  static const _heightOfGradient = 36.0;

  // This manages height and label "Show more"/"Show less"
  bool isFullVisible = false;
  bool truncateText = false;
  double _maxWidth = 100;

  String? _measuredText;
  int? _measuredCollapsedLines;

  // ignore: prefer_const_constructors
  _AboutTextModel _textHeight = _AboutTextModel(height: 0, heightTruncated: 0, linesCount: 0);

  bool get _showExpandButton => _textHeight.linesCount > widget.collapsedLinesCount && widget.isExpandable;

  late final AnimationController _animationController;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: widget.animationDuration);
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _animationController, curve: widget.animationCurve));

    _animationController.addListener(() {
      if (truncateText != (_animationController.value == 0)) {
        setState(() => truncateText = _animationController.value == 0);
      }
      if (_animationController.value == 0 && isFullVisible) {
        setState(() => isFullVisible = false);
      } else if (_animationController.value == 1 && !isFullVisible) {
        setState(() => isFullVisible = true);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ContentWrapper.single(
    color: context.colors.backgroundSurface1,
    child: ContentRow(
      backgroundColor: context.colors.backgroundSurface1,
      text: ContentRowTextOptions(
        title: widget.data.aboutTitle,
        titleOptions: const ContentRowTextOption(isBold: true),
        subtitleExtraOptions: _showExpandButton
            ? ContentRowTextOption(
                isBold: true,
                builder: (context) => GestureDetector(
                  onTap: () {
                    if (!isFullVisible) {
                      _animationController.forward();
                    } else {
                      _animationController.reverse();
                    }
                  },
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) => Stack(
                      children: [
                        Text(
                          maxLines: 1,
                          widget.data.showLessTitle,
                          style: context.textStyle.footNoteBold.copyWith(
                            color: context.colors.accentDefault.withOpacity(_animation.value),
                          ),
                        ),
                        Text(
                          maxLines: 1,
                          widget.data.showMoreTitle,
                          style: context.textStyle.footNoteBold.copyWith(
                            color: context.colors.accentDefault.withOpacity(1 - _animation.value),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : null,
        subtitleOptions: ContentRowTextOption(
          builder: (context) => LayoutBuilder(
            builder: (context, constraints) {
              _measureText(context, constraints.maxWidth);

              return AnimatedBuilder(
                animation: _animation,
                builder: (context, child) => Stack(
                  alignment: AlignmentDirectional.bottomStart,
                  children: [
                    SizedBox(
                      height: widget.isExpandable && _animation.value != 1
                          ? _textHeight.heightTruncated +
                                (_textHeight.height - _textHeight.heightTruncated) * _animation.value
                          : null,
                      width: _maxWidth,
                      child: Text(
                        widget.data.text,
                        maxLines: truncateText ? widget.collapsedLinesCount : 99,
                        overflow: TextOverflow.ellipsis,
                        style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundSoft),
                      ),
                    ),
                    if (_showExpandButton)
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            // TODO: Change to gradientBackgroundSurface0 and gradientBackgroundSurface80
                            // When this colors will be added to UIKit
                            colors: [
                              context.colors.gradientBackgroundSurface1opacity0,
                              context.colors.gradientBackgroundSurface1opacity80,
                            ],
                          ),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          height: Curves.easeOutCubic.transform(1 - _animation.value) * _heightOfGradient,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    ),
  );

  void _measureText(BuildContext context, double maxWidth) {
    if (_maxWidth == maxWidth &&
        _measuredText == widget.data.text &&
        _measuredCollapsedLines == widget.collapsedLinesCount) {
      return;
    }

    _maxWidth = maxWidth;
    _measuredText = widget.data.text;
    _measuredCollapsedLines = widget.collapsedLinesCount;

    final wasExpandable = _showExpandButton;
    _textHeight = _calculateTextHeight(context, widget.data.text, maxWidth);

    // The "Show more" button lives in ContentRow's subtitleExtra slot, which is
    // built before this one, so it can only pick up the new measurement on the
    // next frame.
    if (_showExpandButton != wasExpandable) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  _AboutTextModel _calculateTextHeight(BuildContext context, String text, double maxWidth) {
    final textDirection = Directionality.of(context);
    final span = TextSpan(
      text: text,
      style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundDefault),
    );
    // Match the Text widget, which scales with the platform text-size setting.
    final textScaler = MediaQuery.textScalerOf(context);
    final painter = TextPainter(text: span, textDirection: textDirection, textScaler: textScaler)
      ..layout(maxWidth: maxWidth);

    final painterTruncated = TextPainter(
      text: span,
      textDirection: textDirection,
      maxLines: widget.collapsedLinesCount,
      textScaler: textScaler,
    )..layout(maxWidth: maxWidth);

    return _AboutTextModel(
      height: painter.height,
      heightTruncated: painterTruncated.height,
      linesCount: painter.computeLineMetrics().length,
    );
  }
}

/// Model for text height and lines count
class _AboutTextModel {
  /// Height of the text when it is not truncated
  final double height;

  /// Height of the text when it is truncated, for example when it is collapsed (max lines is 3)
  final double heightTruncated;

  /// Number of lines in the text if it is not truncated
  final int linesCount;

  const _AboutTextModel({required this.height, required this.heightTruncated, required this.linesCount});
}
