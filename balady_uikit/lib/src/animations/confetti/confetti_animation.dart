import 'package:balady_uikit/src/animations/confetti/confetti_config.dart';
import 'package:balady_uikit/src/animations/confetti/confetti_shape.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:urbi_utils/urbi_utils.dart';

const double _kMaxWidth = 100000.0;
const double _kMaxHeight = 100000.0;
const int particalsCount = 100;

/// Confetti animation widget.
///
/// Needs a parent to set the constraints.
class ConfettiAnimation extends StatefulWidget {
  /// Animation controller for the confetti animation.
  final AnimationController animationController;

  /// Config which is used to generate confetti particles and playing animation.
  final ConfettiGeneratorConfig config;

  const ConfettiAnimation({
    required this.animationController,
    required this.config,
    super.key,
  });

  @override
  State<ConfettiAnimation> createState() => _ConfettiAnimationState();

  /// Displays the animation in the overlay.
  static void explodeInOverlay(
    BuildContext context,
    TickerProvider vsync, {
    Duration duration = const Duration(seconds: 4),
    Widget? debugRequiredFor,
    OverlayEntry? belowEntry,
    ConfettiGeneratorConfig? config,
  }) {
    final controller = AnimationController(vsync: vsync);

    final overlayEntry = OverlayEntry(builder: (context) {
      return ConfettiAnimation(
        animationController: controller,
        config: config ?? ConfettiGeneratorConfig.confetti(),
      );
    });

    Overlay.of(context, debugRequiredFor: debugRequiredFor).insert(overlayEntry, below: belowEntry);

    controller.animateTo(1, duration: duration, curve: Curves.easeOutQuint).whenCompleteOrCancel(() {
      controller.dispose();
      overlayEntry
        ..remove()
        ..dispose();
    });
  }
}

class _ConfettiAnimationState extends State<ConfettiAnimation> {
  @override
  Widget build(BuildContext context) {
    return _RenderConfettiWidget(widget.animationController, widget.config);
  }
}

class _RenderConfettiWidget extends LeafRenderObjectWidget {
  final AnimationController animationController;
  final ConfettiGeneratorConfig config;

  const _RenderConfettiWidget(this.animationController, this.config);

  @override
  _RenderConfetti createRenderObject(BuildContext context) => _RenderConfetti(
        animationController: animationController,
        config: config,
      );

  @override
  void updateRenderObject(BuildContext context, _RenderConfetti renderObject) => renderObject;
}

class _RenderConfetti extends RenderBox {
  AnimationController animationController;

  ConfettiGeneratorConfig config;

  double _currentAnimationValue = 0;
  List<ConfettiShape> shapes = [];

  _RenderConfetti({
    required this.animationController,
    required this.config,
  });

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    animationController.view.addListener(_updateAnimation);
    _updateAnimation();
  }

  @override
  bool get sizedByParent => true;

  @override
  void detach() {
    animationController.view.removeListener(_updateAnimation);
    super.detach();
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    return constraints.constrain(const Size(_kMaxWidth, _kMaxHeight));
  }

  @override
  bool hitTestSelf(Offset position) => false;

  void _updateAnimation() {
    if (animationController.value == 0) {
      shapes = ConfettiShape.generateShapes(config);
    }

    if (animationController.value != _currentAnimationValue) {
      _currentAnimationValue = _currentAnimationValue = animationController.value;

      markNeedsPaint();
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);

    if (_currentAnimationValue == 0) {
      return;
    }

    double opacity = 1;
    double shrink = 1;
    if (config.disappearBehavior == ConfettiDisappearBehavior.fade) {
      opacity = config.disappearCurve
          .transform(1 - MathHelper.lerpBetween(_currentAnimationValue, 0.0, 1, config.disappearStartsAt, 1));
    } else if (config.disappearBehavior == ConfettiDisappearBehavior.shrink) {
      shrink = config.disappearCurve
          .transform(1 - MathHelper.lerpBetween(_currentAnimationValue, 0.0, 1, config.disappearStartsAt, 1));
    } else {
      opacity = config.disappearCurve
          .transform(1 - MathHelper.lerpBetween(_currentAnimationValue, 0.0, 1, config.disappearStartsAt, 1));
      shrink = config.disappearCurve
          .transform(1 - MathHelper.lerpBetween(_currentAnimationValue, 0.0, 1, config.disappearStartsAt, 1));
    }

    final canvas = context.canvas;
    for (final shape in shapes) {
      shape.paint(canvas, size, offset, _currentAnimationValue, opacity, shrink);
    }
  }
}
