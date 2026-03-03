import 'dart:math';

import 'package:balady_uikit/src/animations/confetti/confetti_animation.dart';
import 'package:balady_uikit/src/animations/confetti/confetti_config.dart';
import 'package:balady_uikit/src/animations/confetti/confetti_shape.dart';
import 'package:balady_uikit/src/animations/feedback_icon/confirm_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:urbi_utils/urbi_utils.dart';

const double _kMaxWidth = 100000.0;
const double _kMaxHeight = 100000.0;

const int _pathCount = 22220;
const int _rotationCount = 1333;

class FeedbackConfirmationIndicator extends StatefulWidget {
  final Color color;
  final bool isLoading;
  final VoidCallback? onComplete;
  final ConfettiGeneratorConfig? iconConfettiConfig;

  const FeedbackConfirmationIndicator({
    required this.color,
    this.isLoading = true,
    this.onComplete,
    this.iconConfettiConfig,
    super.key,
  });

  @override
  State<FeedbackConfirmationIndicator> createState() => _FeedbackConfirmationIndicatorState();
}

class _FeedbackConfirmationIndicatorState extends State<FeedbackConfirmationIndicator> with TickerProviderStateMixin {
  late final AnimationController rotateController;
  late final AnimationController stateController;
  late final AnimationController confettiController;
  final Debouncer debouncer = Debouncer(const Duration(seconds: 1));

  late ConfettiGeneratorConfig iconConfettiConfig;

  bool isConfettiAnimationPlayed = false;

  @override
  void initState() {
    iconConfettiConfig = widget.iconConfettiConfig ??
        ConfettiGeneratorConfig.confetti(
          animationDuration: const Duration(seconds: 1),
          disappearBehavior: ConfettiDisappearBehavior.shrink,
          count: 15,
          velocityMaxX: 0.7,
          velocityMinX: -0.7,
          velocityMaxY: 0.6,
          velocityMinY: -0.6,
          dissappearStartsAt: 0.2,
          dissappearCurve: Curves.decelerate,
          scaleGrowthMin: 0.2,
          scaleGrowthMax: 0.3,
          rotationSpeedX: 0,
          rotationSpeedY: 0,
          rotationSpeedZ: 0,
          commonGradientAppearance: 0,
          gradientColors: [
            [
              const Color(0xffFB4D4D),
              const Color(0xffFB4D4D),
            ],
            [
              const Color(0xff36C874),
              const Color(0xff36C874),
            ],
            [
              const Color(0xffF5A623),
              const Color(0xffF5A623),
            ],
          ],
          confettiShapes: [
            (s, v, scale, g, x, y, z) => CircleShape(s, v, scale, g, x, y, z),
            (s, v, scale, g, x, y, z) => ShiningShape(s, v, scale, g, x, y, z),
            (s, v, scale, g, x, y, z) => RombShape(s, v, scale, g, x, y, z),
          ],
          commonShapeAppearance: 0,
        );

    rotateController = AnimationController(
      vsync: this,
      animationBehavior: AnimationBehavior.preserve,
      duration: const Duration(milliseconds: _pathCount * _rotationCount),
    );
    stateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    confettiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    if (!widget.isLoading) {
      stateController.animateTo(1);
    }

    stateController.addListener(() {
      const confettiStartInterval = 0.34;
      const confettiEndInterval = 0.35;

      if (stateController.value >= confettiStartInterval &&
          confettiEndInterval > stateController.value &&
          !isConfettiAnimationPlayed &&
          !widget.isLoading &&
          mounted) {
        isConfettiAnimationPlayed = true;
        widget.onComplete?.call();
        confettiController.animateTo(1, duration: const Duration(seconds: 1)).whenCompleteOrCancel(() {
          isConfettiAnimationPlayed = false;
          if (mounted) {
            confettiController.value = 0;
          }
        });
      }
    });

    rotateController.repeat();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant FeedbackConfirmationIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.isLoading) {
      stateController.animateTo(1);
    } else {
      stateController.reset();
    }

    final iconConfigWidget = widget.iconConfettiConfig;
    if (iconConfigWidget != null && oldWidget.iconConfettiConfig != iconConfigWidget) {
      iconConfettiConfig = iconConfigWidget;
    }
  }

  @override
  void dispose() {
    rotateController.dispose();
    stateController.dispose();
    confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          ConfettiAnimation(
            animationController: confettiController,
            config: iconConfettiConfig,
          ),
          _RenderFeedbackConfirmationWidget(widget.color, rotateController, stateController),
        ],
      );
}

class _RenderFeedbackConfirmationWidget extends LeafRenderObjectWidget {
  final Color color;
  final AnimationController rotateController;
  final AnimationController stateController;

  const _RenderFeedbackConfirmationWidget(this.color, this.rotateController, this.stateController);

  @override
  _RenderFeedbackConfirmationIdicator createRenderObject(BuildContext context) =>
      _RenderFeedbackConfirmationIdicator(color, rotateController: rotateController, stateController: stateController);

  @override
  void updateRenderObject(BuildContext context, _RenderFeedbackConfirmationIdicator renderObject) => renderObject;
}

class _RenderFeedbackConfirmationIdicator extends RenderBox {
  final Color color;

  AnimationController rotateController;
  AnimationController stateController;

  double rotationValue = 0;
  double stateValue = 0;

  double get head => _strokeHeadTween.evaluate(rotateController);
  double get tail => _strokeTailTween.evaluate(rotateController);
  double get offsetRotation => _offsetTween.evaluate(rotateController);
  double get rotation => _rotationTween.evaluate(rotateController);

  static final Animatable<double> _strokeHeadTween = CurveTween(
    curve: const Interval(0.0, 0.5, curve: Curves.fastOutSlowIn),
  ).chain(CurveTween(
    curve: const SawTooth(_pathCount),
  ));
  static final Animatable<double> _strokeTailTween = CurveTween(
    curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
  ).chain(CurveTween(
    curve: const SawTooth(_pathCount),
  ));

  static final Animatable<double> _offsetTween = CurveTween(curve: const SawTooth(_pathCount));
  static final Animatable<double> _rotationTween = CurveTween(curve: const SawTooth(_rotationCount));

  _RenderFeedbackConfirmationIdicator(
    this.color, {
    required this.rotateController,
    required this.stateController,
  });

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    rotateController.view.addListener(_updateAnimationRotation);
    stateController.view.addListener(_updateAnimationState);
    _updateAnimationRotation();
    _updateAnimationState();
  }

  @override
  bool get sizedByParent => true;

  @override
  void detach() {
    rotateController.view.removeListener(_updateAnimationRotation);
    stateController.view.removeListener(_updateAnimationState);
    super.detach();
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return constraints.constrain(const Size(_kMaxWidth, _kMaxHeight));
  }

  @override
  bool hitTestSelf(Offset position) => false;

  void _updateAnimationRotation() {
    if (rotateController.value != rotationValue) {
      rotationValue = rotationValue = rotateController.value;

      if (stateValue < 0.5) {
        markNeedsPaint();
      }
    }
  }

  void _updateAnimationState() {
    if (stateController.value != stateValue) {
      stateValue = stateValue = stateController.value;
      markNeedsPaint();
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);

    final canvas = context.canvas;

    double startAngle;
    double arcSweep;
    double strokeWidth = 0.0;
    double circleSize = 0.0;
    double opacity = 0.0;
    double wave = 0.0;
    double iconRotation = 0.0;

    const _startAngle = -pi / 2.0;

    /// Calculate the strokeWidth for the circular indicator.
    const strokeStage1 = 0.05;
    const strokeStage2 = 0.2;

    const dynamicStrokeWidthMin = 2.0;

    if (stateValue < strokeStage1) {
      strokeWidth = dynamicStrokeWidthMin;
    } else if (stateValue <= strokeStage2) {
      strokeWidth = (MathHelper.lerpBetween(
              Curves.easeInSine.transform(1 - MathHelper.normalize(stateValue, strokeStage1, strokeStage2)),
              0,
              1,
              0,
              1)) *
          dynamicStrokeWidthMin;
    } else {
      strokeWidth = dynamicStrokeWidthMin;
    }

    /// Calculate the wave delta for wave stroke circle around the indicator.
    const waveStage1 = 0.20;
    const waveStage2 = 0.4;

    const waveStrokeWidth = 10.0;

    final waveStroke = stateValue < waveStage2
        ? waveStrokeWidth *
            Curves.decelerate.transform(MathHelper.normalize(waveStage2 - stateValue, 0, waveStage1).clamp(0, 1))
        : waveStrokeWidth;

    if (stateValue > waveStage1) {
      wave = Curves.decelerate.transform(MathHelper.lerpBetween(stateValue, 0, 1, waveStage1, waveStage2));
    } else if (stateValue > waveStage2) {
      wave = 1;
    }

    /// Calculate the opacity for filled circle.
    const opacityStage1 = 0.22;
    const opacityStage2 = 0.35;

    if (stateValue > opacityStage1) {
      opacity = MathHelper.lerpBetween(stateValue, 0, 1, opacityStage1, opacityStage2);
    } else if (stateValue > opacityStage2) {
      opacity = 1;
    }

    /// Calculate the rotation delta for the confirm icon.
    const iconRotationStage1 = 0.2;
    const iconRotationStage2 = 0.35;
    const iconRotationStage3 = 0.38;

    if (stateValue < iconRotationStage1) {
      iconRotation = 0;
    } else if (stateValue > iconRotationStage3) {
      iconRotation = 1;
    } else if (stateValue > iconRotationStage1 && stateValue <= iconRotationStage2) {
      iconRotation = MathHelper.lerpBetween(
        Curves.decelerate.transform(MathHelper.normalize(
          stateValue,
          iconRotationStage1,
          iconRotationStage2,
        )),
        0,
        1.05,
        0,
        1,
      );
    } else if (stateValue > iconRotationStage2) {
      iconRotation =
          MathHelper.lerpBetween(iconRotationStage3 - stateValue, 1, 1.05, 0, iconRotationStage3 - iconRotationStage2);
    }

    /// Calculate the size of the circle.
    const circleShrinkStage1 = 0.3;
    const circleShrinkStage2 = 0.35;
    const circleShrinkStage3 = 0.38;

    const circleShrinkSizeMin = 1.0;
    const circleShrinkSizeMax = 1.5;

    if (stateValue < circleShrinkStage1) {
      circleSize = 0;
    } else if (stateValue > circleShrinkStage3) {
      circleSize = circleShrinkSizeMin;
    } else if (stateValue >= circleShrinkStage1 && stateValue < circleShrinkStage2) {
      circleSize = MathHelper.lerpBetween(
        Curves.easeOutCubic.transform(MathHelper.normalize(
          stateValue,
          circleShrinkStage1,
          circleShrinkStage2,
        )),
        0,
        circleShrinkSizeMax,
        0,
        1,
      );
    } else if (stateValue >= circleShrinkStage2) {
      circleSize = MathHelper.lerpBetween(
        circleShrinkStage3 - stateValue,
        circleShrinkSizeMin,
        circleShrinkSizeMax,
        0,
        circleShrinkStage3 - circleShrinkStage2,
      );
    }

    final Paint wavePaint = Paint()
      ..color = color.withOpacity(1 - wave)
      ..style = PaintingStyle.stroke
      ..strokeWidth = waveStroke;

    final Paint circlePaint = Paint()
      ..color = color.withOpacity(opacity)
      ..style = PaintingStyle.fill;

    final Paint dynamicStrokePaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth.clamp(0, 2)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Size arcActualSize = Size(
      size.shortestSide / 2,
      size.shortestSide / 2,
    );

    /// Calculate the start and the size of the arc sweep for circular progress indicator.
    if (stateValue < 0.05) {
      startAngle = _startAngle + tail * 3 / 2 * pi + rotation * pi * 2.0 + offsetRotation * 0.5 * pi;
      arcSweep = max(head * 3 / 2 * pi - tail * 3 / 2 * pi, 0.001);
    } else {
      final progress = Curves.easeOut.transform(MathHelper.lerpBetween(stateValue, 0, 1, 0.05, 0.35));

      startAngle = _startAngle + tail * 3 / 2 * pi + rotation * pi * 2.0 + offsetRotation * 0.5 * pi;
      arcSweep = max(head * 3 / 2 * pi - tail * 3 / 2 * pi, 0.001) + progress * pi * 4;
    }

    final circleOffset = Offset(
          (size.width - arcActualSize.width) / 2 + offset.dx,
          size.height / 4 + offset.dy,
        ) &
        arcActualSize;

    final deflatedCircleOffset = circleOffset.deflate(circleSize);

    // Paint circular progress indicator
    if (stateValue < circleShrinkStage1) {
      canvas.drawArc(
        deflatedCircleOffset,
        startAngle,
        arcSweep,
        false,
        dynamicStrokePaint,
      );
    }

    const drawFullStop = 0;

    // Paint circle background
    if (opacity > drawFullStop) {
      canvas.drawCircle(deflatedCircleOffset.center, deflatedCircleOffset.shortestSide / 2, circlePaint);
    }

    // Paint circle wave
    if (wave > drawFullStop) {
      canvas.drawArc(circleOffset.inflate(wave * 20), 0, pi * 2, false, wavePaint);
    }

    /// Paint confirm icon.
    final iconWidth = circleOffset.deflate(circleOffset.shortestSide / 2.8).size.shortestSide;
    ConfirmIcon().paint(
        canvas,
        iconWidth,
        Offset(
          size.width / 2 + offset.dx,
          size.height / 2 + offset.dy,
        ),
        iconRotation);
  }
}
