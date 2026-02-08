import 'package:balady_uikit/balady_uikit.dart';
import 'package:example/widgetbook_app/use_cases/confetti_animation/dealog_demo.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: '100. Confetti animation',
  type: Widget,
)
Widget confetti(BuildContext context) {
  Curve getCurve(String name) {
    return switch (name) {
      'bounceIn' => Curves.bounceIn,
      'bounceOut' => Curves.bounceOut,
      'bounceInOut' => Curves.bounceInOut,
      'decelerate' => Curves.decelerate,
      'ease' => Curves.ease,
      'easeIn' => Curves.easeIn,
      'easeInBack' => Curves.easeInBack,
      'easeInCirc' => Curves.easeInCirc,
      'easeInCubic' => Curves.easeInCubic,
      'easeInExpo' => Curves.easeInExpo,
      'easeInQuad' => Curves.easeInQuad,
      'easeInQuart' => Curves.easeInQuart,
      'easeInQuint' => Curves.easeInQuint,
      'easeInSine' => Curves.easeInSine,
      'easeInToLinear' => Curves.easeInToLinear,
      'easeInOut' => Curves.easeInOut,
      'easeInOutBack' => Curves.easeInOutBack,
      'easeInOutCirc' => Curves.easeInOutCirc,
      'easeInOutCubic' => Curves.easeInOutCubic,
      'easeInOutCubicEmphasized' => Curves.easeInOutCubicEmphasized,
      'easeInOutExpo' => Curves.easeInOutExpo,
      'easeInOutQuad' => Curves.easeInOutQuad,
      'easeInOutQuart' => Curves.easeInOutQuart,
      'easeInOutSine' => Curves.easeInOutSine,
      'easeOut' => Curves.easeOut,
      'easeOutBack' => Curves.easeOutBack,
      'easeOutCirc' => Curves.easeOutCirc,
      'easeOutCubic' => Curves.easeOutCubic,
      'easeOutExpo' => Curves.easeOutExpo,
      'easeOutQuad' => Curves.easeOutQuad,
      'easeOutQuart' => Curves.easeOutQuart,
      'easeOutSine' => Curves.easeOutSine,
      'elasticIn' => Curves.elasticIn,
      'elasticInOut' => Curves.elasticInOut,
      'elasticOut' => Curves.elasticOut,
      'fastEaseInToSlowEaseOut' => Curves.fastEaseInToSlowEaseOut,
      'fastLinearToSlowEaseIn' => Curves.fastLinearToSlowEaseIn,
      'fastOutSlowIn' => Curves.fastOutSlowIn,
      'linear' => Curves.linear,
      'linearToEaseOut' => Curves.linearToEaseOut,
      'slowMiddle' => Curves.slowMiddle,
      _ => Curves.easeOutQuint
    };
  }

  final showDialog = context.knobs.boolean(label: 'show dialog');

  final count = context.knobs.int.input(label: 'Count', initialValue: kConfettiCount);

  final duration =
      context.knobs.int.input(label: 'Duration in miliseconds', initialValue: kAnimationDuration.inMilliseconds);

  final animationCurve = context.knobs.list(
    label: 'Particles animation curve',
    options: [
      'bounceIn',
      'bounceOut',
      'bounceInOut',
      'decelerate',
      'ease',
      'easeIn',
      'easeInBack',
      'easeInCirc',
      'easeInCubic',
      'easeInExpo',
      'easeInQuad',
      'easeInQuart',
      'easeInQuint',
      'easeInSine',
      'easeInToLinear',
      'easeInOut',
      'easeInOutBack',
      'easeInOutCirc',
      'easeInOutCubic',
      'easeInOutCubicEmphasized',
      'easeInOutExpo',
      'easeInOutQuad',
      'easeInOutQuart',
      'easeInOutSine',
      'easeOut',
      'easeOutBack',
      'easeOutCirc',
      'easeOutCubic',
      'easeOutExpo',
      'easeOutQuad',
      'easeOutQuart',
      'easeOutQuint',
      'easeOutSine',
      'elasticIn',
      'elasticInOut',
      'elasticOut',
      'fastEaseInToSlowEaseOut',
      'fastLinearToSlowEaseIn',
      'fastOutSlowIn',
      'linear',
      'linearToEaseOut',
      'slowMiddle',
    ],
    initialOption: 'easeOutQuint',
  );

  final rotationX = context.knobs.double.slider(
    label: 'Rotation speed X',
    initialValue: kRotationSpeed,
    max: 100,
  );
  final rotationY = context.knobs.double.slider(
    label: 'Rotation speed Y',
    initialValue: kRotationSpeed,
    max: 100,
  );
  final rotationZ = context.knobs.double.slider(
    label: 'Rotation speed Z',
    initialValue: kRotationSpeed,
    max: 100,
  );

  final startScaleMin = context.knobs.double.slider(
    label: 'Start scale',
    initialValue: kStartScaleMin,
    max: 1,
  );
  final startPositionMinX = context.knobs.double.slider(
    label: 'Start position min X',
    initialValue: kStartPositionMinX,
    max: 1,
  );
  final startPositionMaxX = context.knobs.double.slider(
    label: 'Start position max X',
    initialValue: kStartPositionMaxX,
    max: 1,
  );
  final startPositionMinY = context.knobs.double.slider(
    label: 'Start position min Y',
    initialValue: kStartPositionMinY,
    max: 1,
  );
  final startPositionMaxY = context.knobs.double.slider(
    label: 'Start position max Y',
    initialValue: kStartPositionMaxY,
    max: 1,
  );

  final velocityMinX = context.knobs.double.slider(
    label: 'Velocity min X',
    initialValue: kVelocityMinX,
    min: -5,
    max: 5,
  );
  final velocityMaxX = context.knobs.double.slider(
    label: 'Velocity max X',
    initialValue: kVelocityMaxX,
    min: -5,
    max: 5,
  );

  final velocityMinY = context.knobs.double.slider(
    label: 'Velocity min Y',
    initialValue: kVelocityMinY,
    min: -5,
    max: 5,
  );
  final velocityMaxY = context.knobs.double.slider(
    label: 'Velocity max Y',
    initialValue: kVelocityMaxY,
    min: -5,
    max: 5,
  );

  final scaleGrowthMin = context.knobs.double.slider(
    label: 'Scale growth min',
    initialValue: kScaleGrowthMin,
    max: 1,
  );
  final scaleGrowthMax = context.knobs.double.slider(
    label: 'Scale growth max',
    initialValue: kScaleGrowthMax,
    max: 1,
  );

  final disappearStartsAt = context.knobs.double.slider(
    label: 'Particles disappear at',
    initialValue: kScaleGrowthMax,
    max: 2,
  );

  final disappearBehavior = context.knobs.list(
    label: 'Particles disappear behavior',
    options: [ConfettiDisappearBehavior.fade, ConfettiDisappearBehavior.shrink, ConfettiDisappearBehavior.both],
    initialOption: ConfettiDisappearBehavior.fade,
  );

  final disappearCurve = context.knobs.list(
    label: 'Particles disappear curve',
    options: [
      'bounceIn',
      'bounceOut',
      'bounceInOut',
      'decelerate',
      'ease',
      'easeIn',
      'easeInBack',
      'easeInCirc',
      'easeInCubic',
      'easeInExpo',
      'easeInQuad',
      'easeInQuart',
      'easeInQuint',
      'easeInSine',
      'easeInToLinear',
      'easeInOut',
      'easeInOutBack',
      'easeInOutCirc',
      'easeInOutCubic',
      'easeInOutCubicEmphasized',
      'easeInOutExpo',
      'easeInOutQuad',
      'easeInOutQuart',
      'easeInOutSine',
      'easeOut',
      'easeOutBack',
      'easeOutCirc',
      'easeOutCubic',
      'easeOutExpo',
      'easeOutQuad',
      'easeOutQuart',
      'easeOutQuint',
      'easeOutSine',
      'elasticIn',
      'elasticInOut',
      'elasticOut',
      'fastEaseInToSlowEaseOut',
      'fastLinearToSlowEaseIn',
      'fastOutSlowIn',
      'linear',
      'linearToEaseOut',
      'slowMiddle',
    ],
    initialOption: 'easeOutQuint',
  );
  final shape1 = context.knobs.list(
    label: 'Shape 1 in list',
    options: [
      BaladyShape,
      DiamondShape,
      FlagRectangularShape,
      SmoothParallelogramShape,
      TrapezoidShape,
      ArcShape,
      CircleShape,
      ShiningShape,
      RombShape,
    ],
    initialOption: DiamondShape,
  );
  final shape2 = context.knobs.listOrNull(
    label: 'Shape 2 in list',
    options: [
      BaladyShape,
      DiamondShape,
      FlagRectangularShape,
      SmoothParallelogramShape,
      TrapezoidShape,
      ArcShape,
      CircleShape,
      ShiningShape,
      RombShape,
    ],
    initialOption: FlagRectangularShape,
  );
  final shape3 = context.knobs.listOrNull(
    label: 'Shape 3 in list',
    options: [
      BaladyShape,
      DiamondShape,
      FlagRectangularShape,
      SmoothParallelogramShape,
      TrapezoidShape,
      ArcShape,
      CircleShape,
      ShiningShape,
      RombShape,
    ],
    initialOption: SmoothParallelogramShape,
  );
  final shape4 = context.knobs.listOrNull(
    label: 'Shape 4 in list',
    options: [
      BaladyShape,
      DiamondShape,
      FlagRectangularShape,
      SmoothParallelogramShape,
      TrapezoidShape,
      ArcShape,
      CircleShape,
      ShiningShape,
      RombShape,
    ],
    initialOption: TrapezoidShape,
  );
  final shape5 = context.knobs.listOrNull(
    label: 'Shape 5 in list',
    options: [
      BaladyShape,
      DiamondShape,
      FlagRectangularShape,
      SmoothParallelogramShape,
      TrapezoidShape,
      ArcShape,
      CircleShape,
      ShiningShape,
      RombShape,
    ],
    initialOption: ArcShape,
  );
  final shape6 = context.knobs.listOrNull(
    label: 'Shape 6 in list',
    options: [
      BaladyShape,
      DiamondShape,
      FlagRectangularShape,
      SmoothParallelogramShape,
      TrapezoidShape,
      ArcShape,
      CircleShape,
      ShiningShape,
      RombShape,
    ],
    initialOption: null,
  );
  final shape7 = context.knobs.listOrNull(
    label: 'Shape 7 in list',
    options: [
      BaladyShape,
      DiamondShape,
      FlagRectangularShape,
      SmoothParallelogramShape,
      TrapezoidShape,
      ArcShape,
      CircleShape,
      ShiningShape,
      RombShape,
    ],
    initialOption: null,
  );
  final shape8 = context.knobs.listOrNull(
    label: 'Shape 8 in list',
    options: [
      BaladyShape,
      DiamondShape,
      FlagRectangularShape,
      SmoothParallelogramShape,
      TrapezoidShape,
      ArcShape,
      CircleShape,
      ShiningShape,
      RombShape,
    ],
    initialOption: null,
  );
  final commonShape = context.knobs.listOrNull(
    label: 'Most common shape',
    options: [
      BaladyShape,
      DiamondShape,
      FlagRectangularShape,
      SmoothParallelogramShape,
      TrapezoidShape,
      ArcShape,
      CircleShape,
      ShiningShape,
      RombShape,
    ],
    initialOption: BaladyShape,
  );
  final commonShapeAppearance =
      context.knobs.int.input(label: 'How often the common shape will appear', initialValue: 1);

  final isClassicGradients = context.knobs.boolean(label: 'Classic gradients', initialValue: true);
  final commonGradientAppearance =
      context.knobs.int.input(label: 'How often the common gradient will appear', initialValue: 1);

  final gradient1Color1 = context.knobs.color(label: 'Gradient 1 color 1');
  final gradient1Color2 = context.knobs.color(label: 'Gradient 1 color 2');
  final gradient1Color3 = context.knobs.colorOrNull(label: 'Gradient 1 color 3');
  final gradient1Color4 = context.knobs.colorOrNull(label: 'Gradient 1 color 4');

  final enableGradient2 = context.knobs.boolean(label: 'Enable gradient 2');
  final gradient2Color1 = context.knobs.color(label: 'Gradient 2 color 1');
  final gradient2Color2 = context.knobs.color(label: 'Gradient 2 color 2');
  final gradient2Color3 = context.knobs.colorOrNull(label: 'Gradient 2 color 3');
  final gradient2Color4 = context.knobs.colorOrNull(label: 'Gradient 2 color 4');

  final enableGradient3 = context.knobs.boolean(label: 'Enable gradient 3');
  final gradient3Color1 = context.knobs.color(label: 'Gradient 3 color 1');
  final gradient3Color2 = context.knobs.color(label: 'Gradient 3 color 2');
  final gradient3Color3 = context.knobs.colorOrNull(label: 'Gradient 3 color 3');
  final gradient3Color4 = context.knobs.colorOrNull(label: 'Gradient 3 color 4');

  final enableCommonGradient = context.knobs.boolean(label: 'Enable gradient 3');
  final gradientColor1 = context.knobs.color(label: 'Most common gradient color 1');
  final gradientColor2 = context.knobs.color(label: 'Most common gradient color 2');
  final gradientColor3 = context.knobs.colorOrNull(label: 'Most common gradient color 3');
  final gradientColor4 = context.knobs.colorOrNull(label: 'Most common gradient color 4');

  ConfettiShape Function(Offset, Offset, double, List<Color>, double, double, double) getShape(Type shape) {
    return switch (shape) {
      DiamondShape => (startPosition, velocity, growthScale, gradient, x, y, z) =>
          DiamondShape(startPosition, velocity, growthScale, gradient, x, y, z),
      ArcShape => (startPosition, velocity, growthScale, gradient, x, y, z) =>
          ArcShape(startPosition, velocity, growthScale, gradient, x, y, z),
      TrapezoidShape => (startPosition, velocity, growthScale, gradient, x, y, z) =>
          TrapezoidShape(startPosition, velocity, growthScale, gradient, x, y, z),
      FlagRectangularShape => (startPosition, velocity, growthScale, gradient, x, y, z) =>
          FlagRectangularShape(startPosition, velocity, growthScale, gradient, x, y, z),
      SmoothParallelogramShape => (startPosition, velocity, growthScale, gradient, x, y, z) =>
          SmoothParallelogramShape(startPosition, velocity, growthScale, gradient, x, y, z),
      CircleShape => (startPosition, velocity, growthScale, gradient, x, y, z) =>
          CircleShape(startPosition, velocity, growthScale, gradient, x, y, z),
      ShiningShape => (startPosition, velocity, growthScale, gradient, x, y, z) =>
          ShiningShape(startPosition, velocity, growthScale, gradient, x, y, z),
      RombShape => (startPosition, velocity, growthScale, gradient, x, y, z) =>
          RombShape(startPosition, velocity, growthScale, gradient, x, y, z),
      _ => (startPosition, velocity, growthScale, gradient, x, y, z) =>
          BaladyShape(startPosition, velocity, growthScale, gradient, x, y, z),
    };
  }

  final config = ConfettiGeneratorConfig(
    count: count,
    animationCurve: getCurve(animationCurve),
    animationDuration: Duration(milliseconds: duration),
    rotationSpeedX: rotationX,
    rotationSpeedY: rotationY,
    rotationSpeedZ: rotationZ,
    startScaleMin: startScaleMin,
    startPositionMinX: startPositionMinX,
    startPositionMaxX: startPositionMaxX,
    startPositionMinY: startPositionMinY,
    startPositionMaxY: startPositionMaxY,
    velocityMinX: velocityMinX,
    velocityMaxX: velocityMaxX,
    velocityMinY: velocityMinY,
    velocityMaxY: velocityMaxY,
    scaleGrowthMin: scaleGrowthMin,
    scaleGrowthMax: scaleGrowthMax,
    confettiShapes: [
      getShape(shape1),
      if (shape2 != null) getShape(shape2),
      if (shape3 != null) getShape(shape3),
      if (shape4 != null) getShape(shape4),
      if (shape5 != null) getShape(shape5),
      if (shape6 != null) getShape(shape6),
      if (shape7 != null) getShape(shape7),
      if (shape8 != null) getShape(shape8),
    ],
    mostCommonConfettiShape: commonShape != null ? getShape(commonShape) : null,
    gradientColors: isClassicGradients
        ? kConfettiGradientList
        : [
            [
              gradient1Color1,
              gradient1Color2,
              if (gradient1Color3 != null) gradient1Color3,
              if (gradient1Color4 != null) gradient1Color4,
            ],
            if (enableGradient2)
              [
                gradient2Color1,
                gradient2Color2,
                if (gradient2Color3 != null) gradient2Color3,
                if (gradient2Color4 != null) gradient2Color4,
              ],
            if (enableGradient3)
              [
                gradient3Color1,
                gradient3Color2,
                if (gradient3Color3 != null) gradient3Color3,
                if (gradient3Color4 != null) gradient3Color4,
              ],
          ],
    commonGradientAppearance: commonGradientAppearance,
    commonShapeAppearance: commonShapeAppearance,
    mostCommonGradientColors: enableCommonGradient
        ? [
            gradientColor1,
            gradientColor2,
            if (gradientColor3 != null) gradientColor3,
            if (gradientColor4 != null) gradientColor4,
          ]
        : null,
    disappearStartsAt: disappearStartsAt,
    disappearBehavior: disappearBehavior,
    disappearCurve: getCurve(disappearCurve),
  );

  const constaraints = BoxConstraints(maxWidth: 366, maxHeight: 660);

  return Stack(
    children: [
      Center(
        child: ConstrainedBox(
          constraints: constaraints,
          child: Image.asset(
            'assets/images/balady_map.png',
            fit: BoxFit.cover,
            height: 660,
          ),
        ),
      ),
      MapControls.idle(
        indoorControl: IndoorControl(
          onSelect: (_) {},
        ),
        searchInArea: const SearchInArea(
          visible: false,
          title: 'Search in area',
        ),
        layersControl: const LayersControl(),
        trafficControl: const TrafficControl(opacity: 0, isEnabled: false),
        zoomControl: const ZoomControl(zoomInDisabled: true, zoomOutDisabled: true),
        compassControl: const CompassControl(angle: 1, opacity: 0),
        followControl: const FollowControl(opacity: 0),
        weatherControl: const WeatherControl(value: 30),
        happinesControl: HappinesControl(onTap: () {
          showVoteDialog(context, config, constaraints, showLoading: showDialog);
        }),
        quiblahControl: const QuiblahControl(),
      ),
    ],
  );
}
