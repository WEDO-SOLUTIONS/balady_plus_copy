import 'package:balady_uikit/balady_uikit.dart' hide PoiContentAbout;
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/features/poi_card/domain/model/poi_content/poi_content.dart';

class PoiContentAboutCard extends StatefulWidget {
  final int collapsedLinesCount;
  final PoiContentAboutModel data;
  final Duration animationDuration;
  final Curve animationCurve;

  const PoiContentAboutCard({
    required this.data,
    this.collapsedLinesCount = 3,
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeInOut,
    super.key,
  });

  @override
  State<PoiContentAboutCard> createState() => _PoiContentAboutCardState();
}

class _PoiContentAboutCardState extends State<PoiContentAboutCard> with SingleTickerProviderStateMixin {
  bool isFullVisible = false;
  double _maxWidth = 100;
  double _textHeight = 0;
  double _textHeightTruncated = 0;
  int _linesCount = 0;

  bool get _showExpandButton => _linesCount > widget.collapsedLinesCount;

  late final AnimationController _animationController;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: widget.animationDuration);
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: widget.animationCurve,
      ),
    );

    _animationController.addListener(() {
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (_maxWidth != constraints.maxWidth) {
              _maxWidth = constraints.maxWidth;
              final (height, heightTruncated, linesCount) =
                  _calculateTextHeight(context, widget.data.text, constraints.maxWidth);
              _textHeight = height;
              _textHeightTruncated = heightTruncated;
              _linesCount = linesCount;
            }
            return ContentRowV2(
              text: ContentRowTextOptions(
                title: widget.data.aboutTitle,
                titleOptions: const ContentRowTextOption(isBold: true),
                subtitleExtraOptions: _showExpandButton
                    ? ContentRowTextOption(
                        isBold: true,
                        builder: (context) => GestureDetector(
                          onTap: () {
                            setState(() => isFullVisible = !isFullVisible);
                            if (isFullVisible) {
                              _animationController.forward();
                            } else {
                              _animationController.reverse();
                            }
                            _animationController.addListener(() {
                              if (_animationController.value == 0) {
                                setState(() => isFullVisible = !isFullVisible);
                              }
                            });
                          },
                          child: AnimatedBuilder(
                            animation: _animation,
                            builder: (context, child) => Stack(
                              children: [
                                Text(
                                  maxLines: 1,
                                  widget.data.showLessTitle,
                                  style: context.textStyle.footNoteBold.copyWith(
                                    color: context.colorsV3.accentDefault.withOpacity(_animation.value),
                                  ),
                                ),
                                Text(
                                  maxLines: 1,
                                  widget.data.showMoreTitle,
                                  style: context.textStyle.footNoteBold.copyWith(
                                    color: context.colorsV3.accentDefault.withOpacity(1 - _animation.value),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : null,
                subtitleOptions: ContentRowTextOption(
                  builder: (context) => AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) => Stack(
                      alignment: AlignmentDirectional.bottomStart,
                      children: [
                        SizedBox(
                          height: _textHeightTruncated + (_textHeight - _textHeightTruncated) * _animation.value,
                          width: _maxWidth,
                          child: Text(
                            widget.data.text,
                            maxLines: isFullVisible ? 99 : widget.collapsedLinesCount,
                            overflow: TextOverflow.ellipsis,
                            style:
                                context.textStyleV3.bodySmallRegular.copyWith(color: context.colorsV3.foregroundSoft),
                          ),
                        ),
                        if (_showExpandButton)
                          DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                // TODO: Change to gradientBackgroundSurface0 and gradientBackgroundSurface80
                                // When it will be added to UIKit
                                colors: [
                                  context.colorsV3.gradientBackgroundCardGradient0,
                                  context.colorsV3.gradientBackgroundCardGradient80
                                ],
                              ),
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              height: Curves.easeOutCubic.transform(1 - _animation.value) * 36,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );

  (double, double, int) _calculateTextHeight(BuildContext context, String text, double maxWidth) {
    final textDirection = Directionality.of(context);
    final span = TextSpan(
      text: text,
      style: context.textStyleV3.bodySmallRegular.copyWith(
        color: context.color.textAndIconsBasePrimary,
      ),
    );
    final painter = TextPainter(text: span, textDirection: textDirection)..layout(maxWidth: maxWidth);

    final painterTruncated = TextPainter(
      text: span,
      textDirection: textDirection,
      maxLines: 3,
    )..layout(maxWidth: maxWidth);

    return (painter.height, painterTruncated.height, painter.computeLineMetrics().length);
  }
}
