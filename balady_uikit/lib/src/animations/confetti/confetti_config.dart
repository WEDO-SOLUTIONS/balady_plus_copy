import 'package:balady_uikit/src/animations/confetti/confetti_shape.dart';
import 'package:flutter/material.dart';

enum ConfettiDisappearBehavior { fade, shrink, both }

typedef ConfettiShapeConstructor = ConfettiShape Function(
    Offset startPosition, Offset velocity, double scale, List<Color> gradient, double, double, double);

const int kGradientAppearance = 5;
const int kShapesAppearance = 6;

const int kConfettiCount = 120;
const Duration kAnimationDuration = Duration(seconds: 2, milliseconds: 500);

const Curve kAnimationCurve = Curves.easeOutQuint;

const double kRotationSpeed = 10;

const double kStartScaleMin = 0.01;
const double kStartPositionMinX = 0.49;
const double kStartPositionMaxX = 0.51;

const double kStartPositionMinY = 0.48;
const double kStartPositionMaxY = 0.52;

const double kVelocityMinX = -1.5;
const double kVelocityMaxX = 1.5;
const double kVelocityMinY = -1.0;
const double kVelocityMaxY = 0.8;

const double kScaleGrowthMin = 0.1;
const double kScaleGrowthMax = 0.3;

const double kDissappearStartsAt = 0.6;

const kCommonGradient = [
  Color(0xff198FE7),
  Color(0xff29FAE4),
  Color(0xff4BFAE8),
  Color(0xffE8F8F8),
  Color(0xffEFE196),
  Color(0xffF8A2CF),
  Color(0xffCB6DBE),
];

const kConfettiGradientList = [
  [
    Color(0xffAB47E5),
    Color(0xffF951C3),
    Color(0xffF79BD4),
    Color(0xffF5CCDF),
    Color(0xffF5E4E5),
    Color(0xffF5E7E6),
    Color(0xff8345CA),
    Color(0xffCB6DBE),
  ],
  [
    Color(0xff5BBB59),
    Color(0xff59B85D),
    Color(0xff55AF6C),
    Color(0xff4EA183),
    Color(0xff448EA4),
    Color(0xff3C7EC1),
    Color(0xff3C7EC1),
  ],
];

/// Config which is used to generate confetti particles and playing animation.
///
/// Use factory constructor [ConfettiGeneratorConfig.confetti] to create default configuration.
class ConfettiGeneratorConfig {
  /// Count of particles that will be generated
  final int count;

  /// Duration of confetti animation
  final Duration animationDuration;

  /// Curve of confetti animation
  final Curve animationCurve;

  /// Acceleration of particle rotation on X axis. From Left to Right.
  final double rotationSpeedX;

  /// Acceleration of particle rotation on Y axis. From Top to Bottom.
  final double rotationSpeedY;

  /// Acceleration of particle rotation on Z axis. Clockwise rotation.
  final double rotationSpeedZ;

  /// Scale of the particle at the start of animation
  final double startScaleMin;

  /// Minimum position on X axis, used to generate random position.
  final double startPositionMinX;

  /// Max position on X axis, used to generate random position.
  final double startPositionMaxX;

  /// Minimum position on Y axis, used to generate random position.
  final double startPositionMinY;

  /// Max position on Y axis, used to generate random position.
  final double startPositionMaxY;

  /// Minimum velocity on X axis, used to generate random velocity.
  final double velocityMinX;

  /// Max velocity on X axis, used to generate random velocity.
  final double velocityMaxX;

  /// Minimum velocity on Y axis, used to generate random velocity.
  final double velocityMinY;

  /// Max velocity on Y axis, used to generate random velocity.
  final double velocityMaxY;

  /// Minimum growth value, used to generate random scale growth which will be applied to particle scale.
  final double scaleGrowthMin;

  /// Max growth value, used to generate random scale growth which will be applied to particle scale.
  final double scaleGrowthMax;

  /// List of Gradients that will be randomly selected and used in gradient shader.
  final List<List<Color>> gradientColors;

  /// List of Colors that will be most commonly used in gradient shader.
  final List<Color>? mostCommonGradientColors;

  /// List of Confetti shapes constructor functions
  final List<ConfettiShapeConstructor> confettiShapes;

  /// Confetti shapes constructor function that will appear more commonly
  final ConfettiShapeConstructor? mostCommonConfettiShape;

  /// How much other common gradient will be used for generating shapes
  final int commonGradientAppearance;

  /// How much other common shape will be used for generating shapes
  final int commonShapeAppearance;

  /// Behaviour of the particle disappearing at the end of the animation
  final ConfettiDisappearBehavior disappearBehavior;

  /// Curve of the particle disappearing animation at the end of the confetti animation
  final Curve disappearCurve;

  /// Start of the disappearing animation from `0` to `1`.
  final double disappearStartsAt;

  const ConfettiGeneratorConfig({
    required this.animationCurve,
    required this.mostCommonConfettiShape,
    required this.commonGradientAppearance,
    required this.commonShapeAppearance,
    required this.count,
    required this.animationDuration,
    required this.startScaleMin,
    required this.startPositionMinX,
    required this.startPositionMaxX,
    required this.startPositionMinY,
    required this.startPositionMaxY,
    required this.velocityMinX,
    required this.velocityMaxX,
    required this.velocityMinY,
    required this.velocityMaxY,
    required this.scaleGrowthMin,
    required this.scaleGrowthMax,
    required this.gradientColors,
    required this.mostCommonGradientColors,
    required this.confettiShapes,
    required this.disappearStartsAt,
    required this.rotationSpeedX,
    required this.rotationSpeedY,
    required this.rotationSpeedZ,
    this.disappearBehavior = ConfettiDisappearBehavior.both,
    this.disappearCurve = Curves.easeOutQuint,
  });

  factory ConfettiGeneratorConfig.confetti({
    int? count,
    Duration? animationDuration,
    Curve? animationCurve,
    double? startScaleMin,
    double? startPositionMinX,
    double? startPositionMaxX,
    double? startPositionMinY,
    double? startPositionMaxY,
    double? velocityMinX,
    double? velocityMaxX,
    double? velocityMinY,
    double? velocityMaxY,
    double? scaleGrowthMin,
    double? scaleGrowthMax,
    double? rotationSpeedX,
    double? rotationSpeedY,
    double? rotationSpeedZ,
    List<List<Color>>? gradientColors,
    List<Color>? mostCommonGradientColors,
    List<ConfettiShapeConstructor>? confettiShapes,
    ConfettiShapeConstructor? mostCommonConfettiShape,
    int? commonGradientAppearance,
    int? commonShapeAppearance,
    ConfettiDisappearBehavior? disappearBehavior,
    Curve? dissappearCurve,
    double? dissappearStartsAt,
  }) {
    return ConfettiGeneratorConfig(
      count: count ?? kConfettiCount,
      startScaleMin: kStartScaleMin,
      startPositionMinX: startPositionMinX ?? kStartPositionMinX,
      startPositionMaxX: startPositionMaxX ?? kStartPositionMaxX,
      startPositionMinY: startPositionMinY ?? kStartPositionMinY,
      startPositionMaxY: startPositionMaxY ?? kStartPositionMaxY,
      velocityMinX: velocityMinX ?? kVelocityMinX,
      velocityMaxX: velocityMaxX ?? kVelocityMaxX,
      velocityMinY: velocityMinY ?? kVelocityMinY,
      velocityMaxY: velocityMaxY ?? kVelocityMaxY,
      scaleGrowthMin: scaleGrowthMin ?? kScaleGrowthMin,
      scaleGrowthMax: scaleGrowthMax ?? kScaleGrowthMax,
      gradientColors: gradientColors ?? kConfettiGradientList,
      mostCommonConfettiShape: mostCommonConfettiShape ??
          (startPosition, velocity, scale, gradient, x, y, z) => BaladyShape(
              startPosition, velocity, scale, gradient, x, y, z,
              startScale: startScaleMin ?? kStartScaleMin),
      commonGradientAppearance: commonGradientAppearance ?? kGradientAppearance,
      commonShapeAppearance: commonShapeAppearance ?? kShapesAppearance,
      mostCommonGradientColors: mostCommonGradientColors ?? kCommonGradient,
      confettiShapes: confettiShapes ??
          [
            (startPosition, velocity, scale, gradient, x, y, z) => DiamondShape(
                startPosition, velocity, scale, gradient, x, y, z,
                startScale: startScaleMin ?? kStartScaleMin),
            (startPosition, velocity, scale, gradient, x, y, z) => TrapezoidShape(
                startPosition, velocity, scale, gradient, x, y, z,
                startScale: startScaleMin ?? kStartScaleMin),
            (startPosition, velocity, scale, gradient, x, y, z) => FlagRectangularShape(
                startPosition, velocity, scale, gradient, x, y, z,
                startScale: startScaleMin ?? kStartScaleMin),
            (startPosition, velocity, scale, gradient, x, y, z) => SmoothParallelogramShape(
                startPosition, velocity, scale, gradient, x, y, z,
                startScale: startScaleMin ?? kStartScaleMin),
            (startPosition, velocity, scale, gradient, x, y, z) => ArcShape(
                startPosition, velocity, scale, gradient, x, y, z,
                startScale: startScaleMin ?? kStartScaleMin),
          ],
      disappearStartsAt: dissappearStartsAt ?? kDissappearStartsAt,
      disappearBehavior: disappearBehavior ?? ConfettiDisappearBehavior.fade,
      disappearCurve: dissappearCurve ?? Curves.easeOutExpo,
      animationDuration: animationDuration ?? kAnimationDuration,
      animationCurve: animationCurve ?? kAnimationCurve,
      rotationSpeedX: rotationSpeedX ?? kRotationSpeed,
      rotationSpeedY: rotationSpeedY ?? kRotationSpeed,
      rotationSpeedZ: rotationSpeedZ ?? kRotationSpeed,
    );
  }

  ConfettiGeneratorConfig copyWith(
    int? count,
    Duration? animationDuration,
    Curve? animationCurve,
    double? startScaleMin,
    double? startPositionMinX,
    double? startPositionMaxX,
    double? startPositionMinY,
    double? startPositionMaxY,
    double? velocityMinX,
    double? velocityMaxX,
    double? velocityMinY,
    double? velocityMaxY,
    double? scaleGrowthMin,
    double? scaleGrowthMax,
    double? rotationSpeedX,
    double? rotationSpeedY,
    double? rotationSpeedZ,
    List<List<Color>>? gradientColors,
    List<Color>? mostCommonGradientColors,
    List<ConfettiShapeConstructor>? confettiShapes,
    ConfettiShapeConstructor? mostCommonConfettiShape,
    int? commonGradientAppearance,
    int? commonShapeAppearance,
    ConfettiDisappearBehavior? disappearBehavior,
    Curve? disappearCurve,
    double? disappearStartsAt,
  ) {
    return ConfettiGeneratorConfig(
      mostCommonConfettiShape: mostCommonConfettiShape ?? this.mostCommonConfettiShape,
      commonGradientAppearance: commonGradientAppearance ?? this.commonGradientAppearance,
      commonShapeAppearance: commonShapeAppearance ?? this.commonShapeAppearance,
      count: count ?? this.count,
      startScaleMin: startScaleMin ?? this.startScaleMin,
      startPositionMinX: startPositionMinX ?? this.startPositionMinX,
      startPositionMaxX: startPositionMaxX ?? this.startPositionMaxX,
      startPositionMinY: startPositionMinY ?? this.startPositionMinY,
      startPositionMaxY: startPositionMaxY ?? this.startPositionMaxY,
      velocityMinX: velocityMinX ?? this.velocityMinX,
      velocityMaxX: velocityMaxX ?? this.velocityMaxX,
      velocityMinY: velocityMinY ?? this.velocityMinY,
      velocityMaxY: velocityMaxY ?? this.velocityMaxY,
      scaleGrowthMin: scaleGrowthMin ?? this.scaleGrowthMin,
      scaleGrowthMax: scaleGrowthMax ?? this.scaleGrowthMax,
      gradientColors: gradientColors ?? this.gradientColors,
      mostCommonGradientColors: mostCommonGradientColors ?? this.mostCommonGradientColors,
      confettiShapes: confettiShapes ?? this.confettiShapes,
      disappearStartsAt: disappearStartsAt ?? this.disappearStartsAt,
      disappearCurve: disappearCurve ?? this.disappearCurve,
      disappearBehavior: disappearBehavior ?? this.disappearBehavior,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
      rotationSpeedX: rotationSpeedX ?? this.rotationSpeedX,
      rotationSpeedY: rotationSpeedY ?? this.rotationSpeedY,
      rotationSpeedZ: rotationSpeedZ ?? this.rotationSpeedZ,
    );
  }
}
