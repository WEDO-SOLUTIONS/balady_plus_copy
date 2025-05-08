import 'dart:math';
import 'dart:ui' as ui;

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/advert_metrics/advert_metrics.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

/// TODO('Ayat') Change to normal design and delete this class
class FeedbackBannerPhoto extends ConsumerWidget {
  const FeedbackBannerPhoto({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => GestureDetector(
        onTap: () {
          ref.read(advertMetricsProvider.notifier).sendEvent(AdvertMetricsKeys.addPoiBanner);
          context.router.push(QuickFeedbackRoute());
        },
        child: Container(
          height: 96,
          margin: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
          padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(RadiusBorder.xl),
            image: DecorationImage(
              image: AssetImage(Assets.images.bannerFeedbackDashborad.keyName),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Align(
                alignment: AlignmentDirectional.topEnd,
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(top: Spacing.$2x),
                  child: SizedBox(
                    width: Spacing.$6x,
                    height: Spacing.$6x,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Spacing.$1_5x),
                        color: context.colorsV3.staticWhite.withOpacity(0.2),
                      ),
                      child: Center(
                        child: Assets.images.icArrowFeedback.svg(),
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(end: Spacing.$6x),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.contribute,
                        style: context.textStyleV3.h4SemiBold,
                      ),
                      Text(
                        context.l10n.buildBaladyTogether,
                        style: context.textStyleV3.captionLargeRegular,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
}

class FeedbackBannerCard extends StatelessWidget {
  final String title;
  final String path;
  final String? subtitle;
  final List<Color> gradientColors;
  final VoidCallback? onTap;

  const FeedbackBannerCard({
    required this.path,
    required this.gradientColors,
    required this.title,
    this.subtitle,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
        child: GestureDetector(
          onTap: onTap,
          child: _FeedBackWidget(
            asset: path,
            title: title,
            subTitle: subtitle,
            gradientColors: gradientColors,
            textDirection: Directionality.of(context),
            child: Padding(
              padding: const EdgeInsetsDirectional.only(end: Spacing.$4x),
              child: SizedBox(
                width: Spacing.$6x,
                height: Spacing.$6x,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Spacing.$1_5x),
                    color: context.colorsV3.staticWhite.withOpacity(0.2),
                  ),
                  child: Center(
                    child: Icon(
                      SystemIcons.arrowRight,
                      color: context.colorsV3.staticWhite,
                      size: Spacing.$5x,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

class _FeedBackWidget extends SingleChildRenderObjectWidget {
  final String title;
  final String? subTitle;
  final String asset;
  final List<Color> gradientColors;
  final TextDirection textDirection;

  const _FeedBackWidget({
    required this.title,
    required this.subTitle,
    required this.asset,
    required this.gradientColors,
    required this.textDirection,
    super.child,
  });

  @override
  _RenderFeedBack createRenderObject(BuildContext context) => _RenderFeedBack(
        title: TextSpan(
          text: title,
          style: context.textStyleV3.h4SemiBold.copyWith(color: context.colorsV3.staticWhite),
        ),
        subTitle: TextSpan(
          text: subTitle ?? '',
          style: context.textStyleV3.captionSmallMedium.copyWith(color: context.colorsV3.staticWhite),
        ),
        asset: asset,
        gradientColors: gradientColors,
        textDirection: textDirection,
        minTextPadding: const EdgeInsets.only(top: 11.0, bottom: 15.0, right: 16.0, left: 16.0),
        textGap: Spacing.$1x,
        imageShift: 9.0,
        designMinHeight: 96,
      );

  @override
  void updateRenderObject(BuildContext context, covariant _RenderFeedBack renderObject) {
    renderObject.update(
      TextSpan(
        text: title,
        style: context.textStyleV3.h4SemiBold.copyWith(color: context.colorsV3.staticWhite),
      ),
      TextSpan(
        text: subTitle ?? '',
        style: context.textStyleV3.captionSmallMedium.copyWith(color: context.colorsV3.staticWhite),
      ),
      asset,
      gradientColors,
      textDirection,
    );
  }
}

class _RenderFeedBack extends RenderBox with RenderObjectWithChildMixin<RenderBox> {
  final EdgeInsets minTextPadding;
  final double designMinHeight;
  final double textGap;
  final double imageShift;

  List<Color> gradientColors;
  InlineSpan title;
  InlineSpan subTitle;
  TextDirection textDirection;

  TextPainter titlePainter;
  TextPainter subtitlePainter;

  /// ---- Image control fields ---------------------------------------------------------
  ui.Image? image;
  late ImageStream imageStream;
  late ImageStreamListener imageListener;
  bool hasImage = false;
  Size imageSize = Size.zero;
  String asset;

  _RenderFeedBack({
    required this.title,
    required this.subTitle,
    required this.asset,
    required this.gradientColors,
    required this.textDirection,
    required this.minTextPadding,
    required this.textGap,
    required this.imageShift,
    required this.designMinHeight,
  })  : titlePainter = TextPainter(text: title, textDirection: textDirection),
        subtitlePainter = TextPainter(text: subTitle, textDirection: textDirection) {
    loadImage();
  }

  void update(
    InlineSpan title,
    InlineSpan subTitle,
    String asset,
    List<Color> gradientColors,
    TextDirection textDirection,
  ) {
    final isTextDirectionChanged = this.textDirection != textDirection;
    if (this.title != title || isTextDirectionChanged) {
      this.title = title;
      this.textDirection = textDirection;
      titlePainter = TextPainter(text: title, textDirection: textDirection);
      markNeedsLayout();
    }

    if (this.subTitle != subTitle || isTextDirectionChanged) {
      this.subTitle = subTitle;
      subtitlePainter = TextPainter(text: subTitle, textDirection: textDirection);
      markNeedsLayout();
    }

    if (this.asset != asset) {
      this.asset = asset;
      loadImage();
      markNeedsLayout();
    }

    if (this.gradientColors != gradientColors) {
      this.gradientColors = gradientColors;
      markNeedsPaint();
    }
  }

  void loadImage() {
    final ImageProvider assetImage = AssetImage(asset);
    imageStream = assetImage.resolve(const ImageConfiguration());
    imageListener = ImageStreamListener((imageInfo, synchronousCall) {
      image = imageInfo.image;
      hasImage = true;

      /// Request a layout pass when image is ready
      markNeedsLayout();
    });

    imageStream.addListener(imageListener);
  }

  @override
  void detach() {
    imageStream.removeListener(imageListener);
    super.detach();
  }

  @override
  void performLayout() {
    double aspectRatio = 0.0;

    /// Get aspect ratio of the image.
    if (hasImage && image != null) {
      final imageWidth = image!.width;
      final imageHeight = image!.height;
      aspectRatio = imageWidth / imageHeight;
    }

    /// Calculate desire width for the image based on min height and layout titles and child.
    final imageDesireWidth = designMinHeight * aspectRatio;
    titlePainter.layout(maxWidth: constraints.maxWidth - imageDesireWidth);
    subtitlePainter.layout(maxWidth: constraints.maxWidth - imageDesireWidth);
    child?.layout(constraints.copyWith(minWidth: 0.0));

    /// Calculate actual height of the widget.
    final heightPaddings = minTextPadding.top + minTextPadding.bottom + textGap;
    final textHeight = max(titlePainter.height + subtitlePainter.height + heightPaddings, designMinHeight);

    /// Based on the height resize the image.
    imageSize = Size(textHeight * aspectRatio, textHeight);

    /// Set the size of the Widget.
    final textWidth = max(titlePainter.width, subtitlePainter.width);
    size = Size(max(constraints.minWidth, textWidth + imageSize.width), textHeight);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final width = size.width;
    final rect = Rect.fromLTWH(
      0.0,
      0.0,
      width,
      size.height,
    );

    void paintCard(PaintingContext context, Offset offset) {
      final Canvas canvas = context.canvas;
      final isLTR = textDirection == TextDirection.ltr;

      /// Paint background gradient.
      final painter = Paint()..shader = LinearGradient(colors: gradientColors).createShader(rect);
      canvas.drawPaint(painter);

      /// Paint image if it exist.
      if (hasImage && image != null) {
        final imageShiftDelta = imageShift / width;
        paintImage(
          canvas: canvas,
          rect: offset & size,
          alignment: Alignment(isLTR ? 1 + imageShiftDelta : -1 - imageShiftDelta, 0.5),
          flipHorizontally: !isLTR,
          image: image!,
          fit: BoxFit.contain,
        );
      }

      /// Calculate offsets for title and subtitle.
      final heightOffset = (size.height -
              minTextPadding.top -
              minTextPadding.bottom -
              textGap -
              titlePainter.height -
              subtitlePainter.height) /
          2;
      final titleOffset = Offset(
        isLTR ? offset.dx + minTextPadding.left : width - titlePainter.width,
        offset.dy + minTextPadding.top + heightOffset,
      );
      final subtitleOffset = Offset(
        isLTR ? offset.dx + minTextPadding.left : width - subtitlePainter.width,
        offset.dy + minTextPadding.top + textGap + titlePainter.height + heightOffset,
      );

      /// Paint title and subtitle
      titlePainter.paint(canvas, titleOffset);
      subtitlePainter.paint(canvas, subtitleOffset);

      /// Paint button.
      final childOffset = (child?.parentData as BoxParentData?)?.offset ?? Offset.zero;
      final childPosition = Offset(
        isLTR ? width - (child?.size.width ?? 0.0) : 0.0,
        size.height - childOffset.dy - (child?.size.height ?? 0.0) - minTextPadding.bottom - heightOffset,
      );
      child?.paint(
        context,
        offset + childOffset + childPosition,
      );
    }

    layer = context.pushClipRRect(
      needsCompositing,
      offset,
      rect,
      RRect.fromRectAndRadius(rect, const Radius.circular(RadiusBorder.ml)),
      paintCard,
      oldLayer: layer as ClipRRectLayer?,
    );
  }

  @override
  bool hitTest(BoxHitTestResult result, {required ui.Offset position}) =>
      super.hitTest(result, position: position - Offset(minTextPadding.left, 0.0));

  @override
  bool hitTestSelf(ui.Offset position) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    return rect.contains(position);
  }
}
