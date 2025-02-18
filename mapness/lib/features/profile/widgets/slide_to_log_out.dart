import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';

class SlideToLogout extends StatefulWidget {
  final VoidCallback onLogout;

  const SlideToLogout({required this.onLogout, super.key});

  @override
  State<SlideToLogout> createState() => _SlideToLogoutState();
}

class _SlideToLogoutState extends State<SlideToLogout> {
  static const slideSize = 48.0;

  double _dragPosition = 0;
  final radius = BorderRadius.circular(10);

  Color get _backgroundColor => context.colorsV2.errorContainerDefault;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (ctx, constraints) {
          final maxWidth = constraints.maxWidth - slideSize;
          return Stack(
            children: [
              Container(
                alignment: AlignmentDirectional.centerStart,
                height: slideSize,
                decoration: BoxDecoration(
                  color: _backgroundColor,
                  borderRadius: radius,
                ),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(start: slideSize + Spacing.$6x),
                  child: Text(
                    'Slide to Logout',
                    style: context.textStyleV3.buttonL.copyWith(
                      color: context.colorsV2.errorDefault,
                    ),
                  ),
                ),
              ),
              AnimatedContainer(
                duration: Durations.short2,
                height: slideSize,
                width: _dragPosition + slideSize,
                decoration: BoxDecoration(
                  color: context.colorsV2.errorDefault.withOpacity(0.7),
                  borderRadius: radius,
                ),
              ),
              AnimatedPositionedDirectional(
                duration: Durations.short2,
                start: _dragPosition,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      _dragPosition = (_dragPosition + details.delta.dx.abs()).clamp(0, maxWidth);
                    });
                  },
                  onHorizontalDragEnd: (details) {
                    if (_dragPosition >= maxWidth - maxWidth / 3) {
                      widget.onLogout();
                      setState(() {
                        _dragPosition = maxWidth;
                      });
                    } else {
                      setState(() => _dragPosition = 0);
                    }
                  },
                  child: Container(
                    width: slideSize,
                    height: slideSize,
                    decoration: BoxDecoration(
                      color: context.colorsV2.errorDefault,
                      borderRadius: radius,
                    ),
                    child: Icon(
                      SystemIcons.arrowRight,
                      size: 24,
                      color: context.colorsV2.staticWhite,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
}
