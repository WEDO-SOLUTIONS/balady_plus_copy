import 'dart:math';
import 'package:balady_uikit/src/animations/confetti/confetti_config.dart';
import 'package:flutter/rendering.dart';

/// Base class for all confetti animation shapes.
///
/// Extend from this to create new [ConfettiShape] which will be filled with gradient.
abstract class ConfettiShape {
  /// Velocity of the particle.
  final Offset velocity;

  /// Particle start position from `0` to `1`.
  final Offset startPosition;

  /// Particle scale at the start of animation.
  final double startScale;

  /// Particle growth scale.
  final double growthScale;

  /// Acceleration of particle rotation on X axis. From Left to Right.
  final double rotationSpeedX;

  /// Acceleration of particle rotation on Y axis. From Top to Bottom.
  final double rotationSpeedY;

  /// Acceleration of particle rotation on Z axis. Clockwise rotation.
  final double rotationSpeedZ;

  /// Gradient which will be applied to the shader.
  final List<Color> gradient;

  const ConfettiShape(
    this.startPosition,
    this.velocity,
    this.growthScale,
    this.gradient,
    this.rotationSpeedX,
    this.rotationSpeedY,
    this.rotationSpeedZ, {
    this.startScale = kStartScaleMin,
  });

  /// The list of [Path] that discribes the current shape.
  List<Path> shape(Size size);

  /// Prefered shape scale for adjusting the size. From `0` to `1`.
  double get shapeScale;

  /// Generate list of [ConfettiShape] based on the provided configuration.
  static List<ConfettiShape> generateShapes(ConfettiGeneratorConfig config) {
    final List<ConfettiShape> shapes = [];

    final Random random = Random();

    double nextRange(double min, double max) {
      return min + (max - min) * random.nextDouble();
    }

    ConfettiShape getShape(int index) {
      final startPosition = Offset(
        nextRange(config.startPositionMinX, config.startPositionMaxX),
        nextRange(config.startPositionMinY, config.startPositionMaxY),
      );
      final velocity = Offset(
        nextRange(config.velocityMinX, config.velocityMaxX),
        nextRange(config.velocityMinY, config.velocityMaxY),
      );
      final scale = nextRange(config.scaleGrowthMin, config.scaleGrowthMax);
      final gradientIndex = random.nextInt(config.gradientColors.length + config.commonGradientAppearance);

      List<Color> gradientColors;

      if (config.gradientColors.length > gradientIndex) {
        gradientColors = config.gradientColors[gradientIndex];
      } else {
        gradientColors = config.mostCommonGradientColors ?? config.gradientColors.first;
      }

      if (config.confettiShapes.length <= index) {
        final shapeConstructor = config.mostCommonConfettiShape ?? config.confettiShapes.first;

        return shapeConstructor(
          startPosition,
          velocity,
          scale,
          gradientColors,
          config.rotationSpeedX,
          config.rotationSpeedY,
          config.rotationSpeedZ,
        );
      }

      return config.confettiShapes[index](
        startPosition,
        velocity,
        scale,
        gradientColors,
        config.rotationSpeedX,
        config.rotationSpeedY,
        config.rotationSpeedZ,
      );
    }

    for (int i = 0; i < config.count; i++) {
      shapes.add(getShape(random.nextInt(config.confettiShapes.length + config.commonShapeAppearance)));
    }

    return shapes;
  }

  /// Paints the shape to the provided [Canvas].
  ///
  /// [Size] - The size of the canvas.
  ///
  /// [Offset] - The offset of the [RenderBox]'s [Canvas].
  ///
  /// [delta] - The frame of the animation. From `0` to `1`.
  ///
  /// [opacity] - The opacity for the particle. From `0` to `1`.
  ///
  /// [shrink] - The shrink amount to apply to the particle's size. From `0` to `1`.
  void paint(Canvas canvas, Size size, Offset offset, double delta, double opacity, double shrink) {
    final scale = startScale * shapeScale + growthScale * delta * shapeScale;
    final position = Offset(startPosition.dx + velocity.dx * delta, startPosition.dy + velocity.dy * delta);

    final Paint paint = Paint()
      ..color = const Color(0xffD9D9D9)
      ..shader = LinearGradient(
              transform: GradientRotation(delta * 2 * pi * scale * 2),
              colors: gradient.map((e) => e.withOpacity(opacity)).toList())
          .createShader(Rect.fromLTWH(position.dx * size.width, position.dy * size.height, size.shortestSide * scale,
              size.shortestSide * scale));

    final shapeSize = size.shortestSide * scale * shrink;
    final rotationMatrix4 = Matrix4.identity()
      ..translate(
        position.dx * size.width - shapeSize / 2 + offset.dx,
        position.dy * size.height - shapeSize / 2 + offset.dy,
      )
      ..rotateX(delta * velocity.dx * rotationSpeedX)
      ..rotateY(delta * velocity.dy * rotationSpeedY)
      ..rotateZ(delta * velocity.dx * velocity.dy * rotationSpeedZ);
    for (final path in shape(Size(shapeSize, shapeSize))) {
      canvas.drawPath(path.transform(rotationMatrix4.storage), paint);
    }
  }
}

/// Base class for all confetti animation shapes which have to be drawen as a stroke.
///
/// Extend from this to create new [StrokeShape].
abstract class StrokeShape extends ConfettiShape {
  /// Stroke width of the shape.
  final double strokeWidth;

  const StrokeShape(
    super.startPosition,
    super.velocity,
    super.growthScale,
    super.gradient,
    super.rotationSpeedX,
    super.rotationSpeedY,
    super.rotationSpeedZ, {
    this.strokeWidth = 4,
  });

  @override
  void paint(Canvas canvas, Size size, Offset offset, double delta, double opacity, double shrink) {
    final scale = startScale * shapeScale + growthScale * delta * shapeScale;
    final position = Offset(startPosition.dx + velocity.dx * delta, startPosition.dy + velocity.dy * delta);

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = strokeWidth
      ..color = const Color(0xffD9D9D9)
      ..shader = LinearGradient(
              transform: GradientRotation(delta * 2 * pi * scale * 2),
              colors: gradient.map((e) => e.withOpacity(opacity)).toList())
          .createShader(Rect.fromLTWH(position.dx * size.width, position.dy * size.height, size.shortestSide * scale,
              size.shortestSide * scale));

    final shapeSize = size.shortestSide * scale * shrink;

    for (final path in shape(Size(shapeSize, shapeSize))) {
      final rotationMatrix4 = Matrix4.identity()
        ..translate(
          position.dx * size.width - shapeSize / 2 + offset.dx,
          position.dy * size.height - shapeSize / 2 + offset.dy,
        )
        ..rotateX(delta * velocity.dx * rotationSpeedX)
        ..rotateY(delta * velocity.dy * rotationSpeedY)
        ..rotateZ(delta * velocity.dx * velocity.dy * rotationSpeedZ);

      canvas.drawPath(path.transform(rotationMatrix4.storage), paint);
    }
  }
}

/// Confetti shape which is used in the [ConfettiAnimation]
class BaladyShape extends ConfettiShape {
  const BaladyShape(
    super.startPosition,
    super.velocity,
    super.growthScale,
    super.gradient,
    super.rotationSpeedX,
    super.rotationSpeedY,
    super.rotationSpeedZ, {
    super.startScale,
  });

  @override
  List<Path> shape(Size size) {
    final List<Path> paths = [];

    var path = Path()
      ..lineTo(size.width * 0.93, size.height * 0.24)
      ..cubicTo(size.width * 0.93, size.height * 0.24, size.width * 0.93, size.height * 0.24, size.width * 0.93,
          size.height * 0.24)
      ..cubicTo(size.width * 0.79, size.height * 0.26, size.width * 0.68, size.height * 0.35, size.width * 0.61,
          size.height * 0.48)
      ..cubicTo(size.width * 0.61, size.height * 0.48, size.width * 0.61, size.height * 0.48, size.width * 0.61,
          size.height * 0.48)
      ..cubicTo(size.width * 0.57, size.height * 0.56, size.width * 0.55, size.height * 0.65, size.width * 0.55,
          size.height * 0.74)
      ..cubicTo(size.width * 0.55, size.height * 0.74, size.width * 0.55, size.height * 0.74, size.width * 0.55,
          size.height * 0.74)
      ..cubicTo(size.width * 0.55, size.height * 0.76, size.width * 0.54, size.height * 0.79, size.width * 0.54,
          size.height * 0.81)
      ..cubicTo(size.width * 0.54, size.height * 0.81, size.width * 0.54, size.height * 0.81, size.width * 0.54,
          size.height * 0.81)
      ..cubicTo(size.width * 0.54, size.height * 0.82, size.width * 0.54, size.height * 0.83, size.width * 0.54,
          size.height * 0.84)
      ..cubicTo(size.width * 0.54, size.height * 0.84, size.width * 0.54, size.height * 0.85, size.width * 0.54,
          size.height * 0.85)
      ..cubicTo(size.width * 0.54, size.height * 0.86, size.width * 0.53, size.height * 0.87, size.width * 0.53,
          size.height * 0.88)
      ..cubicTo(size.width * 0.53, size.height * 0.88, size.width * 0.53, size.height * 0.88, size.width * 0.53,
          size.height * 0.88)
      ..cubicTo(size.width * 0.53, size.height * 0.89, size.width * 0.53, size.height * 0.9, size.width * 0.53,
          size.height * 0.91)
      ..cubicTo(size.width * 0.53, size.height * 0.91, size.width * 0.53, size.height * 0.91, size.width * 0.53,
          size.height * 0.91)
      ..cubicTo(size.width * 0.53, size.height * 0.91, size.width * 0.52, size.height * 0.91, size.width * 0.52,
          size.height * 0.91)
      ..cubicTo(
          size.width * 0.52, size.height * 0.94, size.width * 0.51, size.height * 0.98, size.width * 0.49, size.height)
      ..cubicTo(size.width * 0.49, size.height, size.width * 0.49, size.height, size.width * 0.49, size.height * 1.02)
      ..cubicTo(size.width * 0.47, size.height * 1.06, size.width * 0.45, size.height * 1.09, size.width * 0.43,
          size.height * 1.12)
      ..cubicTo(size.width * 0.44, size.height * 1.14, size.width * 0.46, size.height * 1.16, size.width * 0.47,
          size.height * 1.18)
      ..cubicTo(size.width * 0.48, size.height * 1.2, size.width * 0.49, size.height * 1.21, size.width * 0.49,
          size.height * 1.22)
      ..cubicTo(size.width * 0.51, size.height * 1.19, size.width * 0.53, size.height * 1.16, size.width * 0.55,
          size.height * 1.13)
      ..cubicTo(size.width * 0.55, size.height * 1.13, size.width * 0.55, size.height * 1.13, size.width * 0.55,
          size.height * 1.13)
      ..cubicTo(size.width * 0.55, size.height * 1.13, size.width * 0.56, size.height * 1.12, size.width * 0.56,
          size.height * 1.12)
      ..cubicTo(
          size.width * 0.62, size.height, size.width * 0.65, size.height * 0.87, size.width * 0.65, size.height * 0.74)
      ..cubicTo(size.width * 0.65, size.height * 0.74, size.width * 0.65, size.height * 0.73, size.width * 0.65,
          size.height * 0.73)
      ..cubicTo(size.width * 0.65, size.height * 0.54, size.width * 0.77, size.height * 0.38, size.width * 0.94,
          size.height * 0.35)
      ..cubicTo(size.width * 0.94, size.height * 0.35, size.width * 0.94, size.height * 0.35, size.width * 0.94,
          size.height * 0.35)
      ..cubicTo(
          size.width, size.height * 0.35, size.width * 1.02, size.height / 3, size.width * 0.98, size.height * 0.26)
      ..cubicTo(size.width * 0.97, size.height * 0.24, size.width * 0.95, size.height * 0.23, size.width * 0.93,
          size.height * 0.24);

    paths.add(path);

    path = Path()
      ..lineTo(size.width * 0.93, 0)
      ..cubicTo(size.width * 0.85, size.height * 0.01, size.width * 0.78, size.height * 0.03, size.width * 0.71,
          size.height * 0.07)
      ..cubicTo(size.width * 0.71, size.height * 0.07, size.width * 0.7, size.height * 0.07, size.width * 0.7,
          size.height * 0.07)
      ..cubicTo(size.width * 0.7, size.height * 0.07, size.width * 0.69, size.height * 0.08, size.width * 0.69,
          size.height * 0.08)
      ..cubicTo(size.width * 0.62, size.height * 0.12, size.width * 0.55, size.height * 0.18, size.width * 0.49,
          size.height * 0.26)
      ..cubicTo(size.width * 0.38, size.height * 0.11, size.width * 0.23, size.height * 0.02, size.width * 0.06, 0)
      ..cubicTo(size.width * 0.06, 0, size.width * 0.06, 0, size.width * 0.06, 0)
      ..cubicTo(size.width * 0.06, 0, size.width * 0.05, 0, size.width * 0.05, 0)
      ..cubicTo(-0.02, 0, -0.03, size.height * 0.02, size.width * 0.01, size.height * 0.09)
      ..cubicTo(size.width * 0.02, size.height * 0.11, size.width * 0.03, size.height * 0.12, size.width * 0.05,
          size.height * 0.12)
      ..cubicTo(size.width * 0.05, size.height * 0.12, size.width * 0.05, size.height * 0.12, size.width * 0.05,
          size.height * 0.12)
      ..cubicTo(size.width / 5, size.height * 0.13, size.width * 0.34, size.height * 0.22, size.width * 0.43,
          size.height * 0.36)
      ..cubicTo(size.width * 0.41, size.height * 0.4, size.width * 0.4, size.height * 0.44, size.width * 0.38,
          size.height * 0.48)
      ..cubicTo(size.width * 0.38, size.height * 0.48, size.width * 0.38, size.height * 0.48, size.width * 0.38,
          size.height * 0.48)
      ..cubicTo(size.width * 0.31, size.height * 0.34, size.width * 0.19, size.height / 4, size.width * 0.06,
          size.height * 0.23)
      ..cubicTo(size.width * 0.05, size.height * 0.23, size.width * 0.05, size.height * 0.23, size.width * 0.04,
          size.height * 0.23)
      ..cubicTo(-0.01, size.height / 4, -0.02, size.height * 0.29, size.width * 0.02, size.height / 3)
      ..cubicTo(size.width * 0.03, size.height * 0.34, size.width * 0.04, size.height * 0.35, size.width * 0.05,
          size.height * 0.35)
      ..cubicTo(size.width * 0.05, size.height * 0.35, size.width * 0.05, size.height * 0.35, size.width * 0.05,
          size.height * 0.35)
      ..cubicTo(size.width * 0.18, size.height * 0.37, size.width * 0.28, size.height * 0.47, size.width / 3,
          size.height * 0.61)
      ..cubicTo(
          size.width / 3, size.height * 0.61, size.width / 3, size.height * 0.62, size.width / 3, size.height * 0.62)
      ..cubicTo(size.width * 0.34, size.height * 0.65, size.width * 0.34, size.height * 0.68, size.width * 0.34,
          size.height * 0.71)
      ..cubicTo(size.width * 0.34, size.height * 0.71, size.width * 0.34, size.height * 0.71, size.width * 0.34,
          size.height * 0.71)
      ..cubicTo(size.width * 0.34, size.height * 0.72, size.width * 0.34, size.height * 0.72, size.width * 0.34,
          size.height * 0.73)
      ..cubicTo(size.width * 0.34, size.height * 0.73, size.width * 0.34, size.height * 0.74, size.width * 0.34,
          size.height * 0.74)
      ..cubicTo(
          size.width * 0.34, size.height * 0.83, size.width * 0.35, size.height * 0.92, size.width * 0.38, size.height)
      ..cubicTo(size.width * 0.38, size.height, size.width * 0.38, size.height, size.width * 0.38, size.height)
      ..cubicTo(size.width * 0.38, size.height, size.width * 0.39, size.height, size.width * 0.39, size.height)
      ..cubicTo(size.width * 0.39, size.height, size.width * 0.39, size.height, size.width * 0.39, size.height)
      ..cubicTo(size.width * 0.42, size.height * 0.92, size.width * 0.44, size.height * 0.85, size.width * 0.45,
          size.height * 0.78)
      ..cubicTo(size.width * 0.44, size.height * 0.76, size.width * 0.44, size.height * 0.75, size.width * 0.44,
          size.height * 0.73)
      ..cubicTo(size.width * 0.44, size.height * 0.73, size.width * 0.44, size.height * 0.72, size.width * 0.44,
          size.height * 0.71)
      ..cubicTo(size.width * 0.44, size.height * 0.71, size.width * 0.44, size.height * 0.71, size.width * 0.44,
          size.height * 0.71)
      ..cubicTo(size.width * 0.44, size.height * 0.71, size.width * 0.44, size.height * 0.7, size.width * 0.44,
          size.height * 0.7)
      ..cubicTo(size.width * 0.45, size.height * 0.62, size.width * 0.47, size.height * 0.54, size.width * 0.49,
          size.height * 0.47)
      ..cubicTo(
          size.width * 0.49, size.height * 0.47, size.width / 2, size.height * 0.47, size.width / 2, size.height * 0.47)
      ..cubicTo(size.width * 0.51, size.height * 0.43, size.width * 0.53, size.height * 0.39, size.width * 0.56,
          size.height * 0.35)
      ..cubicTo(size.width * 0.61, size.height * 0.28, size.width * 0.67, size.height * 0.22, size.width * 0.74,
          size.height * 0.18)
      ..cubicTo(size.width * 0.74, size.height * 0.18, size.width * 0.75, size.height * 0.18, size.width * 0.75,
          size.height * 0.17)
      ..cubicTo(size.width * 0.75, size.height * 0.17, size.width * 0.76, size.height * 0.17, size.width * 0.76,
          size.height * 0.17)
      ..cubicTo(size.width * 0.82, size.height * 0.14, size.width * 0.88, size.height * 0.12, size.width * 0.94,
          size.height * 0.12)
      ..cubicTo(size.width * 0.97, size.height * 0.12, size.width, size.height * 0.09, size.width, size.height * 0.06)
      ..cubicTo(size.width, size.height * 0.03, size.width * 0.97, 0, size.width * 0.94, 0)
      ..cubicTo(size.width * 0.94, 0, size.width * 0.93, 0, size.width * 0.93, 0)
      ..cubicTo(size.width * 0.93, 0, size.width * 0.93, 0, size.width * 0.93, 0)
      ..cubicTo(size.width * 0.93, 0, size.width * 0.93, 0, size.width * 0.93, 0);

    paths.add(path);
    return paths;
  }

  @override
  double get shapeScale => 1.1;
}

/// Confetti shape which is used in the [ConfettiAnimation]
class DiamondShape extends ConfettiShape {
  const DiamondShape(
    super.startPosition,
    super.velocity,
    super.growthScale,
    super.gradient,
    super.rotationSpeedX,
    super.rotationSpeedY,
    super.rotationSpeedZ, {
    super.startScale,
  });

  @override
  List<Path> shape(Size size) {
    final path = Path()
      ..lineTo(size.width * 0.48, 0)
      ..cubicTo(size.width * 0.48, 0, 0, size.height, 0, size.height)
      ..cubicTo(0, size.height, size.width * 0.55, size.height, size.width * 0.55, size.height)
      ..cubicTo(size.width * 0.55, size.height, size.width, 0, size.width, 0)
      ..cubicTo(size.width, 0, size.width * 0.48, 0, size.width * 0.48, 0)
      ..cubicTo(size.width * 0.48, 0, size.width * 0.48, 0, size.width * 0.48, 0);

    return [path];
  }

  @override
  double get shapeScale => 0.8;
}

/// Confetti shape which is used in the [ConfettiAnimation]
class TrapezoidShape extends ConfettiShape {
  const TrapezoidShape(
    super.startPosition,
    super.velocity,
    super.growthScale,
    super.gradient,
    super.rotationSpeedX,
    super.rotationSpeedY,
    super.rotationSpeedZ, {
    super.startScale,
  });

  @override
  List<Path> shape(Size size) {
    final path = Path()
      ..lineTo(size.width * 0.77, size.height * 0.39)
      ..cubicTo(size.width * 0.77, size.height * 0.39, size.width * 0.01, size.height * 0.02, size.width * 0.01,
          size.height * 0.02)
      ..cubicTo(size.width * 0.01, size.height * 0.02, size.width * 0.39, size.height * 1.02, size.width * 0.39,
          size.height * 1.02)
      ..cubicTo(size.width * 0.39, size.height * 1.02, size.width, size.height * 1.02, size.width, size.height * 1.02)
      ..cubicTo(
          size.width, size.height * 1.02, size.width * 0.77, size.height * 0.39, size.width * 0.77, size.height * 0.39)
      ..cubicTo(size.width * 0.77, size.height * 0.39, size.width * 0.77, size.height * 0.39, size.width * 0.77,
          size.height * 0.39);

    return [path];
  }

  @override
  double get shapeScale => 0.75;
}

/// Confetti shape which is used in the [ConfettiAnimation]
class FlagRectangularShape extends ConfettiShape {
  const FlagRectangularShape(
    super.startPosition,
    super.velocity,
    super.growthScale,
    super.gradient,
    super.rotationSpeedX,
    super.rotationSpeedY,
    super.rotationSpeedZ, {
    super.startScale,
  });

  @override
  List<Path> shape(Size size) {
    final path = Path()
      ..lineTo(size.width * 0.63, size.height)
      ..cubicTo(size.width * 0.44, size.height * 0.7, size.width * 0.13, size.height * 0.6, 0, size.height * 0.59)
      ..cubicTo(0, size.height * 0.59, size.width * 0.41, 0, size.width * 0.41, 0)
      ..cubicTo(size.width * 0.9, size.height * 0.17, size.width, size.height * 0.36, size.width, size.height * 0.43)
      ..cubicTo(size.width, size.height * 0.43, size.width * 0.63, size.height, size.width * 0.63, size.height)
      ..cubicTo(size.width * 0.63, size.height, size.width * 0.63, size.height, size.width * 0.63, size.height);

    return [path];
  }

  @override
  double get shapeScale => 0.7;
}

/// Confetti shape which is used in the [ConfettiAnimation]
class SmoothParallelogramShape extends ConfettiShape {
  const SmoothParallelogramShape(
    super.startPosition,
    super.velocity,
    super.growthScale,
    super.gradient,
    super.rotationSpeedX,
    super.rotationSpeedY,
    super.rotationSpeedZ, {
    super.startScale,
  });

  @override
  List<Path> shape(Size size) {
    final path = Path()
      ..lineTo(size.width * 0.47, size.height * 0.14)
      ..cubicTo(size.width * 0.47, size.height * 0.14, size.width * 0.01, size.height * 0.01, size.width * 0.01,
          size.height * 0.01)
      ..cubicTo(size.width * 0.16, size.height / 3, size.width * 0.42, size.height * 0.72, size.width * 0.53,
          size.height * 0.87)
      ..cubicTo(size.width * 0.53, size.height * 0.87, size.width, size.height, size.width, size.height)
      ..cubicTo(size.width * 0.86, size.height * 0.9, size.width * 0.59, size.height * 0.38, size.width * 0.47,
          size.height * 0.14)
      ..cubicTo(size.width * 0.47, size.height * 0.14, size.width * 0.47, size.height * 0.14, size.width * 0.47,
          size.height * 0.14);

    return [path];
  }

  @override
  double get shapeScale => 0.75;
}

/// Confetti shape which is used in the [ConfettiAnimation]
class ArcShape extends ConfettiShape {
  const ArcShape(
    super.startPosition,
    super.velocity,
    super.growthScale,
    super.gradient,
    super.rotationSpeedX,
    super.rotationSpeedY,
    super.rotationSpeedZ, {
    super.startScale,
  });

  @override
  List<Path> shape(Size size) {
    final path = Path()
      ..lineTo(size.width * 0.01, size.height * 0.54)
      ..cubicTo(size.width * 0.03, size.height * 0.34, size.width * 0.29, size.height * 0.15, size.width * 0.94, 0)
      ..cubicTo(size.width * 0.94, 0, size.width, size.height * 0.11, size.width, size.height * 0.11)
      ..cubicTo(
          size.width * 0.39, size.height / 4, size.width * 0.22, size.height * 0.42, size.width / 5, size.height * 0.55)
      ..cubicTo(size.width * 0.19, size.height * 0.69, size.width * 0.35, size.height * 0.83, size.width * 0.51,
          size.height * 0.92)
      ..cubicTo(size.width * 0.51, size.height * 0.92, size.width * 0.39, size.height, size.width * 0.39, size.height)
      ..cubicTo(size.width / 5, size.height * 0.91, -0.01, size.height * 0.74, size.width * 0.01, size.height * 0.54)
      ..cubicTo(size.width * 0.01, size.height * 0.54, size.width * 0.01, size.height * 0.54, size.width * 0.01,
          size.height * 0.54);

    return [path];
  }

  @override
  double get shapeScale => 0.86;
}

/// Confetti stroke shape which is used in the [ConfettiAnimation]
class CircleShape extends StrokeShape {
  const CircleShape(
    super.startPosition,
    super.velocity,
    super.growthScale,
    super.gradient,
    super.rotationSpeedX,
    super.rotationSpeedY,
    super.rotationSpeedZ, {
    super.strokeWidth,
  });

  @override
  List<Path> shape(Size size) {
    final path = Path()
      ..moveTo(size.width * 1.17, size.height * 0.67)
      ..cubicTo(size.width * 1.17, size.height * 0.94, size.width * 0.94, size.height * 1.17, size.width * 0.67,
          size.height * 1.17)
      ..cubicTo(size.width * 0.39, size.height * 1.17, size.width * 0.17, size.height * 0.94, size.width * 0.17,
          size.height * 0.67)
      ..cubicTo(size.width * 0.17, size.height * 0.39, size.width * 0.39, size.height * 0.17, size.width * 0.67,
          size.height * 0.17)
      ..cubicTo(size.width * 0.94, size.height * 0.17, size.width * 1.17, size.height * 0.39, size.width * 1.17,
          size.height * 0.67);

    return [path];
  }

  @override
  double get shapeScale => 0.7;
}

/// Confetti stroke shape which is used in the [ConfettiAnimation]
class ShiningShape extends StrokeShape {
  const ShiningShape(
    super.startPosition,
    super.velocity,
    super.growthScale,
    super.gradient,
    super.rotationSpeedX,
    super.rotationSpeedY,
    super.rotationSpeedZ, {
    super.strokeWidth,
  });

  @override
  List<Path> shape(Size size) {
    final path = Path()
      ..moveTo(size.width / 2, size.height)
      ..cubicTo(size.width / 2, size.height * 0.79, size.width * 0.64, size.height * 0.59, size.width * 0.85,
          size.height * 0.52)
      ..cubicTo(size.width * 0.9, size.height * 0.51, size.width * 0.95, size.height / 2, size.width, size.height / 2)
      ..moveTo(size.width, size.height / 2)
      ..cubicTo(size.width * 0.79, size.height / 2, size.width * 0.59, size.height * 0.36, size.width * 0.52,
          size.height * 0.15)
      ..cubicTo(size.width * 0.51, size.height * 0.11, size.width / 2, size.height * 0.05, size.width / 2, 0)
      ..moveTo(size.width / 2, size.height)
      ..cubicTo(size.width / 2, size.height * 0.79, size.width * 0.36, size.height * 0.59, size.width * 0.15,
          size.height * 0.52)
      ..cubicTo(size.width * 0.1, size.height * 0.51, size.width * 0.05, size.height / 2, 0, size.height / 2)
      ..moveTo(size.width / 2, 0)
      ..cubicTo(
          size.width / 2, size.height * 0.09, size.width * 0.48, size.height * 0.17, size.width * 0.44, size.height / 4)
      ..cubicTo(size.width * 0.37, size.height * 0.35, size.width * 0.27, size.height * 0.44, size.width * 0.15,
          size.height * 0.48)
      ..cubicTo(size.width * 0.1, size.height * 0.49, size.width * 0.05, size.height / 2, 0, size.height / 2);
    return [path];
  }

  @override
  double get shapeScale => 0.9;
}

/// Confetti stroke shape which is used in the [ConfettiAnimation]
class RombShape extends StrokeShape {
  const RombShape(
    super.startPosition,
    super.velocity,
    super.growthScale,
    super.gradient,
    super.rotationSpeedX,
    super.rotationSpeedY,
    super.rotationSpeedZ, {
    super.strokeWidth,
  });

  @override
  List<Path> shape(Size size) {
    final path = Path()
      ..moveTo(size.width / 3, size.height * 0.64)
      ..cubicTo(
          size.width / 3, size.height * 0.64, size.width * 0.64, size.height / 3, size.width * 0.64, size.height / 3)
      ..cubicTo(
          size.width * 0.71, size.height / 4, size.width * 0.83, size.height / 4, size.width * 0.91, size.height / 3)
      ..cubicTo(size.width * 0.91, size.height / 3, size.width * 1.22, size.height * 0.64, size.width * 1.22,
          size.height * 0.64)
      ..cubicTo(size.width * 1.29, size.height * 0.71, size.width * 1.29, size.height * 0.83, size.width * 1.22,
          size.height * 0.91)
      ..cubicTo(size.width * 1.22, size.height * 0.91, size.width * 0.91, size.height * 1.22, size.width * 0.91,
          size.height * 1.22)
      ..cubicTo(size.width * 0.83, size.height * 1.29, size.width * 0.71, size.height * 1.29, size.width * 0.64,
          size.height * 1.22)
      ..cubicTo(
          size.width * 0.64, size.height * 1.22, size.width / 3, size.height * 0.91, size.width / 3, size.height * 0.91)
      ..cubicTo(
          size.width / 4, size.height * 0.83, size.width / 4, size.height * 0.71, size.width / 3, size.height * 0.64)
      ..cubicTo(
          size.width / 3, size.height * 0.64, size.width / 3, size.height * 0.64, size.width / 3, size.height * 0.64);

    return [path];
  }

  @override
  double get shapeScale => 0.7;
}
